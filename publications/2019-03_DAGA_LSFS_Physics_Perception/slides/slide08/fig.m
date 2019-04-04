% synthesised sound fields for WFS and different virtual source types

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

clear all
SFS_start;

%% Parameters
conf = SFS_config;
% plotting settings
conf.plot.useplot = false;
conf.plot.usegnuplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;

conf.showprogress = false;
conf.resolution = 300;
conf.usetapwin = true;

conf.dimension = '2.5D';
conf.usetapwin = false;
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';
conf.t0 = 'source';
conf.xref = conf.secondary_sources.center;

X = [-1.55, 1.55];
Y = [-1.55, 1.55];
Z = 0;
pos = [0, 0, 0];
f = 2000;
xref = conf.xref;

%% Calculations
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];

% plane wave 1
[P,x,y] = sound_field_mono_wfs(X, Y, Z,[0, -1, 0],'pw',f,conf);
g = sound_field_mono_plane_wave(xref(1),xref(2),xref(3),[0, -1, 0], f, conf);
gp_save_matrix('P_pw1.dat',x,y,real(P)./abs(g));

% plane wave 2
[P,x,y] = sound_field_mono_wfs(X, Y, Z,[1, 0, 0],'pw',f,conf);
g = sound_field_mono_plane_wave(xref(1),xref(2),xref(3),[1, 0, 0], f, conf);
gp_save_matrix('P_pw2.dat',x,y,real(P)./abs(g));

% point source
[P,x,y] = sound_field_mono_wfs(X, Y, Z,[0, 2.5, 0],'ps',f,conf);
g = sound_field_mono_point_source(xref(1),xref(2),xref(3),[0, 2.5, 0], f, conf);
gp_save_matrix('P_ps.dat',x,y,real(P)./abs(g));

% focused point source
[P,x,y] = sound_field_mono_wfs(X, Y, Z,[0, 0.75, 0, 0, -1, 0],'fs',f,conf);
g = sound_field_mono_point_source(xref(1),xref(2),xref(3),[0,0.75, 0], f, conf);
gp_save_matrix('P_fs.dat',x,y,real(P)./abs(g));

% secondary sources
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);