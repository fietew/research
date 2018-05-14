%

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

%% general settings
conf = SFS_config;
conf.dimension = '2.5D';
conf.showprogress = false;

% plotting
conf.plot.useplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;
conf.resolution = 300;
conf.usenormalisation = false;

conf.c = 343;  % speed of sound
conf.phase = 0;

%% config for real array
conf.usetapwin = false;
conf.tapwinlen = 0.0;

conf.secondary_sources.x0 = [];
conf.secondary_sources.geometry = 'box';
conf.secondary_sources.number = 64;
conf.secondary_sources.size = 4.0;
conf.secondary_sources.corner_radius = 0.0;
conf.secondary_sources.center = [0, 0, 0];
conf.secondary_sources.alpha = 3/2*pi;
conf.driving_functions = 'default';

conf.xref = [0, 0, 0];

%% config for virtual array
% wfs settings
conf.localsfs.method = 'wfs';
% tapering window
conf.localsfs.tapwinlen = 0.0;
conf.localsfs.usetapwin = false;

conf.localsfs.vss.geometry = 'rounded-box';
conf.localsfs.vss.size = 2.5;
conf.localsfs.vss.corner_radius = conf.localsfs.vss.size/2;
conf.localsfs.vss.center = [0, 0, 0];
conf.localsfs.vss.number = 256;
conf.localsfs.vss.consider_target_field = false;
conf.localsfs.vss.consider_secondary_sources = false;
conf.localsfs.vss.driving_functions = 'default';

%% ===== Custom Settings =====================================================
conf.rs = 4;
conf.phis = 0:1:90;
conf.frequency = 500;
conf.method = '';
