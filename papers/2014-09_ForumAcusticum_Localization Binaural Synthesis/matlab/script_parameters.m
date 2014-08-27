% Script to set parameters for binaural synthesis using pwds
%
%   see also: edit
%
% F.Winter, F.Schultz, S.Spors

basepath = fileparts(mfilename('fullpath'));

%% initialize
% SFS Toolbox
addpath('~/projects/sfstoolbox'); SFS_start;
% SOFiA Toolbox
addpath('~/projects/sofia-toolbox/main/SOFiA');
% AM Toolbox
addpath('~/projects/amtoolbox'); 
addpath('~/projects/ltfat');
ltfatstart;
amtstart;
ltfatsetdefaults('audspecgram','classic');
%
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