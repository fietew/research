function [bir, tbir] = bsAuralizePWD(p, tpw, hrirs, params)
%Filter PWD with respective HRIR 
%
%   Usage: [bir, tbir] = bsAuralizePWD(p, tpw, hrirs, params)
%
%   Input parameters:
%       p           - plane wave decomposition (time domain) [Ns x Npw]
%       tpw         - corresponding time axis [Ns x 1] 
%       hrirs       - hrirs dataset optained from read_irs (SFS-Toolbox)
%       params      - parameter struct (see script_parameters.m)
%
%   Output parameters:
%       bir         - filtered plane wave decompostion (time domain) 
%                     containing .left and .right (each [Ns+Nhrir x Npw])
%       tbir        - corresponding time axis [Ns+Nhrir x 1]
%
%   BSAURALIZE_PWD(p, tpw, hrirs, params) filters each direction of the pwd
%   impulse responses with the respective directional HRIR
%
%   see also: script_parameters, read_irs

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
Npw = size(p,2);  % Number of directions in plane wave decomposition
Ns = size(p,1);  % Number of pwd samples in time domain
Nhrir = size(hrirs.left,1);  % Number of hrirs' samples in time domain
Nbir = Ns + Nhrir;  % resulting Number of samples

hrirs = bsGetHRIRs(hrirs, Npw, params);  % get directional HRIRs

% zero padding since fftfilt does not care about cyclic convolution
hrirs.left  = [hrirs.left; zeros(Nbir-Nhrir, Npw)];
hrirs.right = [hrirs.right; zeros(Nbir-Nhrir, Npw)];
p = [p; zeros(Nbir-Ns, Npw)];
 
bir.left = fftfilt(hrirs.left, p);  % filter left channel 
bir.right = fftfilt(hrirs.right, p);  % filter right channel

tbir = [tpw, tpw(end) + (1:Nhrir)/params.conf.fs];  % extending time axis
end