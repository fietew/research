% compute NFC-HOA driving functions and reproduced sound fields for full-band
% and bandlimited coefficients of desired sound field

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
conf.plot.usenormalisation = false;

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

%% ===== Variables =============================================================
X0 = conf.secondary_sources.center;
r0 = conf.secondary_sources.size/2;
N0 = conf.secondary_sources.number;

src = 'pw';
xs = [0, -1, 0];
phis = atan2d(xs(2),xs(1));

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

%% ===== Computation of full-band driving function =============================
% local regular spherical expansion of sound field at X0
Pnm = sphexp_mono_pw(xs, Nse, f, X0, conf);
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
for idx=-3:3  % range of spectral repetitions
  selector = (1+max(0, idx*N0)):(2*Nse+1 + min(0, idx*N0));  
  Dms(selector, :) =  Dms(selector, :) + Dm(selector - idx*N0, :); 
end

gp_save_matrix('spectrum_D.dat', mu, f.', 20*log(abs(Dm.')));
gp_save_matrix('spectrum_Ds.dat', mu, f.', 20*log(abs(Dms.')));

%% ===== Computation of bandlimited driving function ===========================
% truncate sound field coefficients
Pnm_bandlimit = sphexp_truncate(Pnm, Nse_local);
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
for idx=-3:3  % range of spectral repetitions
  selector = (1+max(0, idx*N0)):(2*Nse+1 + min(0, idx*N0));  
  Dms_bandlimit(selector, :) =  ...
    Dms_bandlimit(selector, :) + Dm_bandlimit(selector - idx*N0, :); 
end

gp_save_matrix('spectrum_D_bandlimit.dat', mu, f.', ...
  20*log(abs(Dm_bandlimit.')));
gp_save_matrix('spectrum_Ds_bandlimit.dat', mu, f.', ...
  20*log(abs(Dms_bandlimit.')));

%% ===== Computation of sound fields ===========================================
kdx = find(f == 3000);  % frequency
x0 = secondary_source_positions(conf);  % secondary sources

% driving function for full-band sound field
D = driving_function_mono_nfchoa_sphexp(x0, Pnm(:,kdx), f(kdx), conf);
% reproduced sound field
P = sound_field_mono(X, Y, Z, x0, 'ps', D, f(kdx), conf);

% driving function for bandlimited sound field
D_bandlimit = driving_function_mono_nfchoa_sphexp(x0, Pnm_bandlimit(:,kdx), ...
  f(kdx), conf);
% reproduced sound field
[P_bandlimit, x, y] = sound_field_mono(X, Y, Z, x0, 'ps', D_bandlimit, ...
  f(kdx), conf);

% rM (radius, where sound field is reconstruction with very low error)
rM = Nse_local/(2*pi*f(kdx)/conf.c);
tmpconf = conf;
tmpconf.secondary_sources.size = 2*rM;
xM = secondary_source_positions(tmpconf);
xM = [xM; xM(1,:)];

% approximation for spectral repetitions
[phial, ~, xsec] = nfchoa_grating_lobes([0,0,0], phis, f(kdx), Nse_local, ...
  [-1,1], conf);

xal = [ ...
  xsec(1) + r0*(-4:0.25:4).'*cosd(phial(1)), ...
  xsec(2) + r0*(-4:0.25:4).'*sind(phial(1)), ...
  xsec(1) + r0*(-4:0.25:4).'*cosd(phial(2)), ...
  xsec(2) + r0*(-4:0.25:4).'*sind(phial(2)) ...  
  ]; 

% gnuplot
gp_save('Xal.txt', xal);
gp_save_loudspeakers('array.txt',x0);
gp_save_matrix('sound_field.dat', x, y, P);
gp_save_matrix('sound_field_bandlimit.dat', x, y, P_bandlimit);
gp_save_loudspeakers('rM.txt', xM);

%% ===== Computation of geometric approximation ================================
MG0 = 2*pi* [0; f(end)] / conf.c*r0;

% gnuplot
gp_save( 'spectrum_G0_limits.txt', ...
  [ [ 0; f(end)], MG0+1, -MG0-1 ] );