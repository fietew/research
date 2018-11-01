function kvec = local_aliasing_vector(kvec, n0, delta, k, eta)
%

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

%% ===== Checking of input  parameters ===================================
nargmin = 5;
nargmax = 5;
narginchk(nargmin,nargmax);

isargmatrix(kvec,n0)
isargvector(delta);
isargpositivescalar(k);
isargscalar(eta);

%% ===== Main ============================================================

phik = cart2pol(kvec(:,1),kvec(:,2));
phin0 = cart2pol(n0(:,1),n0(:,2));

kSt0 = sin(phin0-phik);  % tangential component of virtual sound field

phial = phin0 - asin(kSt0 + 2.*pi.*eta./(k.*delta));

kvec = NaN(size(phial,1),2);
select = imag(phial)==0;
phial = phial(select);

if ~isempty(phial)
    kvec(select,:) = [cos(phial), sin(phial)];
end
