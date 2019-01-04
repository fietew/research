function hrtf_extrapolation(conf)

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

%% ===== Checking of input  parameters ===================================
nargmin = 0;
nargmax = 1;
narginchk(nargmin,nargmax);
if nargin<nargmax
  conf = SFS_config;
else
  isargstruct(conf);
end

%% ===== Configuration ===================================================
if ~conf.use_ear_correction
  conf.xref = [0, 0, 0];
  conf.ear_xref_shift = [0, 0, 0];
end

virtualconf = conf;
virtualconf.secondary_sources.size     = conf.localsfs.vss.size;
virtualconf.secondary_sources.center   = conf.localsfs.vss.center;
virtualconf.secondary_sources.geometry = conf.localsfs.vss.geometry;
virtualconf.secondary_sources.number   = conf.localsfs.vss.number;
virtualconf.secondary_sources.grid     = conf.localsfs.vss.grid;

%% ===== Variables =======================================================
xs = conf.distance*[cos(conf.azimuth), sin(conf.azimuth), 0];
src = 'ps';

%% ===== Computation =====================================================
irs = read_irs(conf.secondary_sources.hrirfile, conf);
tfs_orig = hrirs2hrtfs(irs, conf);

% create loudspeaker array
[x0(:,1), x0(:,2), x0(:,3)] = sph2cart(tfs_orig.apparent_azimuth', ...
  tfs_orig.apparent_elevation', 1);
x0(:,1:3) = tfs_orig.distance*x0(:,1:3);
x0(:,4:6) = direction_vector(x0(:,1:3), ...
  repmat(conf.secondary_sources.center, size(x0,1), 1));
x0(:,7) = 1;

% create virtual source array
%xv = secondary_source_positions(virtualconf);
%xv = secondary_source_selection(xv, xs, src);
xv = virtual_secondary_source_positions(x0, xs, src, conf);

% delay and weights for each pair of x0 and xv
[w0, d0] = localwfs_weights_delays(x0, xv, xs, conf);
% correct wrong amplitude at both ears caused by 2.5D
[wL, wR] = localwfs_ears_correction(w0, x0, xv, conf);

tfs = localwfs_hrtfs(wL, wR, d0, tfs_orig.left, tfs_orig.right, ...
    tfs_orig.f, conf);

% metadata
tfs.f = tfs_orig.f;
tfs.apparent_azimuth = conf.azimuth;
tfs.apparent_elevation = 0;
tfs.distance = conf.distance;
tfs.fs = tfs_orig.fs;
tfs.source_position = xs';
tfs.source_reference = conf.xref';
tfs.head_azimuth = NaN;
tfs.head_elevation = NaN;
tfs.torso_elevation = NaN;
tfs.torso_azimuth = NaN;

save(evalGenerateFilename(conf), 'tfs', 'conf');
