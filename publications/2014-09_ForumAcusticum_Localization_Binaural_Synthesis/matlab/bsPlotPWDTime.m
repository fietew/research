function bsPlotPWDTime(p, kpw, tpw, cb)
% function for plotting plane wave decomposition in time domain

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

if nargin < 4
  cb = false;
end

% minimum db
db_min = -50;
db_max = 0;

% compute azimuth angle (in deg)
phi = atan2(kpw(2,:), kpw(1,:))/pi*180;
phimin = min(phi);
phimax = max(phi);

p=db(p/max(abs(p(:))));
p(isinf(p) & sign(p) == -1) = db_min;

% dblim

tpw = tpw*1000;  % milliseconds

tpw_lim = max(abs(tpw(any(p > db_min, 2)))) + 1;
[tpw_min] = max(-tpw_lim, tpw(1));
[tpw_max] = min(tpw_lim, tpw(end));

imagesc(phi, tpw, p);
set(gca,'XDir','reverse');
set(gca,'YDir','normal');
xlabel('\(\phi\) / deg');
ylabel('\(t\) / ms');
set(gca,'CLim',[db_min db_max], ...
  'XTick',[-180; -120; -60; 0; 60; 120; 179], ...
  'XTickLabel',{'-180'; '-120'; '-60'; '0'; '60'; '120'; '180'});
axis([phimin phimax tpw_min tpw_max])
axis square
cm = colormap('jet');
cm = [cm; 1.0, 1.0, 1.0];
colormap(cm);
if (cb)
  colorbar;
end

end

