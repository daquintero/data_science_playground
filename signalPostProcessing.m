%% INITIALIZATION
run("./compassControlParameters.m");
run("./gyroControlParameters.m");

%% SIMULATION
simulation = sim('fullSystem','SimulationMode','normal');
% Get results
simulationData = simulation.get('simulationData');
assignin('base','simulationData',simulationData);

allData = simulationData.signals.values(:, :);
time = simulationData.time;
signalsNamesOrdered = ["compassSystem", "compassFilter",...
    "fullSystem", "gyroFilter", "gyroSystem", "input"].';
compassSystem = simulationData.signals.values(:, 1);
compassFilter = simulationData.signals.values(:, 2);
fullSystem = simulationData.signals.values(:, 3);
gyroFilter = simulationData.signals.values(:, 4);
gyroSystem = simulationData.signals.values(:, 5);
input = simulationData.signals.values(:, 6);

%% Plot
figure
plot(time, compassSystem, time, compassFilter, time, fullSystem,...
     time, gyroFilter, time, gyroSystem, time, input)
legend(signalsNamesOrdered)
% meanInput = mean(input);
% meanCompassSystem = mean(compassSystem);
% meanCompassFilter = mean(compassFilter);
% meanFullSystem = mean(fullSystem);
% meanGyroSystem = mean(gyroSystem);
% meanGyroFilter = mean(gyroFilter);

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

%% Spectral Kurtuosis
% i = 1;
% for signalsAmount = 1:6
%     figure
%     pkurtosis(allData(:, i))
%     i = i + 1;
% end

