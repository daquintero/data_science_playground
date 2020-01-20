timeLength = 1;

% Unit Input
stepInput = ones(1, length(time))

% Ramp Input
rampInput = @(startTime, endTime) linspace(startTime, endTime)

