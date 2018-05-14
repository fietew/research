function [in, kpw] = bsAngularResolution(in, kpw, res)
%Change angular resolution of plane wave decomposition
%
%   Usage: [in, kpw] = bsAngularResolution(in, kpw, res)
%
%   Input parameters:
%       in          - plane wave decomposition (time or frequency domain)
%       kpw         - corresponding plane wave incidence direction vectors
%       res         - resolution in degree (no upsampling possible)
%
%   Output parameters:
%       in          - subsampled plane wave decomposition
%       kpw         - corresponding plane wave incidence direction vectors
%
%   BSANGULAR_RESOLUTION(nk,x0,f,conf)

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

%% ===== Computation =========================================================

% subsampling factor
% new resolution / old resolution
k = res/(360/ size(in,2));

% at the moment only integer subsampling is possible
if (k < 1)
  error('TODO: interpolation of PWD (for fractional k)');
elseif (round(k) ~= k)
  error('only integers of old resolution');
end

in = in(:,1:k:end);
kpw = kpw(:,1:k:end);
