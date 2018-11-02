function [phial, ral, xsec, etaal, fal] = nfchoa_grating_lobes(xc, phipw, f, M, etarange, conf)

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

%% ===== Checking of input  parameters ==================================
nargmin = 5;
nargmax = 6;
narginchk(nargmin,nargmax);
isargposition(xc);
isargscalar(phipw);
isargpositivescalar(f,M);
if nargin<nargmax
  conf = SFS_config;
else
  isargstruct(conf);
end

%% ===== Variables ======================================================
k = 2.*pi.*f./conf.c;

r0 = conf.secondary_sources.size / 2;
L = conf.secondary_sources.number;

rc = norm(xc);
phic = atan2d(xc(2),xc(1));

cospw = cosd(phipw);
sinpw = sind(phipw);
%% ===== Computation ====================================================

dc = rc.*sind(phic - phipw);

% intersection point on circular secondary source distribution
xsec = ( [cospw, -sinpw; sinpw, cospw]*[-sqrt(r0.^2 - dc.^2); dc] ).';

% assumed properties of the baseband spectrum:
%
% energy concentrated on coefficients with indexes between mmin < m < mmax, 
% whereby
% mmin = max(k*dc - M, -k*ro)
% mmax = min(k*dc + M, k*ro)
%
% for low frequencies, this is a triangle (-k*r0 < m < k*r0)
% for high frequencies, this is a parallelogram (k*dc - M < m < k*dc + M)

ral = [];
phial = [];
etaal = [];
fal = [];

for eta = etarange
  % first aliasing frequency (intersection between spectral repetition
  % and spectrum of Green's function)
  % quiet complicated, as the baseband spectrum is complicated
  if eta < 0
    % Intersection condtions: eta*L+mmax = -k*r0 with
    % mmax = min(k*dc + M, k*ro)
    kal = max((-eta*L-M)/(r0+dc), -eta*L/(2*r0));
  else
    % Intersection condtions: eta*L+mmin = k*r0 with
    % mmin = max(k*dc - M, -k*ro)
    kal = max((eta*L-M)/(r0-dc), eta*L/(2*r0));
  end
  % second aliasing frequency
  if eta < 0
    % Intersection condtions: eta*L+mmin = -k*r0 with
    % mmin = max(k*dc - M, -k*ro)    
    kal2 = (-eta*L+M)/(r0+dc);
  else
    % Intersection condtions: eta*L+mmax = k*r0 with
    % mmax = min(k*dc + M, k*ro)
    kal2 = (eta*L+M)/(r0-dc);
  end
  % grating lobe existing?
  if k <= kal
    continue;  % no: try next (other eta)
  end
  mmin = max(-k*r0, eta*L + max(k*dc-M, -k*r0) );
  mmax = min(k*r0, eta*L + min(k*dc+M, k*r0) );
  dal = (mmax + mmin)/(2*k);
  ral = [ral; (mmax - mmin)/(2*k)];
  % propagation direction of grating lobe
  cosal = xsec*[-sqrt(r0.^2-dal.^2);dal]./r0.^2;
  sinal = xsec*[-dal;-sqrt(r0.^2-dal.^2)]./r0.^2;
  phial = [phial; atan2d(sinal, cosal)];
  
  etaal = [etaal; eta];
  fal = [fal; conf.c/(2*pi)*[kal, kal2]];
end
