import json
import os
import sys
from calibration import run_calibration
from record import run_record
from utils import log_message

import sys
import os

if getattr(sys, 'frozen', False):
    CURRENT_DIR = os.path.dirname(sys.executable)
else:
    CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

PARENT_DIR = os.path.dirname(CURRENT_DIR)
TEMP_FOLDER = os.path.join(PARENT_DIR, "temp")
os.makedirs(TEMP_FOLDER, exist_ok=True)

COMMAND_FILE = os.path.join(TEMP_FOLDER, "command.json")

LOG_FILE = os.path.join(TEMP_FOLDER, "phidget_log.log")

def main():
    if not os.path.exists(COMMAND_FILE):
        log_message(f"Command file {COMMAND_FILE} not found.", level="ERROR")
        return

    with open(COMMAND_FILE, 'r') as f:
        try:
            command = json.load(f)
        except json.JSONDecodeError:
            log_message("Failed to parse command.json.", level="ERROR")
            print(1)
            
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
    clean_log_file()
    main()
