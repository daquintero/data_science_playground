%% Frequency Analysis
firstOrderSystem = tf(firstOrderNumerator, firstOrderDenominator);
firstOrderStep = step(firstOrderSystem);
[magnitudeFirstOrder, phaseFirstOrder, frequenciesFirstOrder] = ...
    bode(firstOrderSystem, {10^-1, 10^4});
% figure % Figure only to check
% step(firstOrderSystem);
% bode(firstOrderSystem);

% All db Magnitude points
i = 1;
iteratorMagnitudeDBFirstOrder(size(magnitudeFirstOrder(:,:))) = 0;
for val = magnitudeFirstOrder(:,:)
    iteratorMagnitudeDBFirstOrder(i) = -20* log10(1/val);
    i = i + 1;
end
rawMagnitudeDBFirstOrder = [transpose(frequenciesFirstOrder); iteratorMagnitudeDBFirstOrder];

% All Filtered dB Magnitude points
j = 1;
filteredMagnitudeDBFirstOrder(size(rawMagnitudeDBFirstOrder)) = 0;
filteredPhaseDBFirstOrder(size(rawMagnitudeDBFirstOrder)) = 0;
for magnitudeValue = rawMagnitudeDBFirstOrder(2,:)
    if (magnitudeValue >= -3) && (magnitudeValue <= 3)
        filteredMagnitudeDBFirstOrder(1,j) = rawMagnitudeDBFirstOrder(1,j);
        filteredMagnitudeDBFirstOrder(2,j) = rawMagnitudeDBFirstOrder(2,j);
        filteredPhaseDBFirstOrder(1,j) = rawMagnitudeDBFirstOrder(1,j);
        filteredPhaseDBFirstOrder(2,j) = phaseFirstOrder(j);
    end 
    j = j + 1;
end

% %% Plots
% figure
% hold on
% plot(frequenciesFirstOrder, iteratorMagnitudeDBFirstOrder);
% yline(-3);
% yline(3);
% plot(filteredMagnitudeDBFirstOrder(1,:), filteredMagnitudeDBFirstOrder(2,:), '.')
% set(gca, 'XScale', 'log')
% hold off

%% Gyro Filter Denominator
gyroCutoffFrequency = compassTimeConstant;
gyroTimeConstant = compassTimeConstant;

gyroFilterNumerator = [1 0];
gyroFilterDenominator = [1 1/gyroTimeConstant];
gyroFilterTransferFunction = tf(gyroFilterNumerator, gyroFilterDenominator);
% figure
% bode(gyroFilterTransferFunction)