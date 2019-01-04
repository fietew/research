% Monochromatic Sound Field Plots

%*****************************************************************************
% Copyright (c) 2013-2019 Fiete Winter                                       *
%                         Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
%                                                                            *
% This file is part of the supplementary material for Fiete Winter's         *
% scientific work and publications                                           *
%                                                                            *
% You can redistribute the material and/or modify it  under the terms of the *
% GNU  General  Public  License as published by the Free Software Foundation *
% , either version 3 of the License,  or (at your option) any later version. *
%                                                                            *
% This Material is distributed in the hope that it will be useful, but       *
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
% or FITNESS FOR A PARTICULAR PURPOSE.                                       *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy of the GNU General Public License along   *
% with this program. If not, see <http://www.gnu.org/licenses/>.             *
%                                                                            *
% http://github.com/fietew/publications           fiete.winter@uni-rostock.de*
%*****************************************************************************

clear
addpath('../../matlab');
brs_parameters;

%% parameters which should be iterated

% parameters which should be varied for the evaluation
% #1: reproduction method
% #2: listener position
% #3: number of plane wave in pwd ('lwfs-sbl' only)
% #4: modal order in circular expansion ('lwfs-sbl' only)
% #5: fhigh of wfs-prefilter ('lwfs-sbl' only)

param_names = { 'method', ...
  'pos', ...
  'localwfs_sbl.Npw', ...
  'localwfs_sbl.order', ...
  'f' };

%% generate disired combinations of parameter values

param_values = {};

param_values = [param_values; allcombs( ...
  {'ref', 'wfs'}, ...
  {[0,0,0]}, ...
  {NaN}, ...
  {NaN}, ...
  {2000} ...
  )];

% 
param_values = [param_values; allcombs( ...
  {'lwfs-sbl'}, ...
  {[0,0,0]}, ...
  {1024, 64}, ...
  {27}, ...
  {2000} ...
  )];

% 
param_values = [param_values; allcombs( ...
  {'lwfs-sbl'}, ...
  {[-0.5,0.75,0]}, ...
  {1024}, ...
  {27, 11}, ...
  {2000} ...
  )];

param_values

%% Evaluation
% plot sound fields and store them in gnuplot-compatible files
exhaustive_evaluation(@mono_soundfield, param_names, param_values, conf, true);
