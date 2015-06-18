addpath('../../matlab/');
script_parameters;

% parameters which should be varied for the evaluation
param_names = {'beamformer', 'rot', 'Nsht', 'source.type'};

% generate disired combinations of parameter values;
param_values = ...
  allcombs({'MB'}, {[0, 45]}, {3, 5, 10, 23}, {'plane'});

param_values = [param_values; ...
  allcombs({'DSB'}, {[0, 45]}, {240}, {'plane'})]; 

param_values = [param_values; ...
  allcombs({'MB'}, {[0, 30]}, {3, 5, 10, 23}, {'point'})];

disp(param_values);

evalExhaustive(param_names, param_values, params);