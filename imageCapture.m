
% load orbit parameters
params = orbitLibrary();
param = orbits.SSO_550;

% Set up the scenario
startTime = datetime(2024,1,1,0,0,0);
stopTime = startTime + days(1);
sampleTime = 60; %seconds
sc = satelliteScenario(startTime, stopTime, sampleTime);

% Create satellite from orbital elements
sat = satellite(sc, ...
    param.semiMajorAxis * 1000, ...
    param.eccentricity, ...
    param.inclination, ...
    param.RAAN, ...
    param.argPerigee, ...
    param.trueAnomaly, ...
    'OrbitPropagator', 'two-body-keplerian', Name="MANTIS");


cameraFOV = 10; %in degrees
% Add a conical sensor
sensor = conicalSensor(sat, 'MaxViewAngle', cameraFOV, 'Name', 'MANTIS Payload');

% Show the footprint of the sensor
fieldOfView(sensor);

% Add ground track for visibility
groundTrack(sat, 'LeadTime', 1800, 'TrailTime', 1800);

% Launch the viewer
v = satelliteScenarioViewer(sc);
play(v)
