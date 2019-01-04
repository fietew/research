function hrtf = localwfs_hrtfs(wL, wR, d0, hrtfs_left, hrtfs_right, f, conf)

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


%% ===== Checking of input  parameters ==================================
nargmin = 6;
nargmax = 7;
narginchk(nargmin,nargmax);
isargmatrix(wL, wR, d0, hrtfs_left, hrtfs_right);
isargvector(f);
if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end

%% ===== Variables ======================================================
Nf = size(hrtfs_left, 1);
N0 = size(hrtfs_left, 2);

%% ===== Computation ====================================================
hrtfL = zeros(Nf, N0);
hrtfR = zeros(Nf, N0);

parfor kdx=1:N0
  if all(wL(kdx, :) == 0)
    continue;
  end

  hL = exp(-1j*2*pi*f*d0(kdx, :)) * wL(kdx, :).';
  hR = exp(-1j*2*pi*f*d0(kdx, :)) * wR(kdx, :).';
  hrtfL(:,kdx) = hL .* hrtfs_left(:,kdx);
  hrtfR(:,kdx) = hR .* hrtfs_right(:,kdx);
end

pre = localwfs_prefilter(f, conf);
hrtf.left = sum(hrtfL,2) .* pre;
hrtf.right = sum(hrtfR,2) .* pre;

end
