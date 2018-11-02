clear
SFS_start;
addpath('../../matlab');

brs_parameters;

%% parameters which should be iterated

param_names = { 
  'method', ...
  'pos', ...
  'usetapwin', ...
  'localwfs_vss.number',...
  'localwfs_vss.size',...
  'localwfs_sbl.Npw',...
  'localwfs_sbl.order', ...
  'nfchoa.order', ...
  };

%% generate disired combinations of parameter values

param_values = {};

param_values = [param_values; allcombs( ...
  {'ref', 'wfs', 'nfchoa', 'nfchoa'}, ...
  {[0,0,0]}, ...
  {true}, ...
  {NaN}, ...
  {NaN}, ...
  {NaN}, ...
  {NaN}, ...
  {NaN, NaN, 13, 27 }, ...
  [1:7, 1] ...
)];

% LWFS-VSS
param_values = [param_values; allcombs( ...
  {'lwfs-vss'}, ...
  {[0,0,0], [-0.5 0.75 0]}, ...
  {true}, ...
  {1024, 64}, ...
  {0.9}, ...
  {NaN}, ...
  {NaN}, ...
  {NaN} ...
)];
  
% LWFS-SBL
param_values = [param_values; allcombs( ...
  {'lwfs-sbl'}, ...
  {[0,0,0], [0,0,0], [-0.5 0.75 0], [-0.5 0.75 0]}, ...
  {false}, ...
  {NaN}, ...
  {NaN}, ...
  {1024, 64, 1024, 1024}, ...
  {27, 27, 27, 11}, ...
  {NaN}, ...
  [1:5,2,2,8] ...
)];

param_values

%% Evaluation
% compute brs files
exhaustive_evaluation(@brs_driving_signals, param_names, param_values, ...
  conf, false);

% plot sound fields and store them in gnuplot-compatible files
exhaustive_evaluation(@eval_gnuplot_mono_soundfield, param_names, param_values, ...
  conf, false);
