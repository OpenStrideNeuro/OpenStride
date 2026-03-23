import datetime
import json
import os
import sys

if getattr(sys, 'frozen', False):
    CURRENT_DIR = os.path.dirname(sys.executable)
else:
    CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

PARENT_DIR = os.path.dirname(CURRENT_DIR)
TEMP_FOLDER = os.path.join(PARENT_DIR, "temp")
os.makedirs(TEMP_FOLDER, exist_ok=True)

LOG_FILE = os.path.join(TEMP_FOLDER, "phidget_log.log")

def log_message(message, level="INFO"):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{timestamp}] [{level}] {message}\n"
    with open(LOG_FILE, "a") as f:
        f.write(line)