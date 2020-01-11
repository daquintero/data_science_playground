%% GYRO MODEL
%%% Standard First Order System  y/u = k / (tau s)%%%
timeConstant = 0.01; % tau
sensitivity = 1; % k

firstOrderNumerator = sensitivity;
firstOrderDenominator = [timeConstant 0];