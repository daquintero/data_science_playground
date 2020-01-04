%% INITIALIZATION
run("./compassControlParameters.m");
run("./gyroControlParameters.m");

%% SIMULATION
simulation = sim('fullSystem','SimulationMode','normal');
% Get results
simulationData = simulation.get('simulationData');
assignin('base','simulationData',simulationData);