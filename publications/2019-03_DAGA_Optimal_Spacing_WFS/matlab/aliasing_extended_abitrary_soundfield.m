function [f, fx0] = aliasing_extended_abitrary_soundfield(x0, x, minmax_kGt_fun, conf)
%ALIASING_EXTENDED_ABITRARY_SOUNDFIELD aliasing frequency for an extended 
%listening area for arbitrary sound fields
%
%   Usage: f = aliasing_extended_abitrary_soundfield(x0, x, minmax_kGt_fun, conf)
%
%   Input options:
%       x0              - position, direction, and sampling distance of 
%                         secondary sources [N0x7] / m
%       x               - position for which aliasing frequency is calculated
%                         [Nx3] / m
%       minmax_kGt_fun  - function handle to determine the extremal value of 
%                         the tangential component of k_G(x-x0)
%                         [kGtmin, kGtmax] = minmax_kGt_fun(x0,x)
%       conf            - configuration struct (see SFS_config)
%
%   Output parameters:
%       f   - aliasing frequency [Nx1]
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

% sampling distance
deltax0 = abs(x0(:,7));

fx0 = inf(size(x,1), size(x0,1));
for xdx = 1:size(x,1);
    % mininum and maximum values of k_Gt(x - x_0) 
    % (tangential component of k_G(x-x0))
    [kGtmin, kGtmax] = minmax_kGt_fun(x0,x(xdx,:));
    % aliasing frequency for x
    fx0(xdx,:) = conf.c./(deltax0.*(1 + max(abs(kGtmin),abs(kGtmax))));
end
f = min(fx0, [], 2);
