% default configuration

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

conf = SFS_config;  % default configuration SFS Toolbox

%% misc & plotting
conf.showprogress = false;
conf.directory = ['.', filesep];
% plotting
conf.plot.useplot = false;
conf.plot.loudspeakers = false;
conf.plot.realloudspeakers = false;
conf.plot.usedb = true;
% binaural synthesis
conf.ir.usehcomp = false;

%% Local WFS settings
% wfs settings
conf.usetapwin = true;
conf.tapwinlen = 1.0;
conf.wfs.hpreflow = 540;
conf.wfs.hprefhigh = 22050;
conf.driving_functions = 'default';
conf.dimension = '2.5D';
conf.xref = [0, 0, 0];
% local wfs
conf.localsfs.method = 'wfs';
conf.localsfs.wfs = conf.wfs;
conf.localsfs.usetapwin = true;
conf.localsfs.tapwinlen = 0.3;
% real array
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 256;
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0, 0, 0];
% virtual array
conf.localsfs.vss.size = 0.6;
conf.localsfs.vss.center = [0, 0, 0];
conf.localsfs.vss.geometry = 'circular';
conf.localsfs.vss.number = 256;
conf.localsfs.vss.consider_target_field = false;
conf.localsfs.vss.consider_secondary_sources = false;
% delayline parameters
conf.delayline.resampling = 'none';
conf.delayline.resamplingfactor = 2;
conf.delayline.resamplingorder = 64; 
conf.delayline.filter = '';
conf.delayline.filterorder = NaN;
% desired sound field
conf.xs = [0.0, 2.5, 0];  % propagation direction of plane wave
conf.src = 'ps';
conf.dt = 0.5;