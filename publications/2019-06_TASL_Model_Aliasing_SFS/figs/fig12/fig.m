%

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

addpath('../../matlab');
SFS_start;
SOFAstart;

conf = SFS_config;

conf.plot.usenormalisation = true;
conf.plot.normalisation = 'center';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;
conf.xref = [0,0,0];

% config for wave field synthesis
conf.usetapwin = false;
conf.wfs.usehpre = false;
% irs
conf.t0 = 'source';
conf.N = 8192;
conf.ir.useoriglength = false;
conf.ir.useinterpolation = true;
conf.ir.interpolationpointselection = 'nearestneighbour';
conf.ir.interpolationmethod = 'freqdomain';
conf.ir.usehcomp = false;
% delayline parameters
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 8;
conf.delayline.resamplingorder = 64;
conf.delayline.filter = 'lagrange';
conf.delayline.filterorder = 9;

Lref = 2048;
L = 56;
R = conf.secondary_sources.size/2;
xs = [0 2.5 0];
src = 'ps';
xref = conf.xref;

x = -1.0:0.5:0;
y = -0.75:0.75:0.75;
[y,x] = meshgrid(y,x);
x = x(:);
x = [x; 0];
y = y(:);
y = [y; 1.25];

%% Aliasing Frequency
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);  % a_S(x0) >= 0
x0(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0
kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);

% evaluation points x
xvec = [x(:), y(:)];
xvec(:,3) = 0;

% aliasing frequency at x
fS = aliasing(x0,kSx0,xvec,conf);
fS = reshape(fS, size(x));

% gnuplot
gp_save('fS.txt', [x,y,fS]);

%% Time-Domain Driving Function
% 
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);  % gnuplot
x0 = secondary_source_selection(x0,xs,src);
d = driving_function_imp_wfs(x0,xs,src,conf);

% ground truth driving signals
conf.secondary_sources.number = Lref;
x0gt = secondary_source_positions(conf);
x0gt = secondary_source_selection(x0gt,xs,src);
dgt = driving_function_imp_wfs(x0gt,xs,src,conf); 

%% Binaural Simulation
hrir = dummy_irs(2^11, conf);

P = zeros(conf.N/2+1, size(xvec,1));
Pgt = P;
for xdx = 1:size(xvec,1)
  
  p = ir_generic(xvec(xdx,:), 0, x0, d, hrir, conf);
  pgt = ir_generic(xvec(xdx,:), 0, x0gt, dgt, hrir, conf);

  % spectrum of synthesised sound field
  [Pamp, Pphase, f] = spectrum_from_signal(p(:,1), conf);
  P(:,xdx) = Pamp.*exp(1j*Pphase);
 
  % spectrum of sound field
  [Pampgt, Pphasegt] = spectrum_from_signal(pgt(:,1), conf);
  Pgt(:,xdx) = Pampgt.*exp(1j*Pphasegt);
  
  % 
end
  
% error
eps = db((P-Pgt)./Pgt);

% error near aliasing frequency
[~, fdx] = min(abs(bsxfun(@minus, fS, f.')),[],2);
epsmin = zeros(size(fdx));
for idx = 1:length(fdx)
    epsmin(idx) = eps(fdx(idx),idx);
end

% gnuplot
gp_save('P.txt', [f, db(P)]);
gp_save('Pgt.txt', [f, db(Pgt)]);
gp_save('eps.txt', [f, eps]);
gp_save('eps_fS.txt', [fS, epsmin]);

