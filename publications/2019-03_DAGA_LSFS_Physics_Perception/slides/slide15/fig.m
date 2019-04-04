%

%*****************************************************************************
% Copyright (c) 2018      Fiete Winter                                       *
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

conf = SFS_config;

conf.plot.usenormalisation = true;
conf.plot.normalisation = 'center';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.secondary_sources.number = 56;
conf.c = 343;
conf.resolution = 300;
conf.xref = [-0.75,-0.75,0];
conf.modal_window = 'max-rE';
conf.nfchoa.order = 20;
conf.localwfs_sbl.fc = 1000;
conf.localwfs_sbl.Npw = 1024;
conf.localwfs_sbl.order = 20;

R = conf.secondary_sources.size/2;
xs = [0 2.5 0];
src = 'ps';
f= 2000;
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
Phoa = sound_field_mono_nfchoa(X,Y,Z,xs,src,f,conf);
Phoa = Phoa./abs(g);

% LWFS
Plwfs = sound_field_mono_localwfs_sbl(X,Y,Z,xs,src,f,conf);
Plwfs = Plwfs./abs(g);

% gnuplot
gp_save_matrix('Pwfs.dat', x, y, real(Pwfs));
gp_save_matrix('Phoa.dat', x, y, real(Phoa));
gp_save_matrix('Plwfs.dat', x, y, real(Plwfs));
gp_save('xref.txt', xref);
gp_save_loudspeakers('array.txt',x0);
