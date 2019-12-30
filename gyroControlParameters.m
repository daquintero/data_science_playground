%% GYRO MODEL
%%% Standard First Order System  y/u = k / (tau s + 1)%%%
timeConstant = 0.01; % tau
sensitivity = 1; % k

firstOrderNumerator = sensitivity;
firstOrderDenominator = [timeConstant 1]
firstOrderSystem = tf(firstOrderNumerator, firstOrderDenominator);
figure
step(firstOrderSystem);
figure
bode(firstOrderSystem);


