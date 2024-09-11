close all
clc

% orbital parameters
semiMajorAxis = 6371e3 + 500e3;  % 500 km altitude (6371 km is Earth's radius)
eccentricity = 0;                % Circular orbit
inclination = 98;                % Sun-synchronous orbit (~98 degrees)
rightAscension = 0;              % Right ascension of the ascending node
argumentOfPeriapsis = 0;         % Argument of periapsis
trueAnomaly = 0;                 % Initial true anomaly (starting point in the orbit)




% Constants
startTime = datetime(2020,5,1,11,36,0);
stopTime = startTime + days(1);
sampleTime = 60;


% create satellite scenario object and satellite
scenario = satelliteScenario(startTime, stopTime, sampleTime);

% Add the CubeSat to the scenario
sat = satellite(scenario, semiMajorAxis, eccentricity, inclination, ...
                rightAscension, argumentOfPeriapsis, trueAnomaly);

viewer = satelliteScenarioViewer(scenario);
play(scenario);
