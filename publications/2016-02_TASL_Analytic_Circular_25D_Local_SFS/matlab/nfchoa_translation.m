function nfchoa_translation(conf)
% compute translation coefficients (regular spherical re-expansion)

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

%% ===== Checking of input  parameters ===================================
nargmin = 0;
nargmax = 1;
narginchk(nargmin,nargmax);
if nargin<nargmax
  conf = SFS_config;
else
  isargstruct(conf);
end

%% ===== Variables =======================================================
xt = conf.xt;
Nse = conf.Nse;

rt = norm(conf.xt);
phit= atan2d(conf.xt(2), conf.xt(1));

f = conf.frequency;

%% ===== Computation =====================================================
% this function does also support a vector for f, but the needed memory might
% exceed the capacities of the RAM
[RR, RRm] = sphexp_mono_translation(xt, 'RR', Nse, f, conf);

save(sprintf('RR_%1.1f_%1.3f_%d_f%.0f.mat', wrapTo180(phit), rt, Nse, f), 'RR');
RR = RRm;
save(sprintf('RR_%1.1f_%1.3f_%d_f%.0f.mat', wrapTo180(phit+180), rt, Nse, f), 'RR');