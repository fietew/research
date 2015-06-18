function H = localwfs_prefilter(f, conf)

%*****************************************************************************
% Copyright (c) 2010-2015 Quality & Usability Lab, together with             *
%                         Assessment of IP-based Applications                *
%                         Telekom Innovation Laboratories, TU Berlin         *
%                         Ernst-Reuter-Platz 7, 10587 Berlin, Germany        *
%                                                                            *
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
nargmin = 1;
nargmax = 2;
narginchk(nargmin,nargmax);
isargvector(f);
if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end

%% ===== Configuration ==================================================
usehpre = conf.wfs.usehpre;
dimension = conf.dimension; % dimensionality
flow = conf.wfs.hpreflow;   % Lower frequency limit of preequalization
                            % filter (= frequency when subwoofer is active)
fhigh = conf.wfs.hprefhigh; % Upper frequency limit of preequalization
                            % filter (= aliasing frequency of system)

%% ===== Variables ======================================================
% Find indices for frequencies in f smaller and nearest to fhigh and flow
idxfhigh = find(f<fhigh,1,'last');
idxflow = find(f<flow,1,'last');
% Initialize response
H = ones(length(f),1);

%% ===== Computation ====================================================
% Check if we should procide
if ~usehpre
    return;
end

% Desired response
%   ^
% 1_|          fhigh_______
%   |            /
%   |        /
%   | ___/
%   |  flow
%   -------------------------> f
%
% Pre-equilization filter from flow to fhigh
if strcmp('2.5D',dimension)
    %
    H(idxflow:idxfhigh) = f(idxflow:idxfhigh)./fhigh;
elseif strcmp('3D',dimension) || strcmp('2D',dimension)
    %
    H(idxflow:idxfhigh) = f(idxflow:idxfhigh).^2./fhigh.^2;
else
    error('%s: %s is not a valid conf.dimension entry',upper(mfilename));
end

% % Set the response for idxf < idxflow to the value at idxflow
H(1:idxflow) = H(idxflow)*ones(idxflow,1);

end
