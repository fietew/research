function [kGtmin, kGtmax] = minmax_kt_circle(x0, xc, Rc)
% determine the extremal value of the tangential component of k_G(x-x0) for 
% a circle

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

%% ===== Main ============================================================
phin0 = cart2pol(x0(:,4),x0(:,5));

% range for k_Gt(x-x_0) (tangential component of k_G)
xc = bsxfun(@minus, xc, x0(:,1:3));
[phil, rc] = cart2pol(xc(:,1),xc(:,2));
klt = sin(phin0 - phil);
kln = sqrt(1 - klt.^2);

rho = Rc./rc;

kGtmin = zeros(size(xc,1),1);
select = rho > 1 | -sqrt(1-rho.^2) > klt;
kGtmin(select) = -1;
kGtmin(~select) = klt(~select).*sqrt(1-rho(~select).^2) ...
    - kln(~select).*rho(~select);

kGtmax = zeros(size(xc,1),1);
select = rho > 1 | sqrt(1-rho.^2) < klt;
kGtmax(select) = +1;
kGtmax(~select) = klt(~select).*sqrt(1-rho(~select).^2) ...
    + kln(~select).*rho(~select);
