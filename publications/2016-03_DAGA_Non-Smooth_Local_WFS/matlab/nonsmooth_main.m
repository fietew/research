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

SFS_start;  % start Sound Field Synthesis Toolbox

nonsmooth_parameters;

%% parameters which should be iterated
% parameters which should be varied for the evaluation
param_names = { 'localsfs.vss.corner_radius', ...
  'localsfs.vss.size', ...
  'method', ...
  'secondary_sources.center', ...
  'secondary_sources.geometry'};

%% generate disired combinations of parameter values
param_values = {};

param_values = [param_values; allcombs( ...
  { 0.25, 0.75, 1.25 }, ...
  { 2.5, 3.0, 3.5 }, ...
  { 'lwfs' }, ...
  { [0,0,0] }, ...
  { 'box' } ...
  )];

param_values = [param_values; allcombs( ...
  { NaN }, ...
  { NaN }, ...
  { 'wfs', 'esa-rect' }, ...
  { [0,0,0] }, ...
  { 'box' } ...
  )];

%%
% compute sound pressure on regular grid
exhaustive_evaluation(@nonsmooth_sfs, param_names, param_values, conf, 0);