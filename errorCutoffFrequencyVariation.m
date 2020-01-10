% This code models the variation of cutoff frequencies and the respective
% steady state input response (True Heading)

% Create standard model parameters
run("./compassControlParameters.m");
run("./gyroControlParameters.m");
testInput = "sine";
% Vary the cutoff frequencies over the attenuation range of the gyroFiler.
varyingCutoffFrequencies = linspace(0.1, 1000, 1000); % 10 ^ -1 to 10 ^ -4

% Compass Constant Parameters
compassFilterGain = 1;

p = 1;
% Iterating Parameters and Simulations
for cutoffFrequencyIteration = varyingCutoffFrequencies
    % Compass Filter Variation
    compassTimeConstant = 1/cutosffFrequencyIteration; % Rad
    compassFilterNumerator = compassFilterGain;
    compassFilterDenominator = [compassTimeConstant 1];
    compassFilterTransferFunction = tf(compassFilterNumerator, compassFilterDenominator);
    
    % Gyro Filter Variation
    gyroTimeConstant = compassTimeConstant;
    gyroFilterNumerator = [1 0];
    gyroFilterDenominator = [1 1/gyroTimeConstant];
    gyroFilterTransferFunction = tf(gyroFilterNumerator, gyroFilterDenominator);
    
    %% SIMULATION
    simulation = sim('fullSystem','SimulationMode','normal');
    % Get results
    simulationData = simulation.get('simulationData');
    assignin('base','simulationData',simulationData);
    
    % Simulation Data
    time = simulationData.time;
    signalsNamesOrdered = ["compassSystem", "compassFilter",...
        "fullSystem", "gyroFilter", "gyroSystem", "input", "error"].';
    compassSystem = simulationData.signals.values(:, 1);
    compassFilter = simulationData.signals.values(:, 2);
    fullSystem = simulationData.signals.values(:, 3);
    gyroFilter = simulationData.signals.values(:, 4);
    gyroSystem = simulationData.signals.values(:, 5);
    input = simulationData.signals.values(:, 6);
    error = fullSystem - input;
    allData = [simulationData.signals.values(:, :), error];
    
    rawDataTable = table(...
        time,...
        compassSystem,...
        compassFilter,...
        fullSystem,...
        gyroFilter,...
        gyroSystem,...
        input,...
        error);
    writetable(rawDataTable ,'analytics/cutoffVariations/'...
    + testInput... 
    + regexprep(string(cutoffFrequencyIteration),'\.','')...
    + 'Raw.csv');

    %% Plot
    % figure
    % plot(time, compassSystem, time, compassFilter, time, fullSystem,...
    %      time, gyroFilter, time, gyroSystem, time, input, time, error)
    % legend(signalsNamesOrdered)
    % savefig("analytics/cutoffVariations/"...
    %     + testInput... 
    %     + regexprep(string(cutoffFrequencyIteration),'\.','_')...
    %     + 'Fig.fig')
    
    %% Signals Processing
    meanSignals = mean(allData(:, :)).';
    standardDeviationSignals = std(allData(:, :)).';
    varianceSignals = var(allData(:, :)).';
    maxSignals = max(allData(:, :)).';
    minSignals = min(allData(:, :)).';
    kurtosisSignals = kurtosis(allData(:, :)).';
    firstMomentSignals = moment(allData(:, :), 1).';
    secondMomentSignals = moment(allData(:, :), 2).';
    thirdMomentSignals = moment(allData(:, :), 3).';
    fourthMomentSignals = moment(allData(:, :), 4).';
    skewnessSignals = skewness(allData(:, :)).';

    %% Display Analytics
    analyticsTable = table(signalsNamesOrdered, maxSignals, minSignals, meanSignals,...
        standardDeviationSignals, varianceSignals, kurtosisSignals,...
        skewnessSignals, firstMomentSignals, secondMomentSignals,...
        thirdMomentSignals, fourthMomentSignals)
    writetable(analyticsTable ,'analytics/cutoffVariations/'...
         + testInput...
         + regexprep(string(cutoffFrequencyIteration),'\.','_')...
         + 'Analytics.csv');
    p = p + 1
end

close all
