# OpenStride – Hardware Assembly Guide

---

This guide walks you through fabricating and assembling the OpenStride hardware, including 3D printing, laser cutting, and mechanical assembly.

> **Note:** Complete all fabrication steps (Parts 1 and 2) before beginning assembly (Part 3).

---

## Overview

| # | Step | What you are doing |
|---|------|--------------------|
| 1 | **3D Printing** | Print the structural components in PLA |
| 2 | **Laser Cutting** | Cut the acrylic enclosure panels |
| 3 | **Assembly** | Connect sensors, route wiring, and close the enclosure |

---

## Bill of Materials

| Category | Component | Specification | Source |
|----------|-----------|---------------|--------|
| **3D-printed parts** | Walk plate (×1) | PLA, 40–60% infill | STL files |
| | Plate holders (×4) | PLA, 40–60% infill | STL files |
| | Base plate (×1) | PLA, 40–60% infill | STL files |
| | Electronics chamber lid (×1) | PLA, 40–60% infill | STL files |
| **Laser-cut parts** | Acrylic enclosure Part A (×4) | 5 mm clear acrylic, 35 × 45 cm | SVG file |
| | Acrylic enclosure Part B (×4) | 5 mm clear acrylic, 35 × 45 cm | SVG file |
| **Ballast** | Concrete ballast | 35 × 35 × 5 cm | — |
| **Fasteners** | M3.5 flat-head screws (×8) | 316/316L stainless steel, 8 mm | — |
| | M3.5 flat-head screws (×8) | 316/316L stainless steel, 25 mm | — |
| **Sensors** | Single-point load cells (×4) | Tedea Huntleigh Model 1004, 300 g capacity | Tedea-Huntleigh |
| **Padding** | High-density EVA foam (×4) | ~100 kg/m³, ~50 Shore A, 3 × 3 × 2 cm | — |
| **Adhesive** | Cyanoacrylate super glue | e.g. 502 or equivalent | — |
| **DAQ** | PhidgetBridge DAQ card | PhidgetBridge 1046_0B | Phidgets Inc. |
| **Connectivity** | USB cable | USB-A / USB-C | — |

---

# Part 1 – 3D Printing

---

## What needs to be printed

| Component | Quantity |
|-----------|----------|
| Base plate | ×1 |
| Electronics chamber lid | ×1 |
| Workplate holder | ×4 |
| Workplate | ×1 |

STL files for all components are available in the Supplementary materials.

---

## Printer requirements

OpenStride's components require a printer with a **minimum build platform of 35 × 35 cm**.

> 💡 **Don't have access to a suitable printer?** Contact your institution's faculty or makerspace, or search for a local print service that supports this bed size.

---

## Print settings

