function [kal1, kal2] = local_aliasing_frequency(kvec, x0, x, R, delta)
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

isargmatrix(kvec)
isargvector(delta);
isargpositivescalar(R);
isargsecondarysource(x0);

%% ===== Main ============================================================

phik = cart2pol(kvec(:,1),kvec(:,2));
phin0 = cart2pol(x0(:,4),x0(:,5));

% k_Pu(x_0)
kPu = sin(phik - phin0);

% range for k_Gu(x-x_0)
xl0 = bsxfun(@minus, x, x0(:,1:3));
[phil0, rl0] = cart2pol(xl0(:,1),xl0(:,2));
select = rl0 > R;
        
kGu1 = zeros(size(xl0,1),1);
kGu2 = kGu1;

kGu1(~select) = 1;
kGu2(~select) = -1;

kGu1(select) = sin(min(wrapToPi(phil0(select) + asin(R./rl0(select)) - phin0(select)), pi/2));
kGu2(select) = sin(max(wrapToPi(phil0(select) - asin(R./rl0(select)) - phin0(select)),-pi/2));

kal1 = 2*pi./(delta.*abs(kPu-kGu1));
kal2 = 2*pi./(delta.*abs(kPu-kGu2));
