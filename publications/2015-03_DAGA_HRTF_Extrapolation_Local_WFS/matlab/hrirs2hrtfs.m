function tfs = hrirs2hrtfs(irs, conf)

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

%% ===== Check input arguments ===========================================
nargmin = 1;
nargmax = 2;
narginchk(nargmin,nargmax);
if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end

%% Convert irs to tfs

N = size(irs.left, 1); % length of impulse responses
M = size(irs.left, 2); % number of measurements

if N < conf.N
  irs.left = [irs.left; zeros(conf.N-N,M)];
  irs.right = [irs.right; zeros(conf.N-N,M)];
else
  irs.left = irs.left(1:conf.N,:);
  irs.right = irs.right(1:conf.N,:);
end

tfs = irs;  % copy metadata from
tfs.left = zeros(conf.N/2, M);
tfs.right = zeros(conf.N/2, M);

for idx=1:M
  [amplitude, phase, f] = easyfft(irs.left(:,idx), conf);
  tfs.left(:,idx) = amplitude .* exp(1j*phase);
  [amplitude, phase] = easyfft(irs.right(:,idx), conf);
  tfs.right(:,idx) = amplitude .* exp(1j*phase);
end
tfs.f = f;
