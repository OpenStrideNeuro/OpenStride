from utils import log_message
from Phidget22.Phidget import *
from Phidget22.Devices.VoltageRatioInput import *
import time
import datetime
import json
import traceback
import os

if getattr(sys, 'frozen', False):
    CURRENT_DIR = os.path.dirname(sys.executable)
else:
    CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

PARENT_DIR = os.path.dirname(CURRENT_DIR)
TEMP_FOLDER = os.path.join(PARENT_DIR, "temp")
os.makedirs(TEMP_FOLDER, exist_ok=True)

LOG_FILE = os.path.join(TEMP_FOLDER, "phidget_log.log")
CALIBRATION_FILE = os.path.join(TEMP_FOLDER, "phidget_calibration.json")

SUPPORTED_GAINS = [64]
DURATION = 30  # seconds
SAMPLE_RATE = 125  # Hz

OFFSETS = [0, 0, 0, 0]
GAINS = [1, 1, 1, 1]

def clean_calibration_file():
    if os.path.exists(CALIBRATION_FILE):
        os.remove(CALIBRATION_FILE)
        log_message(f"Deleted old calibration file: {CALIBRATION_FILE}")

def initialize_phidget_channels():
    log_message("Initializing PhidgetBridge 1046...")
    channels = []
    for i in range(4):
        try:
            ch = VoltageRatioInput()
            ch.setChannel(i)
            ch.openWaitForAttachment(5000)
            ch.setBridgeEnabled(True)
            ch.setDataInterval(8)
            for gain in SUPPORTED_GAINS:
                try:
                    ch.setBridgeGain(gain)
                    break
                except PhidgetException:
                    continue
            channels.append(ch)
            log_message(f"Channel {i} connected successfully.")
        except PhidgetException as e:
            log_message(f"Failed to connect channel {i}: {e}", level="ERROR")
    return channels

def collect_sensor_data(channels):
    log_message("Starting data collection...")
    sensor_data = [[] for _ in range(4)]
    start_time = time.time()
    while time.time() - start_time < DURATION:
        for i, ch in enumerate(channels):
            try:
                vr = ch.getVoltageRatio()
                sensor_data[i].append(vr)
            except PhidgetException as e:
                log_message(f"Sensor {i} error: {e}", level="WARNING")
                sensor_data[i].append(None)
        time.sleep(1 / SAMPLE_RATE)
    log_message("Data collection completed.")
    return sensor_data

def compute_averages(sensor_data):
    averages = []
    for i, data in enumerate(sensor_data):
        valid = [d for d in data if d is not None]
        avg = sum(valid) / len(valid) if valid else 0
        averages.append(avg)
        log_message(f"Sensor {i} average: {avg}")
    return averages

def save_calibration(offsets, gains):
    timestamp = datetime.datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    calibration_data = {
        "Timestamp": timestamp,
        "Offsets": offsets,
        "Gains": gains
    }
    with open(CALIBRATION_FILE, "w") as f:
        json.dump(calibration_data, f, indent=4)
    log_message(f"Calibration saved to {CALIBRATION_FILE}")

def run_calibration():
    try:
        clean_calibration_file()
        log_message("Calibration started.")
        channels = initialize_phidget_channels()

        time.sleep(1)

        zero_data = collect_sensor_data(channels)
        offsets = compute_averages(zero_data)
        log_message(f"Offsets computed: {offsets}")

        # Skip load measurement and gain calculation; use fixed gains = [1,1,1,1]
        gains = [1, 1, 1, 1]

        save_calibration(offsets, gains)

        for ch in channels:
            ch.close()

        log_message("Phidget calibration completed.")
    except Exception as e:
        log_message(f"Calibration error: {str(e)}", level="ERROR")
        traceback.print_exc()

def load_calibration():
    global OFFSETS, GAINS
    if os.path.exists(CALIBRATION_FILE):
        with open(CALIBRATION_FILE, "r") as f:
            cal = json.load(f)
            OFFSETS = cal.get("Offsets", [0, 0, 0, 0])
            GAINS = cal.get("Gains", [1, 1, 1, 1])
        log_message(f"Loaded calibration: Offsets={OFFSETS}, Gains={GAINS}")

