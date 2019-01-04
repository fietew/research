% General Parameters for Acoustics'17 Presentation

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

%% default parameters

% === existing in SFS toolbox ===
conf.c = 343;  % speed of sound
conf.dimension = '2.5D';
conf.fs = 44100;
conf.debug = false;
conf.tmpdir = '/tmp/sfs';
conf.showprogress = false;
% plotting settings
tmp = SFS_config;
conf.plot = tmp.plot;
conf.plot.useplot = false;
conf.plot.loudspeakers = true;
conf.plot.realloudspeakers = false;
conf.plot.usedb = true;
% secondary source distribution
conf.secondary_sources.x0 = [];  % disable custom array
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 3000;
% time-domain sound fields
conf.resolution = 300;
conf.usebandpass = true;
conf.bandpassflow = 10;
conf.bandpassfhigh = 20000;
conf.N = 8192;
conf.t0 = 'source';
% modal windowing
conf.modal_window = '';  % modal window
conf.modal_window_parameter = NaN;
% WFS
conf.xref = [0,0,0];
conf.usetapwin = false;
conf.tapwinlen = 0.0;
conf.wfs.usehpre = true;
conf.wfs.hpretype = 'FIR';
conf.wfs.hpreflow = 50;
conf.wfs.hprefhigh = 1200;
conf.wfs.hpreFIRorder = 128;
% NFC-HOA
conf.driving_functions = 'default';
conf.nfchoa.order = NaN;
% LWFS using Spatial Bandwidth-Limitation
conf.localsfs.sbl.order = 27;
conf.localsfs.sbl.fc = 1200;  % cross-over frequency
conf.localsfs.sbl.Npw = 1024;
conf.localsfs.wfs = conf.wfs;
conf.localsfs.wfs.hprefhigh = 20000;
% binaural synthesis
conf.ir.hrirpredelay = 0;
conf.ir.useinterpolation = true;
conf.ir.interpolationpointselection = 'delaunay';
conf.ir.interpolationmethod = 'simple';
conf.ir.usehcomp = false;
% fractional delay
conf.delayline.filter = 'lagrange';
conf.delayline.filterorder = 9;
conf.delayline.filternumber = NaN;
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 2;
conf.delayline.resamplingorder = 64;

% === custom ===
conf.src = '';
conf.xs = [0, -1, 0];  % propagation of plane wave
conf.pos = NaN;  % listener position
conf.phi_N = 1;  % number of brirs on full circle
conf.method = 'nfchoa';
conf.hrirs = SOFAload('QU_KEMAR_anechoic_3m.sofa');
conf.outputdir = './';  % outputdir
conf.useplot = true;
conf.X = [-1.5, 1.5];
conf.Y = [-1.5, 1.5];
conf.Z = 0;
conf.Mmax = 14;  % maximum order of modal window for gnuplot
