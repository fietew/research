% Spectrum of fractional delay filters

%*****************************************************************************
% Copyright (c) 2016      Fiete Winter                                       *
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

% workaround for bug in Matlab R2012b and higher
% 'BLAS loading error: dlopen: cannot load any more object with static TLS'
ones(10)*ones(10);

addpath('../../matlab');

SFS_start;  % start Sound Field Synthesis Toolbox

%% Parameters
parameters;  % load default configuration

%% Parameters which should be iterated
% parameters which should be varied for the evaluation
param_names = { ...
  'delayline.resampling' ...
  'delayline.filter', ...
  'delayline.filterorder', ...
  'dt' ...
  };

param_values = allcombs( ...
  { 'none' }, ...
  { 'lagrange', 'thiran' }, ...
  { 0, 1, 2, 3, 4, 5 }, ...
  { 0.49999999999 } ...
);

param_values = [param_values; allcombs( ...
  { 'pm' }, ...
  { 'lagrange' }, ...
  { 1 }, ...
  num2cell( 0.0:0.05:0.25 ) ...
)];

param_values

%% evaluation
conf.datafile = './data.txt';
delete(conf.datafile);
exhaustive_evaluation(@fdfilter_spectrum, param_names, param_values, conf, false);