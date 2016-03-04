%

%*****************************************************************************
% Copyright (c) 2016      Fiete Winter                                       *
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
conf.dimension = '2.5D';
conf.showprogress = false;
conf.plot.useplot = false;
conf.resolution = 300;
conf.usenormalisation = false;

conf.c = 343;  % speed of sound
conf.phase = 0;

%% config for real array
conf.secondary_sources.x0 = [];
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 60;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';

%% config for virtual source
conf.azimuth = pi/2;
conf.distance = 3;
conf.source_type = 'pw';

%% config for evaluation
conf.xref = [0, 0, 0];
conf.xt = [0, 1.0, 0];
conf.frequency = 25:25:3000;
conf.Mprime = 40; % maximum order of sound field expansion
conf.M = 83; % maximum order of driving functions 
conf.Nse = conf.M; % maximum order of spherical re-expansion
%% translation vector
phit = [0, 0, 0, 0, 45, 90];
rt = [0.25, 0.75, 0.75, 0.75, 0.75, 0.75];
xt = [rt(:).*cosd(phit(:)), rt(:).*sind(phit(:)), zeros(numel(rt),1)];

%% ===== Regular Spherical Re-Expansion Coefficients ===========================
% parameters which should be varied for the evaluation
param_names = { 'xt', 'frequency'};
% generate disired combinations of parameter values
f = conf.frequency;
param_values = allcombs( mat2cell(xt,ones(size(xt,1),1),size(xt,2))', ...
  mat2cell(f, size(f,1), ones(size(f,2),1)) ...
  );
% compute (this may take a while)
% using the parallel option, i.e. exhaustive_evaluation(... , true), this might
% exceed your RAM
exhaustive_evaluation(@nfchoa_translation, param_names, param_values, conf, ...
  false);

%% ===== Modal Spectra of Driving Function =====================================
% parameters which should be varied for the evaluation
param_names = { 'xt', 'Mprime'};
% generate disired combinations of parameter values
Mprime = {27, 27, 18, 9, 27, 27}';
param_values = [mat2cell(xt,ones(size(xt,1),1),size(xt,2)), Mprime];
% compute
exhaustive_evaluation(@nfchoa_spectra, param_names, param_values, conf, true);