| Parameter | Recommendation |
|-----------|----------------|
| **Material** | PLA |
| **Layer height** | No strict requirement — adjust to your desired surface quality. Layer height has no known effect on experimental results. |
| **Infill density** | 40–60% for most components (see note on Workplate below) |
| **Slicer software** | Any slicer works. [Creality Print 6.2](https://www.creality.com/pages/download-software) was used in the paper, but the design is not printer-specific. |

---

## Step 1.1 – Slice the STL Files

1. Open your slicer software
2. Import the STL files from the Supplementary materials
3. Apply the print settings from the table above
4. Slice and export the file to your printer

---

## Step 1.2 – Print All Components

Print each component listed in the table above. Recommended print order:

1. Base plate
2. Electronics chamber lid
3. Workplate holders (×4)
4. Workplate

---

## Note on Workplate Weight

The Workplate's infill density and height can be adjusted in the STL file to achieve different weights. The effect of plate weight on data collection is discussed in the paper's Supplementary section.

> ⚠️ **Note:** The Supplementary data on workplate weight may not yet be available. If you need this information, check back later or contact the OpenStride team.

---

# Part 2 – Laser Cutting

---

## What needs to be cut

| Component | Quantity | Material | Dimensions |
|-----------|----------|----------|------------|
| Acrylic enclosure Part A | ×4 | 5 mm acrylic sheet | 35 × 45 cm |
| Acrylic enclosure Part B | ×4 | 5 mm acrylic sheet | 35 × 45 cm |

The SVG cut file for both parts is available in the Supplementary materials.

---

## Material selection

The enclosure material and colour can be chosen based on your experimental setup. The paper uses **5 mm clear acrylic**, which allows for visual inspection of the internal electronics.

> 💡 **Alternative options:** Coloured or opaque acrylic can be used if light isolation is required for your experiment.

---

## Step 2.1 – Prepare the Cut File

1. Download the SVG file from the Supplementary materials
2. Open it in your laser cutter's software
3. Confirm the cut dimensions match your acrylic sheet size

---

## Step 2.2 – Cut the Enclosure Panels

1. Place your acrylic sheet in the laser cutter
2. Run the cut job for Part A — cut **4 pieces**
3. Run the cut job for Part B — cut **4 pieces**
4. Remove the finished panels and peel off any protective film

> ⚠️ **Safety:** Always follow your laser cutter's safety guidelines. Do not leave the machine unattended during cutting.

---

## Step 2.3 – Glue the Enclosure Together

Use **cyanoacrylate super glue** (e.g. 502 or equivalent) to bond the acrylic panels together:

1. Dry-fit all 8 panels before applying glue to confirm alignment
2. Apply a thin, even layer of glue to each joining edge
3. Press the panels firmly together and hold for 30–60 seconds per joint
4. Allow the fully assembled enclosure to cure before handling

> ⚠️ **Safety:** Work in a well-ventilated area. Cyanoacrylate fumes are irritating — avoid prolonged inhalation and keep away from eyes.

> 💡 **Tip:** Assemble on a flat surface to ensure the base of the enclosure sits level.

---

# Part 3 – Assembly

Before starting, make sure you have all 3D-printed parts, the assembled acrylic enclosure, sensors, screws, foam pads, and the DAQ card ready.

---

## Step 3.1 – Attach Load Cells to Base Plate

Attach each of the **4 load cells** to the **base plate** using the **8 mm M3.5 screws** (2 screws per sensor).

---

## Step 3.2 – Attach Workplate Holders to Load Cells

Attach each of the **4 workplate holders** to its corresponding **load cell** using the **25 mm M3.5 screws** (2 screws per holder).

---

## Step 3.3 – Route and Connect Sensor Cables

> ⚠️ **Important:** Follow this step carefully. Incorrect wiring may damage the sensors or DAQ card.

### 3.3a – Route cables through the Electronics Chamber

The Electronics Chamber has **four holes**, one at each corner, corresponding to the four sensors.

1. Identify the four cable routing holes on the Electronics Chamber
2. Feed each sensor's tri-colour cable through the hole **nearest to it** — do not cross cables between corners
3. Ensure cables are not pinched or kinked

### 3.3b – Connect cables to the PhidgetBridge 4-Input

Each sensor has a **4-wire cable**. Connect each wire to its correct terminal on the **PhidgetBridge 1046_0B**, following the colour mapping below:

| Wire colour | Signal | Terminal label |
|-------------|--------|----------------|
| 🔴 Red | Positive (+) | + |
| ⬛ Black | Ground (G) | G |
| ⬜ White | Negative (−) | − |
| 🟢 Green | 5V Power | 5V |

Connect each sensor to its corresponding **Port** on the PhidgetBridge, in the order below. The port number must match the physical corner of the device:

| Port | Corner position |
|------|----------------|
| Port 0 | Corner 0 |
| Port 1 | Corner 1 |
| Port 2 | Corner 2 |
| Port 3 | Corner 3 |

> ⚠️ **Do not swap ports between corners.** Misconnection will cause incorrect data mapping and may damage the load cells.

Refer to the diagram below for the exact corner layout and port assignment:

![Cable connection diagram — PhidgetBridge port-to-corner mapping](![1a5f50f95c85a5741c840d64c8c64087](https://github.com/user-attachments/assets/54cf5460-5c49-4265-9147-a17924ef8a45)

---

## Step 3.4 – Close the Electronics Chamber

1. Place the **electronics chamber lid** over the chamber
2. Secure it in place
3. Set the **workplate** on top of the workplate holders

---

## ✅ Assembly Complete

Your OpenStride hardware is now fully assembled. You should have:

- ✅ 4 load cells mounted to the base plate
- ✅ 4 workplate holders attached to the load cells
- ✅ All sensor cables routed through the electronics chamber
- ✅ All cables connected to the correct ports on the PhidgetBridge DAQ card
- ✅ Electronics chamber lid closed
- ✅ Workplate placed on top

You are now ready to connect the hardware to your computer and proceed with software setup. See the **[Windows Installation Guide](#)** or **[macOS Installation Guide](#)** for next steps.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Screw holes don't align | Check that the correct screw length is being used (8 mm for base plate, 25 mm for workplate holders) |
| Sensor cable won't reach the DAQ card | Re-route cables before closing the electronics chamber lid |
| Workplate is unstable | Check that all 4 workplate holders are fully tightened |
| Acrylic panels don't fit together | Dry-fit all panels before gluing — verify cut dimensions match the SVG file |
| Acrylic joint is weak or failed | Reapply cyanoacrylate glue and allow full cure time before handling |
| DAQ card not detected by computer | Check the USB connection and confirm Phidget22 drivers are installed |

> 💬 If you continue to experience issues, please open an issue via **[Reporting Issues](#)** or reach out through **[Getting Assistance](#)**.

---

*OpenStride Hardware Assembly Guide · Last updated 2026*
