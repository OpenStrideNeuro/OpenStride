# OpenStride

**Note: the readme files for this github are currently under construction. All necessary files to construct and operate OpenStride are present, but the readme files will be updated in the immediate future. When readme edits are completed, this message will be removed. In the meantime, for any questions related to installation please email collin.anderson@sydney.edu.au **  \
  \
  \
  \
  \
  \
  \
  \
  \
  \
  \
Welcome to **OpenStride**, an open-source platform that integrates both **hardware and software** for rodent behaviour recording and analysis using a force-plate actometer system. **Please read the following to ensure smooth installation of OpenStride; otherwise, problems may ensue**. 

OpenStride is designed to provide a **low-cost, accessible, and reproducible** solution for laboratories studying locomotor and other behaviours. OpenStride was created by Collin Anderson's Laboratory in the School of Medical Sciences, The University of Sydney Faculty of Medicine and Health. For further technical detail please refer to the publication:

Yang et al. (2025). *OpenStride: an inexpensive, open-source force plate actometry system for quantification of rodent motor activity and behaviour.* bioRxiv. https://doi.org/10.64898/2025.12.17.695041 \
**Manuscript has been accepted for publication by Scientific Reports, and link will be updated when published.**
 
---

## Introduction

This repository contains the necessary files for the OpenStride system, consisting of two main folders:

- **Hardware** – contains the STL and SVG files, required for 3D printing and laser-cutting, as well as the Hardware Assembly Guide.
- **Software** – contains the downloadable program files for Windows and MacOS, as well as the Installation Guide for the respective operating systems.

Further information about each folder is below.

---

## Hardware

This folder contains the STL and SVG files for creating the platform that will **collect behavioural data**. Hardware Assembly Guide contains a walkthrough for the fabrication and assembly of the OpenStride system.

All assembly instructions, required files, and hardware documentation can be found here:

