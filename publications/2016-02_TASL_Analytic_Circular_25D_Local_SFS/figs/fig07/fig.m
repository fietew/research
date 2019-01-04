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
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';

conf.xref = [0, 0, 0];

%% ===== Variables =======================================================
X0 = conf.secondary_sources.center;
r0 = conf.secondary_sources.size/2;
N0 = conf.secondary_sources.number;

src = 'pw';
phis = -90;
xs = [cosd(phis), sind(phis), 0];

phit = -45;
rt = 0.75;
xt = rt*[cosd(phit), sind(phit), 0];

f = 25:25:3000;
Nf = length(f);

Nse = 83;
Nse_local = floor((conf.secondary_sources.number-1)/2);
Lse = (Nse+1)^2;
Lse_local = (Nse_local+1)^2;

mu = -Nse:Nse;

X = [-2, 2];
Y = [-2, 2];
Z = 0;

%% ===== Computation of geometric approximations =========================
dc = rt.*sind(phit - phis);

f1 = conf.c/(2*pi)*Nse_local/(r0 - dc);
f2 = conf.c/(2*pi)*Nse_local/(r0 + dc);

fvec = [f(end); f2; 0; f1; f(end)];

% asymmetric skew for bandlimitation (see Hahn2015-DAGA)
Mminmax = 2.*pi.*fvec./conf.c.*dc + Nse_local*[-1; -1; 0; 1; 1];
gp_save( 'spectrum_limits.txt', [ fvec, Mminmax, Mminmax+N0, Mminmax-N0 ] );

% lowpass characteristic of the Green's function
MG0 = 2*pi* [-f(end); 0; f(end)] / conf.c*r0;
gp_save( 'spectrum_G0_limits.txt', [ [f(end); 0; f(end)], MG0] );

%% ===== Regular Spherical Re-Expansion Coefficients ===========================
conf.xt = xt;
conf.frequency = f;
conf.Nse = Nse;
% parameters which should be varied for the evaluation
param_names = { 'frequency' };
% generate disired combinations of parameter values
param_values = allcombs( mat2cell(f, size(f,1), ones(size(f,2),1)) );
% compute (this may take a while)
% CAUTION: using the parallel option, i.e. exhaustive_evaluation(... , true),
% might exceed your RAM
exhaustive_evaluation(@nfchoa_translation, param_names, param_values, conf, ...
  false);

%% ===== Computation of shifted driving function =========================

% local regular spherical expansion of sound field at X0 + xt
Pnumu = sphexp_mono_pw(xs, Nse_local, f, X0+xt, conf);
% shift spherical expansion back to X0
Pnm = zeros(Lse,Nf);
for idx=1:Nf
  % regular-to-regular spherical reexpansion (translatory shift)
  RR = get_translation(-xt, Nse, f(idx));
  Pnm(:,idx) = RR(1:Lse,1:Lse_local) * Pnumu(:,idx);
end
% spherical harmonics expansion of driving function
Dnm = driving_function_mono_nfchoa_sht_sphexp(Pnm, f, conf);
% circular harmonics expansion of driving function
Dm = zeros(2*Nse+1, Nf);
l = 1;
for m=mu
  v = sphexp_index(m);
  Dm(l, :) = Dnm(v, :);
  l = l+1;
end
% circular harmonics expansion of sampled driving function
Dms = zeros(2*Nse+1, Nf);
for idx=-3:3
  
  selector = (1+max(0, idx*N0)):(2*Nse+1 + min(0, idx*N0));
  
  Dms(selector, :) =  Dms(selector, :) + Dm(selector - idx*N0, :);
end

gp_save_matrix('spectrum_D.dat', mu, f.', 20*log(abs(Dm.')));
gp_save_matrix('spectrum_Ds.dat', mu, f.', 20*log(abs(Dms.')));

%% ===== Computation of spatially windowed driving function =============
% asymmetric skew for bandlimitation (see Hahn2015-DAGA)
Mshift = round( 2*pi*f/conf.c*rt*sind(phit - phis) );
% regular spherical expansion of sound field at X0
Pnm_orig = sphexp_mono_pw(xs, Nse, f, X0, conf);
% compute asymmetrically bandlimited coefficients
Pnm_window = zeros(Lse,Nf);
for idx=1:Nf
  Pnm_window(:,idx) =  sphexp_truncate(Pnm_orig(:,idx), Nse, Nse_local, Mshift(idx));
end
% spherical harmonics expansion of driving function of bandlimited sound field
Dnm_window = driving_function_mono_nfchoa_sht_sphexp(Pnm_window, f, conf);
% circular harmonics expansion of driving function
Dm_window = zeros(2*Nse+1, Nf);
l = 1;
for m=mu
  v = sphexp_index(m);
  Dm_window(l,:) = Dnm_window(v, :);
  l = l+1;
