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

clear variables;

SFS_start;  % start Sound Field Synthesis Toolbox
addpath('../../matlab');

conf = SFS_config_example;

%% general settings
conf.dimension = '2.5D';
conf.resolution = 300;

conf.c = 343;  % speed of sound
conf.phase = 0;

%% config for real array
conf.secondary_sources.x0 = [];
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';

conf.xref = [0, 0, 0];

%% ===== Variables =======================================================
X0 = conf.secondary_sources.center;
r0 = conf.secondary_sources.size/2;
N0 = conf.secondary_sources.number;

src = 'pw';
phis = -90;
xs = [cosd(phis), sind(phis), 0];

X = [-2, 2];
Y = [-2, 2];
Z = 0;

%% ===== Computation of optimal radius of local region ===================

[x,y] = xyz_grid(X,Y,Z,conf);

for f = [3000, 5000]  
  rM = NaN(size(x));
  
  for idx=find(x(:).^2 + y(:).^2 <= r0^2).'
    rM(idx) = nfchoa_geometric_approximation([x(idx),y(idx),Z], phis, f, conf);
  end
  
  % gnuplot
  gp_save_matrix(sprintf('rM_f%d.dat', f), x, y, rM);  
end

x0 = secondary_source_positions(conf);  % secondary sources
gp_save_loudspeakers('array.txt',x0);