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

conf = SFS_config;

conf.plot.usenormalisation = true;
conf.plot.normalisation = 'center';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;
conf.xref = [0,0,0];

Lref = 2048;
L = 56;
R = conf.secondary_sources.size/2;
xs = [0 2.5 0];
src = 'ps';
srcg = 'ps';
fvec = [1500, 2000, 2500];
xref = conf.xref;

%% Aliasing Frequency
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);  % a_S(x0) >= 0
x0(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0
kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);

% evaluation points x
X = [-1.55, 1.55];
Y = [-1.55, 1.55];
Z = 0;
[x,y,~] = xyz_grid(X,Y,Z,conf);
xvec = [x(:), y(:)];
xvec(:,3) = 0;

% aliasing frequency at x
fS = aliasing(x0,kSx0,xvec,conf);
fS = reshape(fS, size(x));

% plotting
figure;
imagesc(X,Y,fS)
set(gca, 'YDir', 'normal');
hold on;
draw_loudspeakers(x0,[1 1 0], conf);
hold off;

% gnuplot
gp_save_matrix('fS.dat',x,y,fS);

%% Sound Fields
for f = fvec
  filesuffix = sprintf('_f%d.dat', f);

  % normalisaton factor
  g = sound_field_mono(xref(1), xref(2), xref(3), [xs, 0, 1, 0, 1], srcg, 1, f, conf);

  % synthesises sound field
  conf.secondary_sources.number = L;
  [P,x,y] = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
  P = P./abs(g);

  % gnuplot
  gp_save_matrix(['P' filesuffix], x, y, real(P));
end

%% SSD
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);
