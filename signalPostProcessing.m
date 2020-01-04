%% INITIALIZATION
run("./compassControlParameters.m");
run("./gyroControlParameters.m");

%% SIMULATION
simulation = sim('fullSystem','SimulationMode','normal');
% Get results
simulationData = simulation.get('simulationData');
assignin('base','simulationData',simulationData);

compassSystem = simulationData.signals.values(:, 1);
compassFilter = simulationData.signals.values(:, 2);
fullSystem = simulationData.signals.values(:, 3);
gyroSystem = simulationData.signals.values(:, 4);
gyroFilter = simulationData.signals.values(:, 5);
input = simulationData.signals.values(:, 6);
time = simulationData.time;

meanInput = mean(input);
meanCompassSystem = mean(compassSystem);
meanCompassFilter = mean(compassFilter);
meanFullSystem = mean(fullSystem);
meanGyroSystem = mean(gyroSystem);
meanGyroFilter = mean(gyroFilter);


