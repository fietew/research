function bsPlotPWDFrequency(P, kpw, fpw, cb)
% function for plotting plane wave decomposition in frequency domain

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


fnorm = 500;
phinorm = 0;

% minimum db
db_min = -50;
db_max = 0;

fmin = 100;
fmax = 20000;

% compute azimuth angle (in deg)
phi = atan2(kpw(2,:), kpw(1,:))/pi*180;

phimin = min(phi);
phimax = max(phi);

[~, idx_fmin] = min(abs(fpw - fmin));
[~, idx_fmax] = min(abs(fpw - fmax));

% normalize
P=db(P/max(max(abs(P(idx_fmin:idx_fmax,:)))));

P(isinf(P)) = db_min; %note that this handles P=+/-inf we might not that what ge want

imagesc(phi, fpw, P);
set(gca,'XDir','reverse');
set(gca,'YDir','normal');
shading interp;
view(0,90);
xlabel('\(\phi\) / deg');
ylabel('\(f\) / Hz');
set(gca,'CLim',[db_min db_max], ...
  'XTick',[-180; -120; -60; 0; 60; 120; 179], ...
  'XTickLabel',{'-180'; '-120'; '-60'; '0'; '60'; '120'; '180'});
axis([phimin phimax fmin fmax])
axis square
cm = colormap('jet');
cm = [cm; 1.0, 1.0, 1.0];
colormap(cm);
if (cb)
  colorbar;
end

end

