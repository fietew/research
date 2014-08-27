addpath('../../matlab/');
script_parameters;

% parameters which should be varied for the evaluation
param_names = {'beamformer', 'Npw', 'Nsht', 'source.type'};

% generate disired combinations of parameter values;
param_values = ...
  allcombs({'MB'}, {10, 15, 18, 24, 360}, {10}, {'point'});

disp(param_values);

evalExhaustive(param_names, param_values, params);