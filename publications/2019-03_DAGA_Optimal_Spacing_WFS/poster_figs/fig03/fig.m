% sound fields and local wavenumber vector

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

SFS_start;
addpath('../../matlab');

%% Config
conf = SFS_config;


%% Variables
xps = [0, -1, 0];
npw = [sqrt(0.5), sqrt(0.5), 0];
xref = [0 1 0];

f = 500;

X = [-4, 4];
Y = [-4, 4];
Z = 0;

%% Sound Fields
conf.resolution = 300;
% ground truth
Ppw = sound_field_mono_plane_wave(X,Y,Z,npw,f,conf);
[Pps,x,y,z] = sound_field_mono_point_source(X,Y,Z,xps,f,conf);
% normalisation factor for gnuplot
gpw = sound_field_mono_plane_wave(xref(1),xref(2),xref(3),npw,f,conf);
gps = sound_field_mono_point_source(xref(1),xref(2),xref(3),xps,f,conf);

%% Local Wave Vector
conf.resolution = 30;
[xk,yk] = xyz_grid(X,Y,Z,conf);
xk = [xk(:),yk(:)];
xk(:,3) = Z;
kpw = local_wavenumber_vector(xk, npw, 'pw');
kps = local_wavenumber_vector(xk, xps, 'ps');

%% gnuplot
gp_save_matrix('Ppw.dat',x,y,real(Ppw./abs(gpw)));
gp_save_matrix('Pps.dat',x,y,real(Pps./abs(gps)));
gp_save('kpw.txt', [xk,kpw]);
gp_save('kps.txt', [xk,kps]);
