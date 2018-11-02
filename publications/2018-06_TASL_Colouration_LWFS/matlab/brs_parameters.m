%% Parameters
% === SFS compatible parameters ===
% misc
conf.debug = false;
conf.showprogress = false;
conf.tmpdir = '/tmp/sfs';
% plotting settings
tmpconf = SFS_config;
conf.plot = tmpconf.plot;
conf.plot.useplot = false;
conf.plot.usenormalisation = false;
conf.plot.normalisation = 'center';
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;
conf.plot.usedb = false;
conf.usebandpass = false; % boolean
conf.bandpassflow = 10; % / Hz
conf.bandpassfhigh = 20000; % / Hz
conf.resolution = 500;
% config for real loudspeaker array
conf.secondary_sources.x0 = [];
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0, 0, 0];
% irs
conf.N = 8192;
conf.ir.useoriglength = false;
conf.ir.useinterpolation = true;
conf.ir.interpolationpointselection = 'delaunay';
conf.ir.interpolationmethod = 'freqdomain';
conf.ir.usehcomp = true;
conf.ir.hcompfile = 'QU_KEMAR_AKGK601_hcomp.wav';
conf.ir.hrirpredelay = 0;
% delayline parameters
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 8;
conf.delayline.resamplingorder = 64;
conf.delayline.filter = 'lagrange';
conf.delayline.filterorder = 9;
% General SFS
conf.phase = 0;
conf.dimension = '2.5D';
conf.driving_functions = 'default';
conf.xref = [0, 0, 0];
conf.fs = 44100;  
conf.c = 343;  % speed of sound
conf.t0 = 'source';
conf.usetapwin = true;
conf.tapwinlen = 0.5;
conf.modal_window = 'rect';
conf.modal_window_parameter = NaN;
% WFS
conf.wfs.usehpre = true;
conf.wfs.hpretype = 'FIR';
conf.wfs.hpreFIRorder = 128;
conf.wfs.hpreflow = 20;
conf.wfs.hprefhigh = 20000;
% NFC-HOA
conf.nfchoa.order = 27; % bandlimited NFC-HOA
% LWFS using Spatial Bandwidth-Limitation
conf.localwfs_sbl.order = [];
conf.localwfs_sbl.fc = 1200;  % cross-over frequency
conf.localwfs_sbl.Npw = [];
% LWFS using Virtual Secondary Sources
conf.localwfs_vss.method = 'wfs';
conf.localwfs_vss.wfs = conf.wfs;
conf.localwfs_vss.usetapwin = true;
conf.localwfs_vss.tapwinlen = 1.0;
conf.localwfs_vss.nfchoa = [];  % not used
conf.localwfs_vss.center = [];  % to be set by algorithm
conf.localwfs_vss.geometry = 'circular';
conf.localwfs_vss.grid = 'equi';
conf.localwfs_vss.consider_target_field = false;
conf.localwfs_vss.consider_secondary_sources = false;
conf.localwfs_vss.number = [];
conf.localwfs_vss.size = [];
conf.localwfs_vss.driving_functions = 'default';  % == 'reference_point'
% custom parameters
conf.method = '';
conf.xs = [0, 2.5, 0];
conf.src = 'ps';
conf.pos = NaN;
conf.pos_shift = [-0.085 0 0];
conf.phi_N = 1;
conf.useplot = true;
conf.f = 2000;
conf.datafile = 'data.txt';