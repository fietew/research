%

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

addpath('../../matlab');
SFS_start;

%% Parameters

conf = SFS_config;

conf.plot.usenormalisation = true;
conf.plot.normalisation = 'center';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.secondary_sources.number = 56;
conf.c = 343;
conf.resolution = 300;
conf.xref = [0,0,0];
conf.modal_window = 'max-rE';

R = conf.secondary_sources.size/2;
xs = [0 2.5 0];
src = 'ps';
f = 2000;
xref = conf.xref;

X = [-1.55, 1.55];
Y = [-1.55, 1.55];
Z = 0;

%% Computations
% SSD
x0 = secondary_source_positions(conf);

% normalisaton factor
g = sound_field_mono(xref(1), xref(2), xref(3), [xs, 0, 1, 0, 1], src, 1, f, conf);

% WFS
[Pwfs,x,y] = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
Pwfs = Pwfs./abs(g);

% NFCHOA
conf.nfchoa.order = 10;
Phoa_1 = sound_field_mono_nfchoa(X,Y,Z,xs,src,f,conf);
Phoa_1 = Phoa_1./abs(g);
conf.nfchoa.order = 20;
Phoa_2 = sound_field_mono_nfchoa(X,Y,Z,xs,src,f,conf);
Phoa_2 = Phoa_2./abs(g);

% gnuplot
gp_save_matrix('Pwfs.dat', x, y, real(Pwfs));
gp_save_matrix('Phoa_1.dat', x, y, real(Phoa_1));
gp_save_matrix('Phoa_2.dat', x, y, real(Phoa_2));
gp_save_loudspeakers('array.txt',x0);
