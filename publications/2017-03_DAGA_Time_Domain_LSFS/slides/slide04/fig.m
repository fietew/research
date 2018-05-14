% sound fields for GT and NFC-HOA at different frequencies and boardband

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

clear all
SFS_start;

%% Parameters
conf = SFS_config;
% plotting settings
conf.plot.useplot = true;
conf.plot.usegnuplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;

conf.showprogress = false;
conf.resolution = 300;
conf.usetapwin = true;

%% === Circular secondary sources ===
% config for real loudspeaker array
conf.dimension = '2.5D';
conf.usetapwin = false;
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';
conf.t0 = 'source';
conf.xref = conf.secondary_sources.center;

xs = [0, -1, 0];
src = 'pw';
X = [-1.55, 1.55];
Y = [-1.55, 1.55];
Z = 0;
pos = [0, 0, 0];
Rl = 0.5;

%% ===== WFS =============================================================

% monochromatic
for f = [1000, 2000, 3000]
  conf.nfchoa.order = ceil(2*pi*f/conf.c*Rl);
  [P,x,y] = sound_field_mono_nfchoa(X, Y, Z,xs,src,f,conf);
  gp_save_matrix(sprintf('P_hoa_f%d.dat', f),x,y,real(P));
  [Pgt,x,y] = sound_field_mono_plane_wave(X, Y, Z, xs, f, conf);
  gp_save_matrix(sprintf('P_gt_f%d.dat', f),x,y,real(Pgt));
end
% broad band
conf.plot.usedb = true;
[p,x,y] = sound_field_imp_nfchoa(X,Y,Z,xs,src,0,conf);
gp_save_matrix('p_hoa.dat',x,y,db(p));
[pgt,x,y] = sound_field_imp_plane_wave(X,Y,Z,xs,0,conf);
gp_save_matrix('p_gt.dat',x,y,db(pgt));
%
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);
