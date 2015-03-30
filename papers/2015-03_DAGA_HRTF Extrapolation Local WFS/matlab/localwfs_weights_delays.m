function [w0, d0] = localwfs_weights_delays(x0, xv, xs, conf)

%*****************************************************************************
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
nargmin = 3;
nargmax = 4;
narginchk(nargmin,nargmax);
isargsecondarysource(x0, xv);
isargxs(xs);
if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end

%% ===== Configuration ==================================================
N0 = size(x0,1);
Nv = size(xv,1);

%% Weight and Delays for each Loudspeaker

% compute wfs delays and weights for virtual source array (local domain)
xs = repmat(xs,[size(xv,1) 1]);
[dv,wv] = driving_function_imp_wfs_ps(xv(:,1:3),xv(:,4:6),xs,conf);

% compute local wfs delays and weights for loudspeaker array
% initialize delays and weights with values from the local domain
d0 = repmat(dv(:)', N0, 1);
w0 = zeros(N0, Nv);

idx = 1;
for xvi = xv'
  % select active source for one focused source
  [x0s, xdx] = secondary_source_selection(x0,xvi(1:6)','fs');
  if ~isempty(x0s) && xvi(7) > 0
    % focused source position
    xs = repmat(xvi(1:3)',[size(x0s,1) 1]);
    % delay and weights for single focused source
    [dtmp, w0(xdx,idx)] = driving_function_imp_wfs_fs(x0s(:,1:3),x0s(:,4:6),xs,conf);

    % apply weight
    w0(xdx,idx) = w0(xdx,idx).* wv(idx) .* xvi(7);  % weight from local domain
    x0s = secondary_source_tapering(x0s,conf);  % optional tapering
    w0(xdx,idx) = w0(xdx,idx).*x0s(:,7);
    % apply delay
    d0(xdx,idx) = d0(xdx, idx) + dtmp;
  end
  idx = idx + 1;
end
% Remove delay offset, in order to begin always at t=0 with the first wave front
% at any secondary source
if min(d0(:)) < 0
    d0 = d0 - min(d0(:));
end

end
