% createOrbitParams.m
%
% This script creates a struct of parameters for our orbit simulation
% and saves it to a .mat file.

% 1. Create the struct
orbitParams.muEarth     = 3.986004418e14;  % Earth's grav parameter [m^3/s^2]
orbitParams.J2          = 1.08262668e-3;   % J2 coefficient
orbitParams.earthRadius = 6378.137e3;      % Earth mean radius [m]

% Basic orbit elements
orbitParams.semiMajorAxis = 7000e3;        
orbitParams.eccentricity  = 0.001;
orbitParams.inclination   = 98.0;           
orbitParams.RAAN          = 0.0;           
orbitParams.argPerigee    = 0.0;           
orbitParams.trueAnomaly   = 0.0;          

% Drag/Aero
orbitParams.Cd = 2.2;      % Drag coefficient
orbitParams.A  = 0.01;     % Cross-sectional area [m^2]

% Mass, etc.
orbitParams.mass = 4;      % kg

% 2. Save the struct into a .mat file
save('orbitParams.mat','orbitParams');

disp('orbitParams.mat created successfully!');
