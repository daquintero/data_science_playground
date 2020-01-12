%% INITIALIZATION
run("./compassControlParameters.m");
run("./idealCompassFilterParameters.m");
run("./gyroControlParameters.m");
run("./idealGyroFilterParameters.m");
testInput = "step";

configurationParamtersTable = table(maxMagnitudeFilteredMagnitudeDBSecondOrder, ...
    maxFrequencyFilteredMagnitudeDBSecondOrder, compassTimeConstant, ...
    gyroCutoffFrequency, gyroTimeConstant);
writetable(configurationParamtersTable ,'analytics/' + testInput + 'Configuration.csv');

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
writetable(rawDataTable ,'analytics/'...
+ testInput... 
+ 'Raw.csv');

%% Correlations
compassSystemErrorCrossCorrelation = xcorr(error, compassSystem);
compassFilterErrorCrossCorrelation = xcorr(error, compassFilter);
fullSystemErrorCrossCorrelation = xcorr(error, fullSystem);
gyroFilterErrorCrossCorrelation = xcorr(error, gyroFilter);
gyroSystemErrorCrossCorrelation = xcorr(error, gyroSystem);

correlationsDataTable = table(...
    compassSystemErrorCrossCorrelation,...
    compassFilterErrorCrossCorrelation,...
    fullSystemErrorCrossCorrelation,...
    gyroFilterErrorCrossCorrelation,...
    gyroSystemErrorCrossCorrelation...
    );
writetable(correlationsDataTable,'analytics/'...
+ testInput... 
+ 'Correlations.csv');

%% Plot
figure
plot(time, compassSystem, time, compassFilter, time, fullSystem,...
     time, gyroFilter, time, gyroSystem, time, input, time, error)
legend(signalsNamesOrdered)
savefig("analytics/"...
    + testInput... 
    + 'Fig.fig')

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
rmsSignals = rms(allData(:, :)).';
powerSignals = powerbw(allData(:, :)).';
% overshootSignals = overshoot(fullSystem).';
% undershootSignals = undershoot(fullSystem).';
% settlingTimeSignals = settlingtime(fullSystem).';


%% Display Analytics
analyticsTable = table(signalsNamesOrdered, maxSignals, minSignals, meanSignals,...
    standardDeviationSignals, varianceSignals, kurtosisSignals,...
    skewnessSignals, firstMomentSignals, secondMomentSignals,...
    thirdMomentSignals, fourthMomentSignals, rmsSignals,...
    powerSignals)
writetable(analyticsTable ,'analytics/'...
     + testInput... 
     + 'Analytics.csv');
%% Spectral Kurtuosis
% i = 1;
% for signalsAmount = 1:6
%     figure
%     pkurtosis(allData(:, i))
%     i = i + 1;
% end

