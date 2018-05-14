SFS_start;
SOFAstart;

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
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;
conf.plot.usedb = false;
conf.usebandpass = false; % boolean
conf.bandpassflow = 10; % / Hz
conf.bandpassfhigh = 20000; % / Hz
conf.resolution = 300;
conf.phase = 0;
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
conf.dimension = '2.5D';
conf.driving_functions = 'default';
conf.xref = [0, 0, 0];
conf.fs = 44100;  
conf.c = 343;  % speed of sound
conf.t0 = 'source';
conf.usetapwin = false;
conf.tapwinlen = 0;
% modal window
conf.modal_window = 'rect';
% WFS
conf.wfs.usehpre = true;
conf.wfs.hpretype = 'FIR';
conf.wfs.hpreFIRorder = 128;
conf.wfs.hpreflow = 10;
conf.wfs.hprefhigh = 1600;
% NFC-HOA
conf.nfchoa.order = []; % bandlimited NFC-HOA
% LWFS using Spatial Bandwidth-Limitation
conf.localwfs_sbl.order = [];
conf.localwfs_sbl.fc = 1200;  % cross-over frequency
conf.localwfs_sbl.Npw = NaN;
% custom parameters
conf.method = '';
conf.xs = [0, 2.5, 0];
conf.src = 'ps';
conf.pos = NaN;
conf.pos_shift = [-0.085, 0, 0];
conf.phi_N = 1;
conf.useplot = true;
conf.f = 1000;
conf.datafile = 'data.txt';  % gnuplot file for sound field spectra
