# Experimental Aerodynamic Characterization of the NACA 0012 Airfoil

## Overview
This repository contains a modular MATLAB data-processing pipeline that evaluates the aerodynamic characteristics of a NACA 0012 airfoil using low-speed wind tunnel experimental data. The experiment was conducted at a constant freestream velocity of $20\text{ m/s}$ across a range of angles of attack ($\alpha = 0^{\circ}$ to $15^{\circ}$). 

The pipeline handles raw experimental hardware inputs from 23 chordwise pressure taps and a 13-probe downstream wake rake, mitigates sensor uncertainty through data averaging, corrects calibration offsets to prevent unphysical outputs, and applies theoretical boundary blockage corrections to mirror free-flight conditions. The processed experimental results are validated against analytical predictions from XFOIL ($Re = 150000$) and theoretical thin airfoil theory.

## Mathematical Framework & Sensor Processing
Aerodynamic forces are derived by integrating hardware pressure readings. The lift coefficient ($C_l$) and pitching moment coefficient ($C_m$) about the quarter-chord are resolved via numerical integration of the surface pressure coefficients ($C_p$) using the trapezoidal rule:
$$C_{l} = \int_{0}^{1}(C_{p,lower} - C_{p,upper})d\left(\frac{x}{c}\right)*\cos(\alpha)$$

$$C_{m} = \int_{0}^{1}(C_{p,lower} - C_{p,upper})*\left(0.25 - \frac{x}{c}\right)d\left(\frac{x}{c}\right)$$


Profile drag ($C_d$) is calculated using the Wake Traverse Method, integrating the momentum deficit captured by the Pitot probes:
$$C_{d} = \frac{2}{c}\int_{wake}\frac{u(y)}{V_{\infty}}\left(1 - \frac{u(y)}{V_{\infty}}\right)dy$$


**Data Correction Protocols:**
*   **Calibration Offsets:** Freestream total pressure is dynamically swapped with the maximum rake-measured pressure ($p_{T,wake}^{max}$) to correct baseline sensor offsets and eliminate unphysical negative drag artifacts.
*   **Blockage Corrections:** Because wind tunnel walls artificially constrain the flow, solid blockage and wake blockage corrections are systematically calculated and applied, addressing combined blockage ratios exceeding the standard 5% threshold at high angles of attack.

## Project Architecture
The codebase separates raw data ingestion, mathematical integration, theoretical correction, and visualization into distinct modules:
*   `main.m`: The executive script managing tunnel parameters and the data flow sequence.
*   `src/preprocess_sensor_data.m`: Ingests the raw `.xlsx` file, averages multiple datasets per interval to reduce noise, and cleans anomalous static pressure readings.
*   `src/compute_surface_aerodynamics.m`: Numerically integrates surface pressure distributions to resolve $C_l$ and $C_m$.
*   `src/compute_wake_drag.m`: Processes the downstream momentum deficit to extract raw $C_d$.
*   `src/apply_blockage_corrections.m`: Computes total blockage ratios and corrects the raw coefficients.
*   `src/visualize_comparisons.m`: Generates comprehensive aerodynamic dashboards comparing experimental data against XFOIL.

## Key Experimental Findings
1.  **Lift & Stall Dynamics:** The airfoil demonstrates a linear lift response up to $\alpha = 9^{\circ}$. The collapse of the leading-edge suction peak indicates a distinct stall regime starting between $11^{\circ}$ and $12^{\circ}$ ($C_{l,max} \approx 0.9$).
2.  **Viscous Drag Penalties:** Surface roughness and tunnel turbulence trigger early transition to turbulent flow, yielding an experimental minimum drag ($\approx 0.03$) significantly higher than idealized XFOIL predictions ($\approx 0.01$).
3.  **Post-Stall Separation:** Flow separation at $\alpha \ge 12^{\circ}$ results in a broad, deep momentum deficit in the wake profile, driving a rapid spike in pressure drag and a sharp nose-down pitching moment.

## Results Preview
<img width="3145" height="1447" alt="wtunlwakepresdist" src="https://github.com/user-attachments/assets/046f35a9-5420-473e-bdcb-90ad167ad932" />
<img width="3141" height="1447" alt="wtunlpresdist" src="https://github.com/user-attachments/assets/85317449-5e59-4efd-b09d-29102de51979" />
<img width="1655" height="1423" alt="momentcoeff" src="https://github.com/user-attachments/assets/27ff97ab-1c82-4c46-8c9c-b633fe7faae8" />
<img width="1630" height="1423" alt="liftcoeff" src="https://github.com/user-attachments/assets/62754a12-a548-48c4-96ba-4ec955ba04ff" />
<img width="1696" height="1464" alt="dragpolar" src="https://github.com/user-attachments/assets/4ce9d478-3760-4022-87d6-7a40169025be" />
<img width="1653" height="1423" alt="dragcoeff" src="https://github.com/user-attachments/assets/450b0920-20e0-4445-bdd8-1508d9d6500d" />


