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

%% Frequency Analysis
secondOrderSystem = tf(compassTransferFunctionNumerator, compassTransferFunctionDenominator)
[magnitudeSecondOrder, phaseSecondOrder, frequenciesSecondOrder] = bode(secondOrderSystem);
% figure % Figure nly to check
% bode(secondOrderSystem);

% All db Magnitude points
i = 1;
iteratorMagnitudeDBSecondOrder(size(magnitudeSecondOrder(:,:))) = 0;
for val = magnitudeSecondOrder(:,:)
    iteratorMagnitudeDBSecondOrder(i) = -20* log10(1/val);
    i = i + 1;
end
rawMagnitudeDBSecondOrder = [transpose(frequenciesSecondOrder); iteratorMagnitudeDBSecondOrder];

% All Filtered dB Magnitude points
j = 1;
filteredMagnitudeDBSecondOrder(size(rawMagnitudeDBSecondOrder)) = 0;
filteredPhaseDBSecondOrder(size(rawMagnitudeDBSecondOrder)) = 0;
for magnitudeValue = rawMagnitudeDBSecondOrder(2,:)
    if (magnitudeValue >= -3) && (magnitudeValue <= 3)
        filteredMagnitudeDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
        filteredMagnitudeDBSecondOrder(2,j) = rawMagnitudeDBSecondOrder(2,j);
        filteredPhaseDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
        filteredPhaseDBSecondOrder(2,j) = phaseSecondOrder(j);
    end 
    j = j + 1;
end
filteredPhaseDBSecondOrder

%%
figure
hold on
plot(frequenciesSecondOrder, iteratorMagnitudeDBSecondOrder);
yline(-3);
yline(3);
plot(filteredMagnitudeDBSecondOrder(1,:), filteredMagnitudeDBSecondOrder(2,:), '.')
set(gca, 'XScale', 'log')
hold off

figure
hold on
plot(frequenciesSecondOrder, phaseSecondOrder(:,:));
plot(filteredPhaseDBSecondOrder(1,:), filteredPhaseDBSecondOrder(2,:), '.')
set(gca, 'XScale', 'log')
hold off


