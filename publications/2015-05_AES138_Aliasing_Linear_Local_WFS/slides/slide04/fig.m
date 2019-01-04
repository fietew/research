% sound fields of WFS for different array lengths

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

clear all;
SFS_start;

%% Parameters
conf = SFS_config_example;
% plotting settings
conf.plot.useplot = true;
conf.plot.usegnuplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;

conf.showprogress = true;
conf.resolution = 300;
conf.usetapwin = true;
conf.ir.usehcomp = true;

%% === Circular secondary sources ===
% config for real loudspeaker array
conf.dimension = '2D';
conf.tapwinlen = 0.0;
conf.secondary_sources.geometry = 'linear';
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';
conf.xref = [0, 1, 0];

X = [0 0 0];
xs = [0, -1.0, 0];
src = 'ls';
xrange = [-1.55, 1.55];
yrange = [-0.05, 3.05];
zrange = 0;
f=1000;

%% ===== WFS =============================================================
% 1st subplot
conf.secondary_sources.size = 10;
conf.secondary_sources.number = conf.secondary_sources.size / 0.125 + 1;

x0 = secondary_source_positions(conf);
x0(:,4:6) = -x0(:,4:6);
x0 = secondary_source_selection(x0, xs, src);
x0 = secondary_source_tapering(x0, conf);
gp_save_loudspeakers('array_L10.txt',x0);

D = driving_function_mono_wfs(x0, xs, src, f, conf);
[P,x,y] = sound_field_mono(xrange, yrange, zrange, x0, 'ls', D, f, conf);
gp_save_matrix('sound_field_wfs_L10.dat',x,y,db(abs(P)/max(abs(P(:)))));

% 2st subplot
conf.secondary_sources.size = 2;
conf.secondary_sources.number = conf.secondary_sources.size / 0.125 + 1;

x0 = secondary_source_positions(conf);
x0(:,4:6) = -x0(:,4:6);
x0 = secondary_source_selection(x0, xs, src);
x0 = secondary_source_tapering(x0, conf);
gp_save_loudspeakers('array_L2.txt',x0);

D = driving_function_mono_wfs(x0, xs, src, f, conf);
[P,x,y] = sound_field_mono(xrange, yrange, zrange, x0, 'ls', D, f, conf);
gp_save_matrix('sound_field_wfs_L2.dat',x,y,db(abs(P)/max(abs(P(:)))));

% 3st subplot
conf.secondary_sources.size = 1;
conf.secondary_sources.number = conf.secondary_sources.size / 0.125 + 1;

x0 = secondary_source_positions(conf);
x0(:,4:6) = -x0(:,4:6);
x0 = secondary_source_selection(x0, xs, src);
x0 = secondary_source_tapering(x0, conf);
gp_save_loudspeakers('array_L1.txt',x0);

D = driving_function_mono_wfs(x0, xs, src, f, conf);
[P,x,y] = sound_field_mono(xrange, yrange, zrange, x0, 'ls', D, f, conf);
gp_save_matrix('sound_field_wfs_L1.dat',x,y,db(abs(P)/max(abs(P(:)))));