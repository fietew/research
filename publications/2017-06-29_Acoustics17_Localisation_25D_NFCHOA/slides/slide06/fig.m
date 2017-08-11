% sound fields for block diagram

%*****************************************************************************
% Copyright (c) 2017      Fiete Winter                                       *
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
SFS_start;
addpath('../../matlab');

brs_parameters;

%% parameters which should be iterated

% parameters which should be varied for the evaluation
% #1: method
% #2: truncation order for modal bandwidth limitation
% #3: truncation window type
% #4: position of listener#
% #5: number of secondary sources

param_names = {%
  'method', ...
  'nfchoa.order', ...
  'modal_window', ...
  'pos', ...
  'secondary_sources.number', ...
};

%% values of parameters

param_values = {};

param_values = [param_values; allcombs( ...
  { 'ref' }, ...
  { NaN }, ...
  { '' }, ...
  { [0, 0, 0] }, ...
  { NaN }, ...
  [ 1, 2, 3, 4, 1 ] ...
)];

param_values = [param_values; allcombs( ...
  { 'pw', 'nfchoa', 'nfchoa' }, ...
  { 13 }, ...
  { 'max-rE' }, ...
  { [0, 0, 0] }, ...
  { 3000, 3000, 56}, ...
  [ 1, 2, 3, 4, 1 ] ...
)];

param_values

%% evaluation

% compute and plot some sound fields
exhaustive_evaluation(@soundfields, param_names, param_values, conf, true);
