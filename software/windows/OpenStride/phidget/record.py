from Phidget22.Phidget import *
from Phidget22.Devices.VoltageRatioInput import *
import time
import threading
import csv
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from matplotlib.collections import LineCollection
import json
import os
import sys
import numpy as np
from utils import log_message

NUM_CHANNELS = 4
running = True
xy_trajectory = []
data_lock = threading.Lock()
positions = {0: (0, 30), 1: (0, 0), 2: (30, 0), 3: (30, 30)}
channel_buffers = [[[] for _ in range(NUM_CHANNELS)], [[] for _ in range(NUM_CHANNELS)]]
calibration_offsets = [0.0] * NUM_CHANNELS
calibration_gains = [1.0] * NUM_CHANNELS
record_start_time = None
discard_sec = 0
auto_stop_sec = 0

if getattr(sys, 'frozen', False):
    CURRENT_DIR = os.path.dirname(sys.executable)
else:
    CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

PARENT_DIR = os.path.dirname(CURRENT_DIR)
TEMP_FOLDER = os.path.join(PARENT_DIR, "temp")
TERMINATE_FLAG = os.path.join(TEMP_FOLDER, "terminate.flag")
SAVE_INTERVAL = 10 * 60


def get_command(command):
    file_name = command.get("output_file_name", "") or "phidget_data.csv"
    if not file_name.lower().endswith(".csv"):
        file_name += ".csv"

    raw_output_folder = command.get("output_folder", [])
    if isinstance(raw_output_folder, list):
        output_folder = raw_output_folder
    else:
        output_folder = [raw_output_folder]

    return {
        "file_name": file_name,
        "note": command.get("note", []),
        "output_folder": output_folder or [CURRENT_DIR],
        "auto_stop_enabled": command.get("auto_stop", {}).get("enabled", False),
        "auto_stop_value": command.get("auto_stop", {}).get("value", 0),
        "auto_stop_unit": command.get("auto_stop", {}).get("unit", "seconds"),
        "discard_enabled": command.get("discard", {}).get("enabled", False),
        "discard_value": command.get("discard", {}).get("value", 0),
        "discard_unit": command.get("discard", {}).get("unit", "seconds"),
        "frequency": command.get("frequency", 125),
        "animal": command.get("animal", "Unknown")
    }


