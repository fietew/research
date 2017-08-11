function [irs] = bsGetHRIRs(hrirs, Npw, params)
% Get directional HRIRs (equ-angular azimuth from [-180:180))
%
%   Usage: [irs] = bsGetHRIRs(hrirs, Npw, params)
%
%   Input parameters:
%       hrirs       - hrirs dataset optained from read_irs (SFS-Toolbox)
%       Npw         - number of angular samples
%       params      - parameter struct (see script_parameters)
%
%   Output parameters:
%       irs         - directional HRIRs for phi=[-180:360/pi:180). Contains
%                     .right and .left (each [Nhrir x Npw])
%
%   bsGetHRIRs(p, tpw, hrirs, params) filters each direction of the pwd
%   impulse responses with the respective directional HRIR
%
%   see also: script_parameters, read_irs

%*****************************************************************************
% Copyright (c) 2014-2015 Fiete Winter                                       *
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

Nhrir = size(hrirs.left,1); % length of HRIRs

% equi-angular sampling
phi= 2.0*pi/Npw*(0:(Npw-1)) - pi;
theta = pi/2.0*ones(1,Npw);
r = hrirs.distance*ones(3,Npw);

% select irs from hrirs dataset
irs.left = zeros(Nhrir, Npw);
irs.right = zeros(Nhrir, Npw);
for idx=1:Npw;
  tmp = get_ir(hrirs, [phi(idx) theta(idx) r(idx)], 'spherical', params.conf);
  irs.left(:,idx) = tmp(:,1);
  irs.right(:,idx) = tmp(:,2);
end

end