clear all
close all
clc

% keplarian elements
inclination = 51.638; % degree
eccentricity = 0.00075;
raan = 16.838; %hour
argPerigee = 337.730; % degree
meanAnomaly = 168.214; % degree
orbitalPeriod = 92.971; % min
altitude = 7000; % km
semiMajorAxis = 6738; % km

% Constants
startTime = datetime(2020,5,1,11,36,0);
stopTime = startTime + days(1);
sampleTime = 60;


% create satellite scenario object and satellite
scenario = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(scenario,semiMajorAxis,eccentricity,inclination,... 
        raan,argPerigee,meanAnomaly);

play(scenario,"PlaybackSpeedMultiplier",60);
