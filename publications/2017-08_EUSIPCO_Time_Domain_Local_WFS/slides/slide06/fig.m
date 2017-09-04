% sound fields for GT and NFC-HOA at different frequencies and boardband

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

clear variables
SFS_start;

%% Parameters
conf = SFS_config;
conf.plot.useplot = true;
conf.plot.normalisation = 'center';
conf.plot.usenormalisation = true;

conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.dimension = '2.5D';
conf.usetapwin = false;
conf.driving_functions = 'default';
conf.t0 = 'source';
conf.xref = [-0.5,0,0];

conf.localwfs_sbl.Npw = 1024;
conf.localwfs_sbl.order = 27;

xs = [0, 2.5, 0];
src = 'ps';
X = [-1.55, 1.55];
Y = [-1.55, 1.55];
Z = 0;
t = norm(xs-conf.xref)/conf.c;
g = 1./(4*pi*norm(xs-conf.xref));


%% ===== WFS =============================================================

% monochromatic
for f = [1000, 2000, 3000]
  [P,x,y] = sound_field_mono_localwfs_sbl(X, Y, Z,xs,src,f,conf);
  gp_save_matrix(sprintf('P_lwfs_f%d.dat', f),x,y,real(P./g));
  % radius of high accuracy defined by modal order
  phi = (0:360).';
  rM = conf.localwfs_sbl.order*conf.c/(2*pi*f);
  rM = [rM*cosd(phi)+conf.xref(1), rM*sind(phi)+conf.xref(2)];
  hold on;
  plot(rM(:,1),rM(:,2),'k--')
  hold off;
  gp_save(sprintf('P_lwfs_f%d_rM.txt',f), rM);
  
  [Pgt,x,y] = sound_field_mono_point_source(X, Y, Z, xs, f, conf);
  gp_save_matrix(sprintf('P_gt_f%d.dat', f),x,y,real(Pgt./g));
end
% broad band
conf.plot.usedb = true;
[p,x,y] = sound_field_imp_localwfs_sbl(X,Y,Z,xs,src,t,conf);
gp_save_matrix('p_lwfs.dat',x,y,db(p./g));
[pgt,x,y] = sound_field_imp_point_source(X,Y,Z,xs,t,conf);
gp_save_matrix('p_gt.dat',x,y,db(pgt./g));
% ssd
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);
% xref
gp_save('xc.txt', conf.xref(1:2));


