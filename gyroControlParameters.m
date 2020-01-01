%% GYRO MODEL
%%% Standard First Order System  y/u = k / (tau s + 1)%%%
timeConstant = 0.01; % tau
sensitivity = 1; % k

firstOrderNumerator = sensitivity;
firstOrderDenominator = [timeConstant 1]
firstOrderSystem = tf(firstOrderNumerator, firstOrderDenominator);
firstOrderStep = step(firstOrderSystem);
[magnitudeFirstOrder, phaseFirstOrder, frequenciesFirstOrder] = bode(firstOrderSystem);
figure
bode(firstOrderSystem)

i = 0;
magnitudeDBFirstOrder(size(magnitudeFirstOrder(:,:))) = 0;
for val = magnitudeFirstOrder(:,:)
    i = i + 1;
    magnitudeDBFirstOrder(i) = -20* log10(1/val);
end

figure
plot(frequenciesFirstOrder, magnitudeDBFirstOrder);
set(gca, 'XScale', 'log')

