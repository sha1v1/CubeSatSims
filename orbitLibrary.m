% Create a file named 'orbitLibrary.m'
function params = orbitLibrary()
    % Define ISS orbital parameters
    params.ISS = struct('semiMajorAxis', 6778, ... % km (approx. 400 km altitude)
                        'eccentricity', 0.0006, ... % Nearly circular
                        'inclination', 51.6, ... % degrees
                        'RAAN', 30, ... % degrees
                        'argPerigee', 0, ... % degrees
                        'trueAnomaly', 0); % degrees

    % Earth radius in km
    R_earth = 6378.137;
    
    % Define SSO parameters for multiple altitudes
    for i = 1:11
        % Calculate altitude and orbital parameters
        altitude = 500 + (i-1)*10;
        semiMajorAxis = R_earth + altitude;
        
        % Calculate appropriate inclination for SSO
        J2 = 0.00108263;
        mu = 398600.4418; % Earth's gravitational parameter (km³/s²)
        meanMotion = sqrt(mu / semiMajorAxis^3);
        nodal_precession = 2*pi / (365.25636 * 86400);
        cos_i = -2 * nodal_precession * semiMajorAxis^2 / (3 * J2 * R_earth^2 * meanMotion);
        inclination = acos(cos_i) * 180/pi;
        
        % Create a field name based on the altitude
        fieldName = sprintf('SSO_%d', altitude);
        
        % Store parameters for this SSO
        params.(fieldName) = struct('semiMajorAxis', semiMajorAxis, ...
                                    'eccentricity', 0.001, ...
                                    'inclination', inclination, ...
                                    'RAAN', 0, ...
                                    'argPerigee', 0, ...
                                    'trueAnomaly', 0);
    end
end