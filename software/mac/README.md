# OpenStride – macOS Installation Guide

---

This guide walks you through setting up all required software on **macOS** so that OpenStride can collect and process data from its physical devices.

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

**Requirements:** macOS 12 (Monterey) or later · Python 3.10+ · A valid MATLAB license

**[1]** Install Python (3.10 or later) from the official website:

🔗 [https://www.python.org/downloads/](https://www.python.org/downloads/)

**[2]** Install OpenStride's required Python packages. Navigate to your OpenStride project folder in Terminal and run:

```bash
pip3 install -r requirements.txt
```

**[3]** Install the Phidget22 drivers for macOS:

🔗 [Phidget22 macOS Installer](LINK)

**[4]** Install MATLAB R2025a and the required toolboxes:

🔗 [https://www.mathworks.com/downloads/](https://www.mathworks.com/downloads/)

---

## Detailed Installation

The sections below walk through each step in detail.

---

# Part 1 – Python

Python is a free, open-source programming language. OpenStride uses Python to collect data from its hardware — handling the communication between your computer and the physical devices connected to it.

> **Currently, only Python 3.10+ is supported.**

---

### Step 1.1 – Download Python

Go to the official Python downloads page and download the macOS installer:

🔗 [https://www.python.org/downloads/](https://www.python.org/downloads/)


The page should automatically suggest the latest version for macOS. Click **Download Python 3.x.x** to begin.

---

### Step 1.2 – Run the Installer

1. Open your **Downloads** folder
2. Double-click the file (e.g. `python-3.x.x-macos11.pkg`)
3. Follow the on-screen steps and click **Continue** through each screen
4. Click **Install** when prompted — macOS may ask for your password
5. Click **Close** when the installation is complete


---

### Step 1.3 – Verify

Open **Terminal** (`Cmd + Space` → search `Terminal` → press Enter) and run:

```bash
python3 --version
```

Expected output:

```
Python 3.x.x
```

✅ You see a version number → move to Part 2.  
❌ You see `command not found` → the installer may not have completed correctly. Repeat Step 1.2.

> 💡 **Note:** On macOS, always use `python3` instead of `python`, and `pip3` instead of `pip`.

---

# Part 2 – Python Packages

Python packages are libraries that extend Python's functionality. OpenStride lists all its required packages in a file called `requirements.txt`, included in the project folder.

---

### Step 2.1 – Navigate to the OpenStride Folder

Open **Terminal** and navigate to where you downloaded OpenStride. Replace the path below with your actual folder location:

```bash
cd /Users/YourName/Downloads/OpenStride
```

> 💡 **Tip:** In Finder, open the OpenStride folder, then drag the folder icon from the top of the Finder window directly into Terminal — it will paste the full path automatically.

---

### Step 2.2 – Install Packages

Run the following command:

```bash
pip3 install -r requirements.txt
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

🔗 [Phidget22 macOS Installer](LINK)

1. Open the downloaded `.dmg` file
2. Follow the on-screen instructions to complete the installation
3. If macOS shows a security warning, go to **System Settings** → **Privacy & Security** → click **Allow Anyway**


---

### Step 3.2 – Verify

Open **Phidget Control Panel** from your Applications folder. If it opens without errors, the drivers are installed correctly.


> 💡 **Tip:** Once calibrated, you can close and reopen the app without needing to recalibrate.

---

# Part 4 – MATLAB

MATLAB is a numerical computing environment. OpenStride uses MATLAB to process and analyse the motion data collected from the hardware.

> ⚠️ **MATLAB requires a paid license and OpenStride requires MATLAB R2025a.** If you do not already have one, contact your institution or lab administrator.

---

### Step 4.1 – Download and Install

Sign in to your MathWorks account and download the MATLAB installer for macOS:

🔗 [https://www.mathworks.com/downloads/](https://www.mathworks.com/downloads/)

1. Open the downloaded `.dmg` file
2. Double-click the MATLAB installer
3. Sign in with your MathWorks account when prompted
4. Follow the on-screen steps to complete the installation

---

### Step 4.2 – Verify

Open MATLAB from your **Applications** folder. Confirm it launches without errors.


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
- ✅ MATLAB R2025a
- ✅ MATLAB toolboxes

You are now ready to launch OpenStride. See the **[Quick Start Guide](#)** for your first steps with the software.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `command not found: python3` | Reinstall Python from [python.org](https://www.python.org/downloads/) |
| `command not found: pip3` | Same as above — Python did not install correctly |
| macOS blocks the Phidget22 installer | Go to **System Settings** → **Privacy & Security** → click **Allow Anyway** |
| Phidget Control Panel won't open | Restart your computer after the Phidget22 installation |
| MATLAB licence error | Verify your MathWorks licence is active at [mathworks.com](https://www.mathworks.com) |
| A required MATLAB toolbox is missing | Re-open Add-On Manager and search for the toolbox again |

> 💬 If you continue to experience issues, please get in contact with the OpenStride team.
---

*OpenStride macOS Installation Guide · Last updated 2026*