end
% circular harmonics expansion of sampled driving function
Dms_window = zeros(2*Nse+1, Nf); 
for idx=-3:3
  
  selector = (1+max(0, idx*N0)):(2*Nse+1 + min(0, idx*N0));
  
  Dms_window(selector, :) =  ...
    Dms_window(selector, :) + Dm_window(selector - idx*N0, :); 
end

gp_save_matrix('spectrum_D_window.dat', mu, f.', 20*log(abs(Dm_window.')));
gp_save_matrix('spectrum_Ds_window.dat', mu, f.', 20*log(abs(Dms_window.')));

%% ===== Computation of shifted driving function + spatial window ========
% asymmetric skew for bandlimitation (see Hahn2015-DAGA)
Mshift = round( 2*pi*f/conf.c*rt*sind(phit - phis) );
% compute asymmetrically bandlimited coefficients
Pnm_bandlimit = zeros(Lse,Nf);
for idx=1:Nf
  Pnm_bandlimit(:,idx) =  sphexp_truncate(Pnm(:,idx), Nse, Nse_local, Mshift(idx));
end
% spherical harmonics expansion of driving function of bandlimited sound field
Dnm_bandlimit = driving_function_mono_nfchoa_sht_sphexp(Pnm_bandlimit, f, conf);
% circular harmonics expansion of driving function
Dm_bandlimit = zeros(2*Nse+1, Nf);
l = 1;
for m=mu
  v = sphexp_index(m);
  Dm_bandlimit(l,:) = Dnm_bandlimit(v, :);
  l = l+1;
end
% circular harmonics expansion of sampled driving function
Dms_bandlimit = zeros(2*Nse+1, Nf); 
for idx=-3:3
  
  selector = (1+max(0, idx*N0)):(2*Nse+1 + min(0, idx*N0));
  
  Dms_bandlimit(selector, :) =  ...
    Dms_bandlimit(selector, :) + Dm_bandlimit(selector - idx*N0, :); 
end

gp_save_matrix('spectrum_D_bandlimit.dat', mu, f.', 20*log(abs(Dm_bandlimit.')));
gp_save_matrix('spectrum_Ds_bandlimit.dat', mu, f.', 20*log(abs(Dms_bandlimit.')));

%% ===== Computation of sound fields =====================================
kdx = find(f == 3000);  % frequency

% secondary sources
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);

% driving function
D = driving_function_mono_nfchoa_sphexp(x0, Pnm(:,kdx), f(kdx), conf);
% sound field
[P, x, y] = sound_field_mono(X, Y, Z, x0, 'ps', D, f(kdx), conf);
% gnuplot
gp_save_matrix('sound_field.dat', x, y, P);

% driving function
D_window = driving_function_mono_nfchoa_sphexp(x0, Pnm_window(:,kdx), f(kdx), conf);
% sound field
P_window = sound_field_mono(X, Y, Z, x0, 'ps', D_window, f(kdx), conf);
% gnuplot
gp_save_matrix('sound_field_window.dat', x, y, P_window);

% driving function
D_bandlimit = driving_function_mono_nfchoa_sphexp(x0, Pnm_bandlimit(:,kdx), f(kdx), conf);
% sound field
[P_bandlimit, x, y] = sound_field_mono(X, Y, Z, x0, 'ps', D_bandlimit, f(kdx), conf);
% gnuplot
gp_save_matrix('sound_field_bandlimit.dat', x, y, P_bandlimit);

% rM
rM = Nse_local/(2*pi*f(kdx)/conf.c);
tmpconf = conf;
tmpconf.secondary_sources.size = 2*rM;
tmpconf.secondary_sources.center = xt;
xM = secondary_source_positions(tmpconf);
xM = [xM; xM(1,:)];
%
gp_save_loudspeakers('rM.txt', xM);

% propagation direction of virtual plane wave
xpw = [ xt(1) + r0*[-4:0.25:4].'*cosd(phis), ...
  xt(2) + r0*[-4:0.25:4].'*sind(phis) ];
% gnuplot
gp_save('Xpw.txt', xpw);


% approxmation for spectral repetitions
[phial, ral, xsec] = nfchoa_grating_lobes(xt, phis, f(kdx), Nse_local, -1, conf);
nal = [cosd(phial), sind(phial)];
north = [-sind(phial), cosd(phial)];

xal = [];
for idx=1:length(phial)
  gal = bsxfun(@plus, (-1)^idx*r0*[-4:0.25:4].'*nal(idx,:), xsec);
  galmin = bsxfun(@plus, gal, ral(idx)*north(idx,:));
  galmax = bsxfun(@plus, gal, -ral(idx)*north(idx,:));  
  
  xal = [xal; [gal, galmin, galmax]];
end
% gnuplot
gp_save('local.txt', xt);
gp_save('Xal.txt', xal );
