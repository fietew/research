% amplitude variations at reference coordinate for different sound field
% synthesis and different virtual source angles

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

clear variables;
addpath('../../matlab');

SFS_start;  % start Sound Field Synthesis Toolbox
nonsmooth_parameters;  % default parameters

%% parameters which should be iterated
% parameters which should be varied for the evaluation
param_names = { 'localsfs.vss.size', ...
  'method', ...
  'frequency'};

%% generate disired combinations of parameter values
param_values = {};

param_values = [param_values; allcombs( ...
  { 2, 2.5, 3.0, 3.5 }, ...
  { 'lwfs' }, ...
  { 200, 300, 500, 750 } ...
  )];

%% compute
exhaustive_evaluation(@nonsmooth_area, param_names, param_values, conf, ...
  true);
