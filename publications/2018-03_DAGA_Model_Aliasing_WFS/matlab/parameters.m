% default configuration

%*****************************************************************************
% Copyright (c) 2015-2018 Fiete Winter                                       *
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
conf.plot.useplot = true;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;
conf.plot.usedb = false;
conf.plot.usenormalisation = false;

% sound field computation
conf.resolution = 200;
conf.phase = 0;
% config for wave field synthesis
conf.usetapwin = false;
% config for loudspeaker array
conf.dimension = '2.5D';
conf.secondary_sources.geometry = '';
conf.secondary_sources.number = NaN;
conf.driving_functions = 'default';

conf.c = 343;

conf.xref = [0, -1, 0];
% === custom parameters
conf.xs = NaN;
conf.src = '';
conf.f = NaN;
conf.eta = NaN;
conf.rc = NaN;
conf.rl = NaN;
conf.method = '';
conf.X = [-1.5,1.5];
conf.Y = [-2, 1];
conf.Z = 0;
conf.Ygt = [0, 3];
conf.idSPA = 67;