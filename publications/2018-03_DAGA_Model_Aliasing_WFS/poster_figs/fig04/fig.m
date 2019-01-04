% 

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

parameters;

%% Parameters which should be iterated

param_names = {
  'src', ...
  'xs', ...
  'secondary_sources.geometry', ...
  'f', ...
  'eta' ...
  'method', ...
};

%% Parameter Values

param_values = {};

param_values = [param_values; allcombs( ...
  { 'ps' }, ...
  { [0,-1,0] }, ...
  { 'linear' }, ...
  { 1000 }, ...
  { 0, -1, 1, -2, 2 }, ...
  { 'wfs' }, ...
  [1, 1, 3, 4, 5, 6] ...
)];

param_values

%% evaluation
exhaustive_evaluation(@spatial_aliasing, param_names, param_values, conf, true);
