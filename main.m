% Main Execution Script for Wind Tunnel Data Processing
% NACA 0012 Aerodynamic Characterization
clear vars; clc; close all;
addpath('src');

% 1. Configuration & Constants
geom = struct('b', 0.457, 'c', 0.152, 't_c', 0.12);
geom.t_max = geom.t_c * geom.c; 
tunnel = struct('h', 0.457, 'w', 0.457, 'L', 1.4);
tunnel.A = tunnel.h * tunnel.w;
AOA = [0 3 6 9 12 15];

% 2. Data Processing Pipeline
raw_data_file = 'copy cleanDataGroup12.xlsx';
sensor_data = preprocess_sensor_data(raw_data_file, geom.c);

surface_aero = compute_surface_aerodynamics(sensor_data, geom.c, AOA);
wake_aero = compute_wake_drag(sensor_data, geom.c, AOA);
corrected_aero = apply_blockage_corrections(surface_aero, wake_aero, geom, tunnel);

% 3. Validation & Visualization
xfoil_file = 'Copy of NACA0012_Aerodynamic_Coefficients_from_XFoil.xlsx';
visualize_comparisons(AOA, sensor_data, surface_aero, wake_aero, corrected_aero, xfoil_file);