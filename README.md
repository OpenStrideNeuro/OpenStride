# OpenStride 

Welcome to **OpenStride**, an open-source platform that integrates both **hardware and software** for rodent behaviour recording and analysis using a force-plate actometer system. **Please read the following to ensure smooth installation of OpenStride; otherwise, problems may ensue**. 

OpenStride is designed to provide a **low-cost, accessible, and reproducible** solution for laboratories studying locomotion and motor behaviour. OpenStride has been created by the Anderson Group within the School of Medical Sciences, The University of Sydney. For further technical detail please refer to the publication:

Yang et al. (2025). *OpenStride: an inexpensive, open-source force plate actometry system for quantification of rodent motor activity and behaviour.* bioRxiv. https://doi.org/10.64898/2025.12.17.695041
 
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

Separate versions are provided for different operating systems:

- 🪟 **[Windows Version](https://github.com/cander49/OpenStride/tree/main/software/windows)**
- 🍎 **[macOS Version](https://github.com/cander49/OpenStride/tree/main/software/mac/OpenStride%20-%20Mac)**

This section includes an installation list of external software, packages and toolboxes: 

- Python
- Python Packages
- Phidget22
- MATLAB
- MATLAB Toolboxes

To ensure all dependencies are installed as the correct package version, run in the terminal in the same directory as OpenStride:

```bash
pip install -r requirements.txt
```

Further to this, if any dependeny issues are occurring, consider using a virtual environment to isolate project dependencies, run in the terminal in the same directory as OpenStride:

```bash
python3 -m venv .venv # creating a virtual environment
# source .venv/bin/activate   # macOS
# .venv\Scripts\activate    # Windows
pip install -r requirements.txt
```

---


## Using OpenStride
