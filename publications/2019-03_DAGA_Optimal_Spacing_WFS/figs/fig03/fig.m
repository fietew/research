% comparison of equidistant and optimised sampling for point source

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

N0 = 128;
N0ref = 2^13;

xs = [ 0, 2.5, 0];
src = 'ps';
[phis, rs] = cart2pol(xs(1),xs(2));  % polar coordinates

R = 1.5;
Rcvec = [0.25, 0.5];

xcvec = [%
  0,  0.75, 0;
   0, 0, 0;
  0, -0.75, 0;
  -0.75, 0, 0;
  ];
gp_save('xc.txt', xcvec);  % gnuplot

%% optimising for position and (optionally soundfield)
phiplot = (0:360).';

x0fun = @(s) circle(s,R);

% x0ref
smin = R.*(-acos(R/rs) + phis);
smax = R.*(+acos(R/rs) + phis);
s0ref = linspace(smin, smax, N0ref).';
x0ref = x0fun(s0ref);
x0ref(:,7) = (smax - smin)./(N0-1);
gp_save_loudspeakers('array.txt', x0ref);  % gnuplot

% local wavenumber kS of virtual sound field at x0ref
kSx0ref = local_wavenumber_vector(x0ref(:,1:3), xs, src);

odx = 1;
for opt = {'pos', 'both'}
  
  ratiovec = zeros(size(x0ref,1),size(Rcvec,2)*size(xcvec,1));
  xcplot = zeros(size(phiplot,1),size(Rcvec,2)*size(xcvec,1));
  
  xdx = 1;
  for xc = xcvec.'  

    for Rc = Rcvec    
      % circular area at xc with radius Rc
      minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,Rc);

      switch opt{1}
        case 'pos'
          aliasing_fun = @(x0, kS, x) ...
            aliasing_extended_abitrary_soundfield(x0, x, minmax_kGt_fun, conf);
        case 'both'
          aliasing_fun = @(x0, kS, x) ....
            aliasing_extended(x0, kS, x, minmax_kGt_fun, conf);
      end    
      % aliasing for xc  
      [~, fx0ref] = aliasing_fun(x0ref, kSx0ref, xc.');

      % optimized aliasing (now constant wrt. to x0)
      fopt = N0ref./sum(1./fx0ref);

      ratiovec(:,xdx) = fx0ref.'./fopt;

      xcplot(:,2*xdx-1) = xc(1) + Rc*cosd(phiplot);
      xcplot(:,2*xdx)   = xc(2) + Rc*sind(phiplot);
      
      xdx = xdx+1;
    end    
  end
  
  %
  figure(odx);
  plot(-(s0ref./R-phis), ratiovec);
  
  % gnuplot
  gp_save(['ratio_', opt{1}, '.txt'], [-(s0ref./R-phis), ratiovec]);
  
  odx = odx + 1;
end

gp_save('circles.txt', xcplot);  % gnuplot

%% only optimising for sound field

% circular area at xc with radius Rc
minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,[0,0,0],Inf);

% aliasing frequency for xc  
[~, fx0ref] = aliasing_extended(x0ref, kSx0ref, xc.', minmax_kGt_fun, conf);

% optimized aliasing (now constant wrt. to x0)
fopt = N0ref./sum(1./fx0ref);

ratiovec = fx0ref.'./fopt;

% gnuplot
gp_save('ratio_src.txt', [-(s0ref./R-phis), ratiovec]);
