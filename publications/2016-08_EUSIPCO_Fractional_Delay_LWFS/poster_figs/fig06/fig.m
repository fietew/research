% Spectrum of reproduced sound field at reference position

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
conf = SFS_config;
conf.showprogress = false;
conf.plot.useplot = false;
conf.plot.loudspeakers = false;
conf.plot.realloudspeakers = false;
conf.plot.usedb = true;
conf.usetapwin = true;
conf.tapwinlen = 1.0;
% config for virtual array
conf.localsfs.method = 'wfs';
conf.localsfs.wfs = conf.wfs;
conf.localsfs.usetapwin = true;
conf.localsfs.tapwinlen = 0.3;
conf.localsfs.vss.size = 0.6;
conf.localsfs.vss.center = [0, 0, 0];
conf.localsfs.vss.geometry = 'circular';
conf.localsfs.vss.number = 256;
conf.localsfs.vss.consider_target_field = false;
conf.localsfs.vss.consider_secondary_sources = false;
% config for real array
conf.dimension = '2.5D';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 256;
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';
conf.xref = conf.localsfs.vss.center;
% impulse response
conf.ir.usehcomp = false;
% listening area, virtual source
conf.xs = [0.0, 2.5, 0];  % propagation direction of plane wave
conf.src = 'ps';

% delayline parameters
conf.delayline.resampling = '';
conf.delayline.resamplingfactor = NaN;
conf.delayline.resamplingorder = 64;
conf.delayline.filter = '';
conf.delayline.filterorder = NaN;

%% Parameters which should be iterated
% parameters which should be varied for the evaluation
param_names = { ...
  'xref', ...
  'localsfs.vss.center' ...
  'localsfs.vss.number', ...
  'secondary_sources.number', ...
  'delayline.resampling', ...
  'delayline.resamplingfactor', ...
  'delayline.filter', ...
  'delayline.filterorder', ...
  };

param_values = allcombs( ...
  { [0,0,0], [-0.5,0,0] }, ...
  { [0,0,0], [-0.5,0,0] }, ...
  { 64, 128 }, ...
  { 32, 64, 128 }, ...
  { 'none', 'pm' }, ...
  { NaN, 8 }, ...
  { 'zoh', 'lagrange'}, ...
  { NaN, 9 }, ...
  [1, 1, 3:4, 5, 5, 5, 5] ...
);

param_values

%% evaluation
% calculate impulse responses at xref
exhaustive_evaluation(@lwfs_ir, param_names, param_values, conf, true);
% calculate magnitude spectra
conf.datafile = './data.txt';
delete(conf.datafile);
exhaustive_evaluation(@lwfs_sf_spectrum, param_names, param_values, conf, ...
  false);