% HRTF extrapolation from 1m to 3m WITH and WITHOUT ear amplitude correction

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

clear all;

SFS_start;  % start Sound Field Synthesis Toolbox
addpath('../../matlab');

%% general settings
conf = SFS_config_example;

conf.dimension = '2.5D';
conf.N = 2^12;  % length of impulse responses

conf.ir.useinterpolation = false;  % do not interpolate HRIR for missing directions
conf.ir.usehcomp = false;  % don't not use headphone compensation filters

%% config for real array
conf.tapwinlen = 1.0;
conf.usetapwin = true; % dont use tapering window

conf.wfs.usehpre = true;
conf.wfs.hpreflow = 500;
conf.wfs.hprefhigh = 20000;

conf.secondary_sources.hrirfile = 'QU_KEMAR_anechoic_1m.mat';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 360;
conf.secondary_sources.size = 2.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';

%% config for virtual array
% wfs settings
conf.localsfs.method = 'wfs';
conf.localsfs.wfs = conf.wfs;
% tapering window
conf.localsfs.tapwinlen = 0.3;
conf.localsfs.usetapwin = true;

conf.localsfs.vss.size = 0.20;
conf.localsfs.vss.center = [0, 0, 0];
conf.localsfs.vss.geometry = 'circular';
conf.localsfs.vss.number = 2000;
conf.localsfs.vss.consider_target_field = true;
conf.localsfs.vss.consider_secondary_sources = false;

%% config for virtual source
conf.azimuth = 0;
conf.distance = 3;
conf.hrirfile = 'QU_KEMAR_anechoic_3m.mat';

%% Reference point for 2.5D WFS
% Algazi, V Ralph and Avendano, Carlos and Duda, Richard O
% 'Elevation localization and head-related transfer function analysis at low frequencies'
conf.xref = [-0.005, 0, -0.03];
conf.ear_xref_shift = [0, sqrt(0.085.^2 - 0.005.^2 - 0.03.^2), 0];
conf.use_ear_correction = true;

%% parameters which should be iterated

% parameters which should be varied for the evaluation
param_names = {'azimuth', ...
  'localsfs.vss.size', ...
  'localsfs.vss.number', ...
  'use_ear_correction'};

%% generate disired combinations of parameter values

% amplitude spectra with varying number of virtual secondary sources
param_values = allcombs( ...
  num2cell(pi/4),  ...
  num2cell([0.1, 0.2, 0.25, 0.3:0.3:1.2, 1.8]), ...
  num2cell(90), ...
  num2cell(false) ...
  );
% amplitude spectra with varying radius
param_values = [param_values; allcombs( ...
  num2cell(pi/4),  ...
  num2cell(0.6), ...
  num2cell([5:5:25,30:30:90]), ...
  num2cell(false) ...
  )];
% mean ild with vayring apparent azimuth +
% comparison between corrected and non-corrected
param_values = [param_values; allcombs( ...
  num2cell(pi*[-1:(1/180):1]),  ...
  num2cell(0.6), ...
  num2cell(90), ...
  num2cell([true, false]) ...
  )];

%%
% extrapolate hrtfs
exhaustive_evaluation(@hrtf_extrapolation, param_names, param_values, conf);
% compute some features of hrtfs and compare it to the ground truth
exhaustive_evaluation(@features_comparison, param_names, param_values, conf);
%
features_merge(['hrtf_phi45.0_Rl*_Nl90_N', num2str(conf.N,'%d'), '_Cfalse.mat']);
features_merge(['hrtf_phi45.0_Rl0.300_Nl*_N', num2str(conf.N,'%d'), '_Cfalse.mat']);
features_merge(['hrtf_phi*_Rl0.300_Nl90_N', num2str(conf.N,'%d'), '_Ctrue.mat']);
features_merge(['hrtf_phi*_Rl0.300_Nl90_N', num2str(conf.N,'%d'), '_Cfalse.mat']);

%% gnuplot stuff

% amplitude spectra with varying number of virtual secondary sources
load(['hrtf_phi45.0_Rl0.300_Nl_N', num2str(conf.N,'%d'), '_Cfalse.mat'], 'tfs');
tfs.left_orig(:,1) = abs(tfs.left_orig(:,1))./abs(tfs.left_orig(10,1));
tfs.left = abs(tfs.left)./repmat(abs(tfs.left(10,:)), size(tfs.left,1),1);
gp_save('fig04-1-1.txt', [tfs.f(:,1), tfs.left_orig(:,1), tfs.left]);
% amplitude spectra with varying radius
load(['hrtf_phi45.0_Rl_Nl90_N', num2str(conf.N,'%d'), '_Cfalse.mat'], 'tfs');
tfs.left_orig(:,1) = abs(tfs.left_orig(:,1))./abs(tfs.left_orig(10,1));
tfs.left = abs(tfs.left)./repmat(abs(tfs.left(10,:)), size(tfs.left,1),1);
gp_save('fig04-1-2.txt', [tfs.f(:,1), tfs.left_orig(:,1), tfs.left]);
% mean ild with vayring apparent azimuth
load(['hrtf_phi_Rl0.300_Nl90_N', num2str(conf.N,'%d'), '_Ctrue.mat'], 'tfs');
ild_orig = sqrt(sum(abs(tfs.left_orig).^2,1)./sum(abs(tfs.right_orig).^2,1));
ild = sqrt(sum(abs(tfs.left).^2,1)./sum(abs(tfs.right).^2,1));
% comparison of corrected and non-corrected
load(['hrtf_phi_Rl0.300_Nl90_N', num2str(conf.N,'%d'), '_Cfalse.mat'], 'tfs');
ild_noncorrected = sqrt(sum(abs(tfs.left).^2,1)./sum(abs(tfs.right).^2,1));
gp_save('fig04-2.txt', [tfs.apparent_azimuth', ild_orig', ild', ild_noncorrected']);
