function f = beamforming_extended(x0, kSx0, x, minmax_kSt_fun, conf)
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


phik = cart2pol(kSx0(:,1),kSx0(:,2));  % azimuth angle of kS(x0)
phin0 = cart2pol(x0(:,4),x0(:,5));  % azimuth angle of normal vector n0(x0)

% secondary source selection
select = cos(phin0 - phik) >= 0;  
x0 = x0(select,:);
% kSt(x0) (tangential component of kS(x0) )
kSt = sin(phin0(select) - phik(select));  

% mininum and maximum values of kSt(x_0)
[kStmin, kStmax] = minmax_kSt_fun(x0);
select = kSt >= kStmin & kSt <= kStmax;
x0 = x0(select,:);
kSt = kSt(select);

% sampling distance
deltax0 = abs(x0(:,7));

f = inf(size(x,1), 1);
for xdx = 1:size(x,1);
    % aliasing frequency for x
    f(xdx) = M.*conf.c./
end

