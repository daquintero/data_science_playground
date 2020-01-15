%% Frequency Analysis
secondOrderSystem = tf(compassTransferFunctionNumerator, compassTransferFunctionDenominator);
[magnitudeSecondOrder, phaseSecondOrder, frequenciesSecondOrder] = bode(secondOrderSystem);
maximumSlopeSecondOrder3dBLimit = [0.15, 0.2];

magnitudeBodeCompass = magnitudeSecondOrder(:,:).'
phaseBodeCompass = phaseSecondOrder(:,:).'
rawBodeTableCompass = table(magnitudeBodeCompass, phaseBodeCompass,...
    frequenciesSecondOrder)
writetable(rawBodeTableCompass, "analytics/derivations/rawBodeTableCompass.csv")
% figure % Figure nly to check
% bode(secondOrderSystem);
% nyquist(secondOrderSystem);

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
badFilteredMagnitudeDBSecondOrder(size(rawMagnitudeDBSecondOrder)) = 0;
badFilteredPhaseDBSecondOrder(size(rawMagnitudeDBSecondOrder)) = 0;


for magnitudeValue = rawMagnitudeDBSecondOrder(2,:)
    if (magnitudeValue >= -3) && (magnitudeValue <= 3)
        if j > 1
            if abs(rawMagnitudeDBSecondOrder(1,j) - rawMagnitudeDBSecondOrder(1,j-1)) <= maximumSlopeSecondOrder3dBLimit(1)
                filteredMagnitudeDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
                filteredMagnitudeDBSecondOrder(2,j) = rawMagnitudeDBSecondOrder(2,j);
                filteredPhaseDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
                filteredPhaseDBSecondOrder(2,j) = phaseSecondOrder(j);
            else
                badFilteredMagnitudeDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
                badFilteredMagnitudeDBSecondOrder(2,j) = rawMagnitudeDBSecondOrder(2,j);
                badFilteredPhaseDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
                badFilteredPhaseDBSecondOrder(2,j) = phaseSecondOrder(j);
            end
        else
            filteredMagnitudeDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
            filteredMagnitudeDBSecondOrder(2,j) = rawMagnitudeDBSecondOrder(2,j);
            filteredPhaseDBSecondOrder(1,j) = rawMagnitudeDBSecondOrder(1,j);
            filteredPhaseDBSecondOrder(2,j) = phaseSecondOrder(j);
        end
    end 
    j = j + 1;
end

[rowMaxFilteredMagnitudeDBSecondOrder, ...
    colMaxFilteredMagnitudeDBSecondOrder] = find(...
    filteredMagnitudeDBSecondOrder == max(filteredMagnitudeDBSecondOrder(1, :)));
maxFrequencyFilteredMagnitudeDBSecondOrder = ...
    filteredMagnitudeDBSecondOrder(2, colMaxFilteredMagnitudeDBSecondOrder);
maxMagnitudeFilteredMagnitudeDBSecondOrder = ...
    filteredMagnitudeDBSecondOrder(1, colMaxFilteredMagnitudeDBSecondOrder);


% %% Figure 1
figure
hold on
plot(frequenciesSecondOrder, iteratorMagnitudeDBSecondOrder);
yline(-3);
yline(3);
plot(filteredMagnitudeDBSecondOrder(1,:), ...
    filteredMagnitudeDBSecondOrder(2,:), '.b')
plot(badFilteredMagnitudeDBSecondOrder(1,:), ...
    badFilteredMagnitudeDBSecondOrder(2,:), ...
    '.r')
set(gca, 'XScale', 'log')
hold off
% 
% %% Figure 2
figure
hold on
plot(frequenciesSecondOrder, ...
    phaseSecondOrder(:,:));
plot(filteredPhaseDBSecondOrder(1,:), ...
    filteredPhaseDBSecondOrder(2,:), ...
    '.b')
plot(badFilteredPhaseDBSecondOrder(1,:), ...
    badFilteredPhaseDBSecondOrder(2,:), ...
    '.r')
set(gca, 'XScale', 'log')
hold off

figure
hold on
plot(frequenciesSecondOrder, phaseSecondOrder(:,:));
plot(filteredPhaseDBSecondOrder(1,:), filteredPhaseDBSecondOrder(2,:), '.')
set(gca, 'XScale', 'log')
hold off
% 
disp("The 3dB cutoff maximum frequency is limited at a maximum slope of "...
    + maximumSlopeSecondOrder3dBLimit(1) + ". " + newline + ...
    "The minimum and maximum safe operational frequency of the sensor is: " + newline + ...
    + maxFrequencyFilteredMagnitudeDBSecondOrder + " rad/s with a "...
    + "maximum magnitude of " + maxMagnitudeFilteredMagnitudeDBSecondOrder + " dB");
%%
compassFilterGain = 1;
compassTimeConstant = 1/maxFrequencyFilteredMagnitudeDBSecondOrder; % Rad
compassFilterNumerator = compassFilterGain;
compassFilterDenominator = [compassTimeConstant 1];
compassFilterTransferFunction = tf(compassFilterNumerator, compassFilterDenominator);
% % figure
% % bode(compassFilterTransferFunction)
% [realNyquistCompass,imaginaryNyquistCompass,...
%     frequencyNyquistCompass] = nyquist(compassFilterTransferFunction);
% rawNyquistCompass = table(realNyquistCompass(:,:).', imaginaryNyquistCompass(:,:).', frequencyNyquistCompass)
% % Nyquist Raw Data
% writetable(rawNyquistCompass, "analytics/derivations/rawNyquistTableCompass.csv")
% % Filtered Bode magnitude & Phase
% writematrix([filteredMagnitudeDBSecondOrder; filteredPhaseDBSecondOrder].', "analytics/derivations/filteredDBSecondOrder.csv")
% % Error Bode magnitude & Phase
% writematrix([badFilteredMagnitudeDBSecondOrder; badFilteredPhaseDBSecondOrder].', "analytics/derivations/badFilteredDBSecondOrder.csv")