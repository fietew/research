% Script to set parameters for binaural synthesis using pwds

%*****************************************************************************
% Copyright (c) 2014-2015 Fiete Winter                                       *
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

basepath = fileparts(mfilename('fullpath'));

%% initialize
% SFS Toolbox
SFS_start;
% AM Toolbox
ltfatstart;
amtstart;
ltfatsetdefaults('audspecgram','classic');
% some own matlab tools
addpath(fullfile(basepath, 'tools'));

%% SFS toolbox
params.conf = SFS_config_example;
params.conf.N = 1024;
params.conf.fs = 44100;
params.conf.c = 343;
params.conf.dimension = '2.5D';
params.conf.ir.useinterpolation = false;

%% parameters
params.R = 0.5;  % Radius of spherical mic array
params.Nsht = 3;  % order of modal beamformer
params.Npw = 360;  % number of plane waves
params.Nfft = 2.^12;  % number of samples in IR and in full spectrum 
params.beamformer = 'MB';  % beamformer
params.dblimit = -20.0;  % db limitation to ensure numerical stability

params.sampling.mode = 'continuous';    % sphere sampling
params.sampling.pattern = 'lebedev';  % sampling pattern
params.sampling.Npoints = 770;        % number of points on sphere

params.integer_delay = false;  % round delay of invidual plane waves

params.model.name = 'dietz2011';
params.model.altname = 'dietz';

params.source.position = [1.0, 0, 0];
params.source.type     = 'plane';

shift = 1.0*(-params.R:0.1:params.R);
[x, y] = meshgrid(shift);
params.shift = [x(:), y(:), zeros(numel(x),1)];
params.rot = linspace(0,0,1);

params.files.basepath = basepath;
params.files.hrirs = fullfile(basepath, 'hrirs/QU_KEMAR_anechoic_3m.mat');
params.files.lookup = fullfile(basepath, 'model/QU_KEMAR_anechoic_3m_lookup.mat');

%% clear temporary variables
clear x y shift basepath