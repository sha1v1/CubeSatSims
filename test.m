close all

% Orbital parameters
semiMajorAxis = 6371e3 + 500e3;  % 500 km altitude
eccentricity = 0;                % Circular orbit
inclination = 98;                % Sun-synchronous orbit (~98 degrees)
rightAscension = 0;              % Initial RAAN
argumentOfPeriapsis = 0;         % Argument of periapsis
trueAnomaly = 0;                 % Initial true anomaly

% Constants
startTime = datetime(2020,5,1,11,36,0);
stopTime = startTime + days(1);
sampleTime = 60;  % Sample time in seconds

% J2 Perturbation parameters
J2 = 1.08263e-3;                 % Earth's J2 coefficient
earthRadius = 6371e3;            % Earth's radius in meters
muEarth = 3.986004418e14;        % Earth's gravitational parameter in m^3/s^2

% Compute mean motion
n = sqrt(muEarth / semiMajorAxis^3);  % Mean motion

% Calculate the rates of RAAN and argument of periapsis due to J2
RAAN_dot = -1.5 * J2 * (earthRadius / semiMajorAxis)^2 * n * cosd(inclination);
omega_dot = 0.75 * J2 * (earthRadius / semiMajorAxis)^2 * n * (5 * cosd(inclination)^2 - 1);

% Create satellite scenario object and satellite
scenario = satelliteScenario(startTime, stopTime, sampleTime);

% Initialize RAAN and argument of periapsis values to be updated in the loop
currentRAAN = rightAscension;
currentArgPeriapsis = argumentOfPeriapsis;

% Add the CubeSat to the scenario with initial parameters
sat = satellite(scenario, semiMajorAxis, eccentricity, inclination, ...
                currentRAAN, currentArgPeriapsis, trueAnomaly);

% Viewer for 3D visualization
viewer = satelliteScenarioViewer(scenario);

% Ground Track visualization with lead/trail time
gt = groundTrack(sat, 'LeadTime', 3600, 'TrailTime', 3600);  % Show 1 hour ahead and behind

% Play the scenario to visualize
play(scenario);

% Get the satellite's position over time, including J2 effects
[position, velocity] = states(sat, 'CoordinateFrame', 'geographic');

% Extract latitude and longitude
lat = position(:, 1);  % Latitude in degrees
lon = position(:, 2);  % Longitude in degrees

% Plot the ground track with J2 perturbations
figure;
worldmap world;  % Create a world map
plotm(lat, lon, 'r');  % Plot the ground track in red
title('Satellite Ground Track with J2 Perturbations');
