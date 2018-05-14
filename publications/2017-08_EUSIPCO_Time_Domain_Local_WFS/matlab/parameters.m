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

%% Parameters
% === SFS compatible parameters ===
conf.showprogress = false;
conf.plot.useplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;
conf.plot.usedb = true;
conf.t0 = 'source';
conf.usebandpass = false;
% config for nfc-hoa
conf.nfchoa.order = [];
% config for wave field synthesis
conf.wfs.usehpre = true;
conf.wfs.hpreflow = 10;
conf.wfs.hprefhigh = 20000;
conf.usetapwin = false;
% config for loudspeaker array
conf.dimension = '2.5D';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';
% impulse response
conf.N = 2^12;
conf.ir.usehcomp = false;
% delayline parameters
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 2;
conf.delayline.resamplingorder = 64;
conf.delayline.filter = 'lagrange';
conf.delayline.filterorder = 3;
% === custom parameters ===
% config for local sound field synthesis
conf.localsfs.sbl.order = 27;
conf.localsfs.sbl.fc = 1200;  % cross-over frequency
conf.localsfs.sbl.Npw = 1024;
conf.localsfs.wfs = conf.wfs;
conf.localsfs.wfs.hprefhigh = 20000;
% 
conf.xs = NaN;
conf.src = '';
conf.xref = NaN;
conf.xeval = NaN;
conf.method = '';
conf.useplot = false;
conf.datafile = './data.txt';
conf.directory = './';
conf.localsfs.sbl.useap = 1;