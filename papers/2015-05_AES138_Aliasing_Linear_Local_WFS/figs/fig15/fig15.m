% Plot sound fields for comparison of LWFS and WFS

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

clear variables;
close all;

SFS_start;
addpath('../../matlab');

%% Parameters
conf = SFS_config_example;

conf.showprogress = true;
conf.usenormalisation = true;
conf.usetapwin = false;

conf.dimension = '2D';
conf.resolution = 400;
conf.plot.useplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = true;
conf.plot.lssize = 0.08;

% config for virtual array
conf.localsfs.method = 'wfs';
conf.localsfs.usetapwin = false;
conf.localsfs.vss.size = 1.0;
conf.localsfs.vss.center = [0, 1.5, 0];
conf.localsfs.vss.geometry = 'linear';
conf.localsfs.vss.number = 7;
conf.localsfs.vss.consider_target_field = true;
conf.localsfs.vss.consider_secondary_sources = false;

Xl = conf.localsfs.vss.center(1);
Yl = conf.localsfs.vss.center(2);
Ll = conf.localsfs.vss.size;

% config for real array
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0, 0, 0];
conf.secondary_sources.geometry = 'linear';
conf.secondary_sources.number = 16;
conf.driving_functions = 'default';
conf.xref = [0 2.0 0];

X0 = conf.secondary_sources.center(1);
Y0 = conf.secondary_sources.center(2);
L0 = conf.secondary_sources.size;

x0 = secondary_source_positions(conf);
x0(:, 4:6) = -x0(:, 4:6);

% config for virtual source
xs = [0.0, -1.0, 0];
src = 'ps';
xrange = [-1.5, 1.5];
yrange = [ 0, 3];
zrange = 0;
f = 3000;

%% geometric approximations
gamma1 = atan2( Yl - Y0, (Xl + Ll/2) - (X0 - L0/2));
gamma2 = atan2( Yl - Y0, (Xl - Ll/2) - (X0 + L0/2));

alpha0 = atan2(Y0 - xs(2), X0 + L0 / 2 - xs(1));
beta0 = atan2(Y0 - xs(2), X0 - L0 / 2 - xs(1));

alphal = atan2(Yl - xs(2), Xl + Ll / 2 - xs(1));
betal = atan2(Yl - xs(2), Xl - Ll / 2 - xs(1));

f0 = conf.c*( conf.secondary_sources.number - 1 ) / ...
  L0 / (cos(max(alpha0,alphal)) - cos(min(beta0,betal)))

%%
Dwfs = driving_function_mono_wfs(x0,xs,src,f,conf);

[P, x, y, z] = sound_field_mono(xrange,yrange,zrange,x0,'ls',Dwfs,f,conf);
plot_sound_field(P,x,y,z,x0,conf);
set(gca, 'YTick', [0, 1, 2, 3]);

matlab2tikz( 'fig15-1.tex', ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false, ...
  'showInfo', false);

%%
[D, xactive, xv] = driving_function_mono_localwfs(x0,xs,src,f,conf);
[P, x, y, z] = sound_field_mono(xrange,yrange,zrange,xactive,'ls',D,f,conf);
plot_sound_field(P,x,y,z,xactive,conf);
hold on
conf.plot.realloudspeakers = false;
draw_loudspeakers(xv,[1 1 0],conf);
conf.plot.realloudspeakers = true;
ylabel('');
set(gca, 'YTick', [0, 1, 2, 3]);
set(gca, 'YTickLabel', {});
hold off

matlab2tikz( 'fig15-2.tex', ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false, ...
  'showInfo', false);

fl1 = conf.c * (conf.localsfs.vss.number - 1) / ...
  conf.localsfs.vss.size / (cos(alphal) - cos(gamma2))
fl2 = conf.c * (conf.localsfs.vss.number - 1) / ...
  conf.localsfs.vss.size / (cos(gamma1) - cos(betal))

%%
conf.localsfs.vss.number = 17;
[D, xactive, xv] = driving_function_mono_localwfs(x0,xs,src,f,conf);
[P, x, y, z] = sound_field_mono(xrange,yrange,zrange,xactive,'ls',D,f,conf);
plot_sound_field(P,x,y,z,xactive,conf);
hold on
conf.plot.realloudspeakers = false;
draw_loudspeakers(xv,[1 1 0],conf);
conf.plot.realloudspeakers = true;
hold off
ylabel('');
set(gca, 'YTick', [0, 1, 2, 3]);
set(gca, 'YTickLabel', {});
hcb = colorbar;

matlab2tikz( 'fig15-3.tex', ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false, ...
  'showInfo', false);

fl1 = conf.c * (conf.localsfs.vss.number - 1) / ...
  Ll / (cos(alphal) - cos(gamma2))
fl2 = conf.c * (conf.localsfs.vss.number - 1) / ...
  Ll / (cos(gamma1) - cos(betal))

%%
[P, x, y, z] = sound_field_mono(xrange,yrange,zrange,[xs, 0, 1, 0, 1],'ls',1,f,conf);
plot_sound_field(P,x,y,z,xactive,conf);
