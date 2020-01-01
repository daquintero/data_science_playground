%% GYRO MODEL
%%% Standard First Order System  y/u = k / (tau s + 1)%%%
timeConstant = 0.01; % tau
sensitivity = 1; % k

firstOrderNumerator = sensitivity;
firstOrderDenominator = [timeConstant 1]


%% Frequency Analysis
firstOrderSystem = tf(firstOrderNumerator, firstOrderDenominator);
firstOrderStep = step(firstOrderSystem);
[magnitudeFirstOrder, phaseFirstOrder, frequenciesFirstOrder] = bode(firstOrderSystem);
figure
bode(firstOrderSystem);
% figure % Figure nly to check
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
filteredPhaseDBFirstOrder

%%
figure
hold on
plot(frequenciesFirstOrder, iteratorMagnitudeDBFirstOrder);
yline(-3);
yline(3);
plot(filteredMagnitudeDBFirstOrder(1,:), filteredMagnitudeDBFirstOrder(2,:), '.')
set(gca, 'XScale', 'log')
hold off

figure
hold on
plot(frequenciesSecondOrder, phaseSecondOrder(:,:));
plot(filteredPhaseDBSecondOrder(1,:), filteredPhaseDBSecondOrder(2,:), '.')
set(gca, 'XScale', 'log')
hold off