➡️ **[Hardware Assembly Guide](https://github.com/cander49/OpenStride/tree/main/hardware)**

This section includes:

- 3D printing files
- Laser cutting files
- Electronic components list
- Assembly instructions

The Hardware Assembly Guide includes:

- Overview
- Bill of Materials
- 3D Printing Guide
- Laser Cutting Guide
- OpenStride Assembly
- Troubleshooting 

---

## Software

This folder contains operating system dependent downloads, for MacOS and Windows. The programs within these folders require careful installation of various programs, ensure that you read through the Software Installation Guide. The OpenStride Software will be required for **recording data**, as well as the **processing of and analysing behavioural data**.

Separate versions are provided for different operating systems, with an installation guide on each page:

- **[Windows Version](https://github.com/cander49/OpenStride/tree/main/software/windows)**
- **[macOS Version](https://github.com/cander49/OpenStride/tree/main/software/mac/OpenStride%20-%20Mac)**

This section includes an installation list of external software, packages and toolboxes: 

- Python 3.10+
- Python Packages
- Phidget22
- MATLAB
- MATLAB Toolboxes

To ensure all dependencies are installed as the correct package version, run in the terminal in the same directory as OpenStride:

```bash
pip3 install -r requirements.txt
```

Further to this, if any dependeny issues are occurring, consider using a virtual environment to isolate project dependencies, run in the terminal in the same directory as OpenStride:

```bash
python3 -m venv .venv # creating a virtual environment
# source .venv/bin/activate   # macOS
# .venv\Scripts\activate    # Windows
pip install -r requirements.txt
```

---


## Using OpenStride、

### Important Note (Dark Mode)
Before using the OpenStride UI, please ensure that **Dark Mode is turned off** on your operating system.

Due to limitations in **MATLAB App Designer**, the UI elements required for OpenStride may not display correctly when Dark Mode is enabled. This applies to both **Windows** and **macOS** systems.  
Please switch your system to **Light Mode** before launching the software.

---

### Default UI Interface

When OpenStride is launched, the UI opens in **Data Recording Mode** by default.

This mode requires that **both the hardware and software have been correctly installed and configured**.

Please ensure the following installation steps have been completed before attempting data acquisition:

*   [Link to Hardware Install](https://github.com/OpenStrideNeuro/OpenStride/tree/main/hardware)
*   [Link to Software Install](https://github.com/OpenStrideNeuro/OpenStride/tree/main/software)

Only after completing the above installation steps will the **data acquisition system function correctly**.

---

### Switching Between Recording and Analysis Modes


<img width="1795" height="1462" alt="OpenStride UI Overview" src="https://github.com/user-attachments/assets/73f9af83-982d-41e8-b64d-17a5e7d4ff94" />


The button highlighted in red in the image above is **“Switch to Analysis”**.

This button allows users to switch between:

- **Recording Mode (default)**
- **Analysis Mode**

You can switch between these modes **at any time**.  
All settings and text entries made in either mode will **remain saved unless the UI is closed**.

---

### Calibration


Calibration is required under the following circumstances:

- When using OpenStride on **a newly installed computer**
- When the **OpenStride software has been freshly installed**
- When the **OpenStride hardware setup has been moved**
- When using **a new force plate**
- When using **a different experimental setup**

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/88e1d7ac-e662-4a15-a615-10caa15adb97" />

If the plate and setup **have not been moved or modified**, calibration **does not need to be performed before every recording session**.

However, to ensure **maximum accuracy of trajectory data**, calibration is strongly recommended whenever any of the above changes occur. If commencing with calibration, ensure that no animal or object is placed on OpenStride. Further, ensure that the surface that OpenStride is ontop of is not disturbed during calibration.


---

### Select Output Folder


Click **“Select Output Folder”** to choose the directory where the recorded data will be stored.

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/5ae7f99b-34d8-433e-89b1-f4d592819951" />

After selecting a folder:

- A dialog window will appear.
- Choose the directory where the data should be saved.
- The selected folder path will appear in the **white text box on the right side**.

This step is **mandatory** before starting data acquisition.

---

### Output File Name


The **Folder Output File Name** defines the name of the data file for the current recording session.

The system will automatically append the **`.csv` file extension**.

You may also use the dropdown arrow to select **previously used file names**.


<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/6dcfc92f-50fa-4cd6-8149-964636eefd9a" />


⚠️ **Important**

Do **not reuse the same file name within the same output folder**.

If the same file name is used again in the same directory, the **new data file will overwrite the previous one**.

Please ensure that each recording session uses a **unique file name**.

---

### Notes Field

The **Note** field allows users to record experimental details.

These notes will be saved in the **header section of the CSV file**.

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/ccaec796-071f-4e51-80a3-70e8433a8787" />


You may use this field to document:

- Experimental setup
- Animal information
- Environmental conditions
- Any other relevant notes

This field is optional and **can be left blank if not required**.

---

### Experimental Animal Selection

Users can select the experimental animal:

- **Mouse**
- **Rat**

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/3516477b-32ab-48ba-a879-1a99f478b307" />


In the current version of OpenStride, this option is used **only for experimental metadata storage**.

However, this setting may become important in future versions as additional analysis algorithms are implemented.  

---

### Acquisition Settings

Within **Recording Mode**, the **Acquisition Settings** panel contains options for controlling recording behavior.

#### 1. Auto Stop

The **Auto Stop** option allows users to automatically stop recording after a specified duration.

Features include:

- User-defined recording duration
- Time unit selection (**minutes or hours**)
- Real-time display of:
  - Remaining time
  - Total recorded time

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/00009c45-ac49-4c6f-ac1e-59541d31f11b" />

---

#### 2. Discard First (Delay Start)

If researchers prefer to **leave the room after placing the animal in the enclosure**, this feature allows a delay before recording begins.

This ensures that **experimenter presence does not affect the animal's natural behavior**.

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/e002bec2-1a6e-4e4f-864a-f9aa83affed4" />


Settings include:

- Delay duration configurable in **seconds or minutes**
- The initial delay period will **not be included in the final data**

For example:

If a **2-second delay** is set, valid recording data will begin **2 seconds after pressing “Start Recording”**.

---

#### 3. Sample Frequency

The **Sample Frequency** determines the sensor sampling rate.

Since OpenStride uses a **Fidelity DAC card**, it supports a **range of sampling frequencies**.

Users can select the desired frequency from the **dropdown menu** within the supported range.

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/3ff7cfc7-3c4d-4707-9330-4d3c734e69fa" />



---

### Start Recording


After configuring all settings place the animal onto the force-plate and click **“Start Recording”**.

<img width="1788" height="1462" alt="image" src="https://github.com/user-attachments/assets/96e40408-9dd3-49a2-bdd3-0c92c410332a" />


Once recording begins:

- The system starts collecting sensor data
- A new window will appear displaying an **animated trajectory chart**
- The chart updates **in real time** as the animal moves

---
### Analysis Mode

To enter the **Analysis Mode**, click the **“Switch to Analysis”** button located at the top of the UI.

Once inside the Analysis Mode, you can click **“Switch to Record”** at any time to return to **Recording Mode**.

<img width="1790" height="1427" alt="image" src="https://github.com/user-attachments/assets/72937f15-680c-4fe9-8bf9-7bae810252c7" />



---

### Import Data


Click **“Import Data”** to open a file selection window.

From this window, you can select the data files you wish to analyse.  
Multiple files can be selected at the same time.

After importing the data, the files will appear in the **File List**.

<img width="1786" height="1420" alt="image" src="https://github.com/user-attachments/assets/b0a65dc4-5593-4447-bd7c-a5e5154f84e0" />

---

### Organising the Analysis Order

The order of the files in the list determines the **analysis sequence**.

This becomes important when analysing data from the **same animal across multiple sessions**.

In future analysis steps, when clicking **“Start Analysis”**, users may choose to **combine all selected data files into a single analysis**.  
In such cases, organising the correct order ensures the combined dataset follows the intended sequence.

The **Remove** function allows users to remove any unwanted data files from the list.

This is useful if:

- A file was imported accidentally
- The wrong dataset was selected
- Certain files should not be included in the current analysis

Removing unnecessary files helps keep the analysis workflow clean and organised.

---

### Analysis Methods

Currently, the software includes four analysis methods:

1. **Distance / Speed**
2. **Low Mobility Bouts**
3. **Tremor**
4. **Ataxia**

Future versions may include additional analysis modules.

Since **OpenStride is an open-source project**,  developers can add their **own analysis methods**.

New analysis modules can be implemented through **MATLAB App modules**, allowing users to extend the software with custom analysis pipelines.

---

### Output Folder Path

Before running the analysis, users must specify the **Output Folder Path**.

<img width="1786" height="1420" alt="image" src="https://github.com/user-attachments/assets/05cf40a3-1b72-4f5b-95a4-3cf11bc3a185" />


All generated outputs will be saved in this location, including:

- Result figures
- Numerical results
- Exported text files
- Analysis summaries

---

### Folder Name

Users can optionally define a **Folder Name** for the analysis results.

If no name is specified, the system will automatically generate a **unique folder name based on the timestamp when “Start Analysis” is clicked**.

<img width="1786" height="1420" alt="image" src="https://github.com/user-attachments/assets/56ddcc9a-d9cb-4e09-960c-843b32d0bcbe" />


---

### Analysis Results

Below are examples of the generated analysis outputs.

The results include visualisations and numerical summaries for:

1. **Distance / Speed**
2. **Low Mobility Bouts**
3. **Tremor**
4. **Ataxia**

All generated figures, tables, and result files will be automatically saved in the **selected output directory**.

---


****


