function bsPlotBIR(bir, kpw, tbir)
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

% minimum db
db_lim = -50;

% normalize
bmax = max(abs(bir.left), abs(bir.right));
n = max(bmax(:));

bl = db(bir.left/n);
br = db(bir.right/n);
bl(bl < db_lim) = db_lim;
br(br < db_lim) = db_lim;

bmax = db(bmax/n);

%
if (nargin < 3)
  tbir = (0:size(bir.left,1)-1)/bir.fs;
end

tlim = max(abs(tbir(any(bmax > db_lim, 2)))) + 1e-3;
tmin = max(-tlim, tbir(1));
tmax = min(tlim, tbir(end));

if nargin < 2 || isempty(kpw)
  figure
  subplot(1,2,1)
  plot(tbir, bir.left);
  xlabel('time (s)');
  xlim([tmin tmax])

  subplot(1,2,2)
  plot(tbir, bir.right);
  xlabel('time (s)');
  xlim([tmin tmax])
else
  % compute azimuth angle (in deg)
  phi = atan2(kpw(2,:), kpw(1,:))/pi*180;

  phimin = min(phi);
  phimax = max(phi);

  figure
  subplot(1,2,1)
  imagesc(phi, tbir, bl);
  set(gca,'XDir','reverse');
  set(gca,'YDir','normal');
  xlabel('angle (deg)');
  ylabel('time (s)');
  set(gca,'CLim',[db_lim 0]);
  axis([phimin phimax tmin tmax])
  axis square
  colorbar;

  subplot(1,2,2)
  imagesc(phi, tbir, br);
  set(gca,'XDir','reverse');
  set(gca,'YDir','normal');
  xlabel('angle (deg)');
  ylabel('time (s)');
  set(gca,'CLim',[db_lim 0]);
  axis([phimin phimax tmin tmax])
  axis square
  colorbar;
end
end