def run_record(command):
    global running, calibration_offsets, calibration_gains
    global discard_sec, auto_stop_sec, record_start_time, xy_trajectory

    cmd = get_command(command)
    running = True
    discard_sec = 0
    auto_stop_sec = 0
    record_start_time = None
    xy_trajectory = []

    output_dir = cmd["output_folder"]
    if isinstance(output_dir, list):
        output_dir = output_dir[0]
    os.makedirs(output_dir, exist_ok=True)
    data_save_path = os.path.join(output_dir, cmd["file_name"])

    calibration_path = os.path.join(TEMP_FOLDER, "phidget_calibration.json")
    try:
        with open(calibration_path, 'r') as f:
            data = json.load(f)
            offsets = data.get("Offsets", [])
            gains = data.get("Gains", [])
            if len(offsets) == NUM_CHANNELS and len(gains) == NUM_CHANNELS:
                calibration_offsets = offsets
                calibration_gains = gains
                log_message(f"Calibration loaded: Offsets={offsets}, Gains={gains}")
    except Exception as e:
        log_message(f"Calibration file not found or error: {e}")

    sample_interval_ms = max(8, int(1000 / cmd["frequency"]))

    if cmd["auto_stop_enabled"]:
        auto_stop_sec = (
            cmd["auto_stop_value"] * 60
            if cmd["auto_stop_unit"] == "minutes"
            else cmd["auto_stop_value"]
        )
        log_message(f"Auto-stop enabled after {auto_stop_sec} seconds.")

    if cmd["discard_enabled"]:
        discard_sec = (
            cmd["discard_value"] * 60
            if cmd["discard_unit"] == "minutes"
            else cmd["discard_value"]
        )
        log_message(f"Discard enabled: first {discard_sec} seconds of data will be ignored.")

    if os.path.exists(TERMINATE_FLAG):
        os.remove(TERMINATE_FLAG)

    def onVoltageRatioChange(self, voltageRatio):
        global record_start_time
        if not running:
            return

        timestamp = time.perf_counter()
        if record_start_time is None:
            record_start_time = timestamp

        elapsed = timestamp - record_start_time
        if discard_sec and elapsed < discard_sec:
            return

        channel = self.getChannel()
        with data_lock:
            channel_buffers[0][channel].append((timestamp, voltageRatio))
            if all(len(channel_buffers[0][ch]) > 0 for ch in range(NUM_CHANNELS)):
                scale_factor = 333333.33
                vals = {
                    ch: (channel_buffers[0][ch][-1][1] - calibration_offsets[ch])
                    * calibration_gains[ch]
                    * scale_factor
                    for ch in range(NUM_CHANNELS)
                }

                total_force = sum(vals.values())
                if total_force != 0:
                    x = sum(vals[ch] * positions[ch][0] for ch in range(NUM_CHANNELS)) / total_force
                    y = sum(vals[ch] * positions[ch][1] for ch in range(NUM_CHANNELS)) / total_force
                    xy_trajectory.append((x, y))

    def setup_channel(index):
        vinput = VoltageRatioInput()
        vinput.setChannel(index)
        vinput.openWaitForAttachment(5000)
        log_message(f"Channel {index} connected.")
        vinput.setBridgeGain(BridgeGain.BRIDGE_GAIN_64)
        vinput.setDataInterval(sample_interval_ms)
        vinput.setVoltageRatioChangeTrigger(0.0)
        vinput.setOnVoltageRatioChangeHandler(onVoltageRatioChange)
        return vinput

    def sampling_thread():
        global running
        channels = [setup_channel(i) for i in range(NUM_CHANNELS)]
        start_time = time.time()
        last_save_time = time.time()
        try:
            while running:
                now = time.time()
                if auto_stop_sec and (now - start_time) >= auto_stop_sec:
                    log_message("Auto-stop condition met.")
                    export_data()
                    break
                if os.path.exists(TERMINATE_FLAG):
                    log_message("External stop signal detected (terminate.flag).")
                    export_data()
                    break
                if now - last_save_time >= SAVE_INTERVAL:
                    export_data()
                    last_save_time = now
                time.sleep(0.001)
        finally:
            running = False
            for ch in channels:
                ch.close()

    def plot_trajectory():
        HISTORY_SECONDS = 20.0 
        SMOOTH_WINDOW = 25     

        window_points = int(cmd["frequency"] * HISTORY_SECONDS)

        fig, ax = plt.subplots()

        fig.subplots_adjust(right=0.78, top=0.9)

        fig.patch.set_facecolor((0.80, 0.84, 0.85))
        ax.set_facecolor((0.99, 1.00, 1.00))

        ax.set_xlim(0, 30)
        ax.set_ylim(0, 30)
        ax.set_xlabel("X position (cm)", color='#1C1C1C', fontsize=11)
        ax.set_ylabel("Y position (cm)", color='#1C1C1C', fontsize=11)
        ax.set_title(
            "OpenStride Real-time Trajectory",
            color='#1C5770',
            fontsize=13,
            fontweight='bold'
        )
        ax.set_aspect('equal', adjustable='box')

        for spine in ax.spines.values():
            spine.set_visible(False)
        ax.grid(True, linestyle='--', linewidth=0.5, alpha=0.3, color='#BAC7C9')

        line_collection = LineCollection([], linewidths=2)
        ax.add_collection(line_collection)
        base_color = (28 / 255, 87 / 255, 112 / 255)

        def format_seconds(sec):
            sec = max(0, float(sec))
            m = int(sec // 60)
            s = int(sec % 60)
            return f"{m:02d}:{s:02d}"

        def smooth_points(pts, window):

            n = pts.shape[0]
            if n == 0:
                return pts

            out = np.empty_like(pts)
            cumsum = np.cumsum(pts, axis=0)  # (n, 2)

            for i in range(n):
                start = max(0, i - window + 1)
                if start == 0:
                    total = cumsum[i]
                    count = i + 1
                else:
                    total = cumsum[i] - cumsum[start - 1]
                    count = i - start + 1
                out[i] = total / count

            return out

        # ===== Right-side status bar =====
        status_text = fig.text(
            0.98,
            0.9,
            '',
            ha='right',
            va='top',
            fontsize=9,
            color='#444444',
            bbox=dict(
                boxstyle='round',
                facecolor=(1, 1, 1, 0.9),
                edgecolor='#BAC7C9',
                linewidth=0.8
            )
        )

        def update(frame):
            with data_lock:
                traj_copy = list(xy_trajectory)  

            if len(traj_copy) >= 2:
                pts_raw = np.array(traj_copy[-window_points:]) 
                if pts_raw.shape[0] >= 2:
                    pts_smooth = smooth_points(pts_raw, SMOOTH_WINDOW)

                    segments = np.stack([pts_smooth[:-1], pts_smooth[1:]], axis=1)
                    n_seg = segments.shape[0]
                    alphas = np.linspace(0.0, 1.0, n_seg)
                    colors = [
                        (base_color[0], base_color[1], base_color[2], a)
                        for a in alphas
                    ]
                    line_collection.set_segments(segments)
                    line_collection.set_color(colors)
                else:
                    line_collection.set_segments([])
            else:
                line_collection.set_segments([])

            if record_start_time:
                elapsed = time.perf_counter() - record_start_time
            else:
                elapsed = 0.0

            if auto_stop_sec:
                timed_on = True
                remaining = max(auto_stop_sec - elapsed, 0)
                target_str = format_seconds(auto_stop_sec)
                remain_str = format_seconds(remaining)
            else:
                timed_on = False
                target_str = "--:--"
                remain_str = "--:--"

            elapsed_str = format_seconds(elapsed)

            status_lines = [
                f"Timed recording: {'ON' if timed_on else 'OFF'}",
                f"Target:   {target_str}",
                f"Elapsed:  {elapsed_str}",
                f"Remaining:{remain_str if timed_on else '--:--'}"
            ]
            status_text.set_text("\n".join(status_lines))

            artists = [line_collection, status_text]
            return artists

        ani = FuncAnimation(fig, update, interval=100, cache_frame_data=False)
        plt.show(block=False)
        return fig, ani

    def export_data():
        with data_lock:
            merged = [[] for _ in range(NUM_CHANNELS)]
            for ch in range(NUM_CHANNELS):
                merged[ch].extend(channel_buffers[0][ch])

        with open(data_save_path, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow([
                f"Animal={cmd['animal']}",
                f"Note={cmd['note']}",
                f"Frequency={cmd['frequency']}",
                f"AutoStop={cmd['auto_stop_enabled']} {cmd['auto_stop_value']} {cmd['auto_stop_unit']}"
            ])
            writer.writerow([
                "sample_index", "ch0_time", "ch0_value",
                "ch1_time", "ch1_value",
                "ch2_time", "ch2_value",
                "ch3_time", "ch3_value",
                "x", "y"
            ])
            min_len = min(len(merged[ch]) for ch in range(NUM_CHANNELS))
            for i in range(min_len):
                scale_factor = 333333.33
                vals = {
                    ch: (merged[ch][i][1] - calibration_offsets[ch])
                    * calibration_gains[ch]
                    * scale_factor
                    for ch in range(NUM_CHANNELS)
                }

                total_force = sum(vals.values())
                if total_force == 0:
                    continue

                x = sum(vals[ch] * positions[ch][0] for ch in range(NUM_CHANNELS)) / total_force
                y = sum(vals[ch] * positions[ch][1] for ch in range(NUM_CHANNELS)) / total_force

                row = [i]
                for ch in range(NUM_CHANNELS):
                    row.extend([merged[ch][i][0], vals[ch]])
                row.extend([x, y])
                writer.writerow(row)

        log_message("Final data saved.")

    # start sampling thread + open live window
    t_sample = threading.Thread(target=sampling_thread, daemon=True)
    t_sample.start()

    fig, ani = plot_trajectory()
    while running:
        plt.pause(0.5)
    plt.close(fig)
    t_sample.join()
    export_data()
    log_message("Recording complete.")