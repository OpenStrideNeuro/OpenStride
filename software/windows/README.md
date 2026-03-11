# OpenStride – Windows Installation Guide

---

This guide walks you through setting up all required software on **Windows** so that OpenStride can collect and process data from its physical devices.

> **Note:** Please install each component in the order listed below. Skipping ahead may cause errors.

---

## Installation: what you need to install

| # | Component | Purpose |
|---|-----------|---------|
| 1 | **Python 3.10+** | Collects data from OpenStride hardware |
| 2 | **Python packages** | Libraries that OpenStride depends on |
| 3 | **Phidget22 drivers** | Enables communication with Phidget hardware devices |
| 4 | **MATLAB** | Processes and analyses the collected data |
| 5 | **MATLAB toolboxes** | Required MATLAB add-ons for OpenStride's analysis pipeline |

---

## Quick Start

**Requirements:** Windows 10 or later · Python 3.10+ · A valid MATLAB license

**[1]** Install Python (3.10 or later) from the official website, making sure to check **Add Python to PATH** during installation:

🔗 [https://www.python.org/downloads/](https://www.python.org/downloads/)

**[2]** Install OpenStride's required Python packages. Navigate to your OpenStride project folder and run:

```bash
pip install -r requirements.txt
```

**[3]** Install the Phidget22 drivers for Windows:

🔗 [https://www.phidgets.com/docs/OS_-_Windows](https://www.phidgets.com/docs/OS_-_Windows)

**[4]** Install MATLAB (R2021a or later recommended) and the required toolboxes:

🔗 [https://www.mathworks.com/downloads/](https://www.mathworks.com/downloads/)

---

## Detailed Installation

The sections below walk through each step in detail with screenshots.

---

# Part 1 – Python

Python is a free, open-source programming language. OpenStride uses Python to collect data from its hardware — handling the communication between your computer and the physical devices connected to it.

> **Currently, only Python 3.10+ is supported.**

---

### Step 1.1 – Download Python

Go to the official Python downloads page and download the Windows installer:

🔗 [https://www.python.org/downloads/](https://www.python.org/downloads/)


Choose the right installer for your machine:

| Installer | When to use |
|-----------|-------------|
| **Windows installer (64-bit)** ✅ | Most users — choose this |
| Windows installer (32-bit) | Only for very old computers (pre-2010) |
| Windows installer (ARM64) | Only for ARM-based devices (e.g. Surface Pro X) |


---

### Step 1.2 – Run the Installer

1. Open your **Downloads** folder
2. Double-click the file (e.g. `python-3.x.x-amd64.exe`)


---

### Step 1.3 – ⚠️ Enable "Add Python to PATH"

Before clicking **Install Now**, check the box at the bottom of the installer window:

> ☑️ **Add Python to PATH**

**This step is critical.** Without it, Windows will not be able to find Python when you run commands, and you will need to uninstall and reinstall to fix it.


Once checked, click **Install Now** and wait for the installation to complete (~1–3 min), then click **Close**.


---

### Step 1.4 – Verify

Open **Command Prompt** (`Start` → search `cmd` → press Enter) and run:

```bash
python --version
```

Expected output:

```
Python 3.x.x
```


✅ You see a version number → move to Part 2.  
❌ You see `'python' is not recognized` → Python was not added to PATH. Reinstall and repeat Step 1.3.

---

# Part 2 – Python Packages

Python packages are libraries that extend Python's functionality. OpenStride lists all its required packages in a file called `requirements.txt`, included in the project folder.

---

### Step 2.1 – Navigate to the OpenStride Folder

Open **Command Prompt** and navigate to where you downloaded OpenStride. Replace the path below with your actual folder location:

```bash
cd C:\Users\YourName\Downloads\OpenStride
```

> 💡 **Tip:** In File Explorer, open the OpenStride folder and copy the path from the address bar at the top.


---

### Step 2.2 – Install Packages

Run the following command:

```bash
pip install -r requirements.txt
```

This automatically installs everything OpenStride needs. It may take a few minutes.


Wait until you see:

```
Successfully installed [packages...]
```

✅ Installation successful → move to Part 3.  
❌ You see an error → confirm you are in the correct folder and that Python installed correctly (Part 1).

---

# Part 3 – Phidget22 Drivers

Phidget22 drivers enable OpenStride to communicate with the Phidget sensor hardware connected to your computer. Without these drivers, OpenStride cannot read from the physical devices.

---

### Step 3.1 – Download and Install

Download Phidget22 from the link below:

🔗 [Phidget22 Windows Installer](LINK)

Run the installer and follow the on-screen steps. Click **Finish** when complete.

---

### Step 3.2 – Verify

Open **Phidget Control Panel** from the Start menu. If it opens without errors, the drivers are installed correctly.

> 💡 **Tip:** Once calibrated, you can close and reopen the app without needing to recalibrate.

---

# Part 4 – MATLAB

MATLAB is a numerical computing environment. OpenStride uses MATLAB to process and analyse the motion data collected from the hardware.

> ⚠️ **MATLAB requires a paid license.** If you do not already have one, contact your institution or lab administrator.

---

### Step 4.1 – Download and Install

Sign in to your MathWorks account and download the MATLAB installer for Windows:

🔗 [https://www.mathworks.com/downloads/](https://www.mathworks.com/downloads/)


Run the installer, sign in when prompted, and follow the on-screen steps.


---

### Step 4.2 – Verify

Open MATLAB from the Start menu or desktop shortcut. Confirm it launches without errors.


---

# Part 5 – MATLAB Toolboxes

MATLAB toolboxes are official add-ons that extend what MATLAB can do. OpenStride's analysis pipeline depends on several specific toolboxes.

---

### Step 5.1 – Open the Add-On Manager

In MATLAB, go to **Home** → **Add-Ons** → **Get Add-Ons**.


---

### Step 5.2 – Install Required Toolboxes

Search for and install each of the following toolboxes:

| Toolbox | Version |
|---------|---------|
| **Image Processing Toolbox** | R2025a |
| **Signal Processing Toolbox** | R2025a |
| **Simulink 3D Animation** | R2025a |
| **Statistics and Machine Learning Toolbox** | R2025a |

For each toolbox: search by name → click the result → click **Install**.

---

### Step 5.3 – Verify

In the MATLAB Command Window, run:

```matlab
ver
```

Check that all required toolboxes appear in the output list.


---

# ✅ Installation Complete

You have successfully installed all components required to run OpenStride:

- ✅ Python 3.10+
- ✅ Python packages
- ✅ Phidget22 drivers
- ✅ MATLAB
- ✅ MATLAB toolboxes

You are now ready to launch OpenStride. See the **[Quick Start Guide](#)** for your first steps with the software.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `'python' is not recognized` | Reinstall Python — make sure **Add Python to PATH** is checked (Step 1.3) |
| `pip` command not found | Same as above — Python is not in PATH |
| Phidget Control Panel won't open | Restart your computer after the Phidget22 installation |
| MATLAB licence error | Verify your MathWorks licence is active at [mathworks.com](https://www.mathworks.com) |
| A required MATLAB toolbox is missing | Re-open Add-On Manager and search for the toolbox again |

> 💬 If you continue to experience issues, please open an issue via **[Reporting Issues](#)** or reach out through **[Getting Assistance](#)**.

---

*OpenStride Windows Installation Guide · Last updated 2026*
