function f = aliasing_modal(x0, kSx0, x, xc, M, conf)
%ALIASING_MODAL aliasing frequency at position x for an circular control area 
%at xc with R=M/k where synthesis is focused on.
%
%   Usage: f = aliasing_modal(x0, kSx0, x, xc, M, conf)
%
%   Input options:
%       x0              - position, direction, and sampling distance of 
%                         secondary sources [N0x7] / m
%       kSx0            - normalised local wavenumber vector kS(x0) 
%                         of virtual sound field at x0 [N0x3]
%       x               - position for which aliasing frequency is calculated
%                         [Nx3]
%       xc              - center of circular control area
%       M               - modal order which defines the radius R=M/k
%       conf            - configuration struct (see SFS_config)
%
%   Output parameters:
%       f   - aliasing frequency [Nx1]
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

% the position x is a circular area with radius 0
minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,0);

f = aliasing_extended_modal(x0, kSx0, x, minmax_kGt_fun, xc, M, conf);
