% grid of evaluation points for translatory shifts

%*****************************************************************************
% Copyright (c) 2013-2018 Fiete Winter                                       *
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

%% ===== Parameters ==========================================================

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

%% ===== Computation =========================================================

exhaustive_evaluation(@evalEverything, param_names, param_values, params);
