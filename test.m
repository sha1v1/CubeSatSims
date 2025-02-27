close all
clc

%CHOOSE ORBIT FROM CONFIGS
orbits = orbitLibrary();
orbit = orbits.SSO_550;

% orbital parameters
semiMajorAxis = orbit.semiMajorAxis*1000  ;
eccentricity = orbit.eccentricity;                % Circular orbit
inclination = orbit.inclination;                
rightAscension = orbit.RAAN;              % Right ascension of the ascending node
argumentOfPeriapsis = orbit.argPerigee;         % Argument of periapsis
trueAnomaly = orbit.trueAnomaly;                 % Initial true anomaly (starting point in the orbit)



% Constants
startTime = datetime(2020,5,1,11,36,0);
stopTime = startTime + days(1);
sampleTime = 60;


% create satellite scenario object and satellite
scenario = satelliteScenario(startTime, stopTime, sampleTime);

numericalPropOptions = numericalPropagator(scenario,"GravitationalPotentialModel","spherical-harmonics", "IncludeAtmosDrag",true, ...
    "IncludeThirdBodyGravity", true,"IncludeSRP",true);


% Add the CubeSat to the scenario
sat = satellite(scenario, semiMajorAxis, eccentricity, inclination, ...
                rightAscension, argumentOfPeriapsis, trueAnomaly, 'Name','MANTIS','OrbitPropagator','numerical');

% dual cone eclipse object. does not include lunar eclipse
ecSat = eclipse(sat, "IncludeLunarEclipse",false);
ecIntervals = eclipseIntervals(ecSat);
ecFraction = eclipsePercentage(ecSat);

viewer = satelliteScenarioViewer(scenario);
play(scenario);
disp(ecFraction);