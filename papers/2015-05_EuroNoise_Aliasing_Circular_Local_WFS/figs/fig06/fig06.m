% sound fields for comparison between WFS and local WFS

%*****************************************************************************
% Copyright (c) 2015      Fiete Winter                                       *
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
close all;

SFS_start;
addpath('../../matlab');

%% parameters

conf = SFS_config_example;

conf.showprogress = true;
conf.usenormalisation = true;
conf.usetapwin = true;
conf.tapwinlen = 0.5;

conf.dimension = '2D';
conf.resolution = 300;
conf.plot.useplot = false;
conf.plot.loudspeakers = false;
conf.plot.realloudspeakers = true;
conf.plot.lssize = 0.08;

% config for virtual array
conf.localsfs.method = 'wfs';
conf.localsfs.usetapwin = false;
conf.localsfs.vss.size = 1.0;
conf.localsfs.vss.center = [0, 0, 0];
conf.localsfs.vss.geometry = 'circular';
conf.localsfs.vss.number = 25;
conf.localsfs.vss.consider_target_field = true;
conf.localsfs.vss.consider_secondary_sources = false;

% config for real array
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 40;
conf.driving_functions = 'default';
conf.xref = [0 0 0];

% config for virtual sources
xs = [0.0, -1.0, 0];  % propagation direction of plane wave
src = 'pw';
xrange = [-1.6, 1.6];
yrange = [-1.6, 1.6];
zrange = 0;
f = 1800;

%%%%%%%%%%%%%%%%%%%% just for plotting the secondary sources
x0 = secondary_source_positions(conf);
%%%%%%%%%%%%%%%%%%%%

%% Plot for Local WFS
sound_field_mono_localwfs(xrange, yrange, zrange, xs, src, f, conf);
draw_loudspeakers(x0,[1 1 0],conf);
set(gca, 'XTick', -1:1);
set(gca, 'YTick', -1:1);
xlabel('');
ylabel('');

h(1) = gcf;

%% Plot for WFS
sound_field_mono_wfs(xrange, yrange, zrange, xs, src, f, conf);
draw_loudspeakers(x0,[1 1 0],conf);
set(gca, 'XTick', -1:1);
set(gca, 'YTick', -1:1);
set(gca, 'YTickLabel', {});
xlabel('');
ylabel('');
hcb = colorbar('location','northoutside');

h(2) = gcf;

%% save pgfplot
for idx=1:2
  matlab2tikz( ['fig06-', num2str(idx), '.tex'], ...
    'figurehandle', h(idx), ...
    'height', '\fheight', ...
    'width', '\fwidth', ...
    'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
    'parseStrings', false, ...
    'showInfo', false);
end
