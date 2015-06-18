addpath('../../matlab/');
script_parameters;

% parameters which should be varied for the evaluation
param_names = {'beamformer', 'rot', 'source.type'};

% generate disired combinations of parameter values;
param_values = ...
  allcombs({'MB'}, {[0, 45]}, {'plane'});

param_values = [param_values; ...
  allcombs({'MB'}, {[0, 30]}, {'point'})]; 
disp(param_values);

evalExhaustive(param_names, param_values, params);