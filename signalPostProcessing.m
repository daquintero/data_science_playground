simulation = sim('fullSystem','SimulationMode','normal');
simulationData = simulation.get('simulationData')
assignin('base','simulationData',simulationData);