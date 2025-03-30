clc; clear;

% Load orbital parameters
orbits = orbitLibrary();
chosenOrbit = orbits.SSO_500;   %

% Determine selected orbit name
orbitFields = fieldnames(orbits);
selectedIndex = find(structfun(@(x) isequal(x, chosenOrbit), orbits));
orbitName = orbitFields{selectedIndex};

% Convert orbital elements
a = chosenOrbit.semiMajorAxis * 1e3;  % m
e = chosenOrbit.eccentricity;
i = deg2rad(chosenOrbit.inclination);
raan = deg2rad(chosenOrbit.RAAN);
argPerigee = deg2rad(chosenOrbit.argPerigee);
trueAnomaly = deg2rad(chosenOrbit.trueAnomaly);

startTime = datetime(2026,6,1,11,36,0);
stopTime = startTime + days(1);
sampleTime = 60;

%Create scenario
sc = satelliteScenario(startTime, stopTime, sampleTime);

sat = satellite(sc, ...
    a, e, i, raan, argPerigee, trueAnomaly, ...
    "Name", "MANTIS", 'OrbitPropagator','numerical');

%Camera Imaging Parameters
fov_deg = 10;
earth_radius = 6378.137e3;  % m
alt_km = chosenOrbit.semiMajorAxis - earth_radius/1e3;
fov_rad = deg2rad(fov_deg);
footprint_m = 2 * alt_km * 1e3 * tan(fov_rad/2);

% Approximate orbital speed (circular orbit assumption)
mu = 398600.4418; % km^3/s^2
orbital_speed_kmps = sqrt(mu / chosenOrbit.semiMajorAxis);
capture_interval = (2 * alt_km * tan(fov_rad/2)) / orbital_speed_kmps;

% image capture
times = sc.StartTime:seconds(capture_interval):sc.StopTime;
positions = [];
footprints = {};

for t = times
    [pos, vel] = states(sat, t, 'CoordinateFrame', 'ecef');
    positions = [positions; pos'];

    latlon = ecef2lla(pos');
    lat = latlon(1);
    lon = latlon(2);
    dLat = rad2deg(footprint_m / 2 / earth_radius);
    dLon = dLat / cosd(lat);

    footprints{end+1} = [lat - dLat, lon - dLon; 
                         lat - dLat, lon + dLon;
                         lat + dLat, lon + dLon;
                         lat + dLat, lon - dLon];
end

% Convert positions to LLA for geoplot
lla_positions = ecef2lla(positions); % [lat lon alt]

figure;
geoplot(lla_positions(:,1), lla_positions(:,2), 'r--');
hold on;
geobasemap("satellite");

for k = 1:length(footprints)
    fp = footprints{k};
    geoplot([fp(:,1); fp(1,1)], [fp(:,2); fp(1,2)], 'b');
end

title(sprintf('Image Capture Simulation - %s', orbitName), 'Interpreter', 'none');
legend('Ground Track', 'Image Footprints');
