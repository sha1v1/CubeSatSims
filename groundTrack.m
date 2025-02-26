% Script to analyze the ground track of the orbit given the parameters
close all
clc

% orbital parameters
semiMajorAxis = orbitParams.semiMajorAxis  ;
eccentricity = orbitParams.eccentricity;                % Circular orbit
inclination = orbitParams.inclination;                
rightAscension = orbitParams.RAAN;              % Right ascension of the ascending node
argumentOfPeriapsis = orbitParams.argPerigee;         % Argument of periapsis
trueAnomaly = orbitParams.trueAnomaly;                 % Initial true anomaly (starting point in the orbit)


% Constants
startTime = datetime(2026,6,1,11,36,0);
stopTime = startTime + days(1);
sampleTime = 60;

% create satellite scenario object and satellite
scenario = satelliteScenario(startTime, stopTime, sampleTime);

numericalPropOptions = numericalPropagator(scenario,"GravitationalPotentialModel","spherical-harmonics", "IncludeAtmosDrag",true, ...
    "IncludeThirdBodyGravity", true,"IncludeSRP",true);


% Add the CubeSat to the scenario
sat = satellite(scenario, semiMajorAxis, eccentricity, inclination, ...
                rightAscension, argumentOfPeriapsis, trueAnomaly, 'Name','MANTIS','OrbitPropagator','numerical');

% get the position and velocity in ECEF
[pos_ecef, vel_ecef, time] = states(sat, CoordinateFrame="ecef");
% transpose both vectors to a column vector:
pos_ecef = pos_ecef.';
vel_ecef = vel_ecef.';
time = time.';

% need to convert the date/time variable time to a 1x6 row vector of time
% components in UTC
time = datevec(time);

% Now use eci2lla function to get lattitude and longitudes of the satellite
% position:
% Output format is: LLA = [Lat Long Alt]
LLA = ecef2lla(pos_ecef);

% Plot the satellite ground track over the earth:
figure(1)
% worldmap('World')
ax = axesm('MapProjection','miller','Frame','off','Grid','on','MeridianLabel','on','ParallelLabel','on',...
    'MLabelParallel','south');
load coastlines
plotm(coastlat,coastlon,'k')
land = readgeotable("landareas.shp");
geoshow(ax,land,"FaceColor",[0.5 0.5 0.5])
grid on
plotm(LLA(:,1),LLA(:,2),'r:','LineWidth',1)
title('Satellite Ground Track','interpreter','latex')
xlabel('Longitude','interpreter','latex')
ylabel('Latittude','interpreter','latex')


% save data to an output file
latitude = LLA(:,1);
longitude = LLA(:,2);
timeString = datetime(time, 'Format', 'yyyy-MM-dd HH:mm:ss');
outputTable = table(timeString, latitude, longitude, ...
    'VariableNames', {'Time', 'Latitude', 'Longitude'});

% write output to a csv file
writetable(outputTable, 'satellite_groundtrack.csv');
