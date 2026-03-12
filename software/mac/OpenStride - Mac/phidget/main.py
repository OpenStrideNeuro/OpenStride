import os
import sys

# ── Re-exec with the venv Python if MATLAB launched us with the system python3.
# os.execv replaces the current process image (same PID / nohup context) so
# MATLAB's launch command does not need to change.
# main.py is at: <repo>/software/mac/OpenStride - Mac/phidget/main.py
# venv is at:    <repo>/.venv/  →  4 levels up from phidget/
_here = os.path.dirname(os.path.abspath(__file__))
_venv_python = os.path.normpath(
    os.path.join(_here, '..', '..', '..', '..', '.venv', 'bin', 'python')
)
if (os.path.isfile(_venv_python) and
        os.path.realpath(sys.executable) != os.path.realpath(_venv_python)):
    os.execv(_venv_python, [_venv_python] + sys.argv)

# ── From here we are guaranteed to be running under the venv Python ──────────
import json

from calibration import run_calibration
from record import run_record
from utils import log_message

CURRENT_DIR  = _here if not getattr(sys, 'frozen', False) else os.path.dirname(sys.executable)
TEMP_FOLDER  = os.path.join(os.path.dirname(_here), "temp")
os.makedirs(TEMP_FOLDER, exist_ok=True)
COMMAND_FILE = os.path.join(TEMP_FOLDER, "command.json")
LOG_FILE     = os.path.join(TEMP_FOLDER, "phidget_log.log")


def main():
    if not os.path.exists(COMMAND_FILE):
        log_message(f"Command file {COMMAND_FILE} not found.", level="ERROR")
        return

    with open(COMMAND_FILE, 'r') as f:
        try:
            command = json.load(f)
        except json.JSONDecodeError:
            log_message("Failed to parse command.json.", level="ERROR")
            return

    cmd_type = command.get("type", "").lower()

    if cmd_type == "calibration":
        run_calibration()
    elif cmd_type == "record":
        run_record(command)
    else:
        log_message(f"Unknown type '{cmd_type}' in command.json.", level="ERROR")


def clean_log_file():
    if os.path.exists(LOG_FILE):
        os.remove(LOG_FILE)


if __name__ == "__main__":
    clean_log_file()   # wipes the debug lines above only when imports succeeded
    main()
