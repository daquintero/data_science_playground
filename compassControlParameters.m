%%% COMPASS PARAMETERS %%%
clear all;
rise_time = 0.4;
settling_time = 18;

%% Compass UNDAMPED Relationship
natural_frequency = 1 / rise_time; % Note the factor of 2*pi
damping_ratio = 3 / (natural_frequency * settling_time);

if damping_ratio < 1
    disp("VALID Undamped Relationship to: " + damping_ratio)
    % Transfer function values
    compassTransferFunctionNumerator = natural_frequency ^ 2;
    compassTransferFunctionDenominator = [ 1 2*damping_ratio*natural_frequency natural_frequency^2 ];
else
    disp("INVALID Undamped Relationship to: " + damping_ratio)
    disp("RESET")
end