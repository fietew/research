% evaluate amplitude and phase error between 2.5D reproduction and ground
% truth sound field along circle modelling the ear positions of a rotating
% listener

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
conf.source_type = 'ps';

%% config for evaluation
conf.xref = [0,0,0];  % reference position for sound field synthesis
conf.xt = [0,0,0];  % position of listeners
conf.rhead = 0.085;  % radius of circle where the sound field is evaluated
conf.alphasteps = 360;  % angular evaluations along the circle
conf.frequency = 600;  % temporal frequency of sound field
conf.Nse = 50; % maximum order of spherical expansion
conf.Nce = conf.Nse;

%% parameters which should be iterated
% parameters which should be varied for the evaluation
param_names = {'source_type', 'xref', 'xt', 'frequency'};

%% generate disired combinations of parameter values
rref = 0.75;

param_values = allcombs( ...
  {'pw'}, ...
  {[0,0,0],[rref,0,0]}, ...
  {[rref, 0, 0], [0, rref, 0]}, ...
  {100, 200, 1000, 2000} ...
  );

%%
% compute sound pressure on some concentric circles 
exhaustive_evaluation(@nfchoa_circle, param_names, param_values, conf);
% compute mean amplitude and phase devitations
exhaustive_evaluation(@eval_statistics, param_names, param_values, conf);
