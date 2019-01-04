function nfchoa_spectra(conf)
% compute circular harmonics spectra of driving functions for nfc-hoa
% with movable sweetspot. First, you need to compute the spherical
% translation coefficients using nfchoa_translation with the same
% parameters
%
% See also: nfchoa_translation

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

%% ===== Checking of input  parameters ===================================
nargmin = 0;
nargmax = 1;
narginchk(nargmin,nargmax);
if nargin<nargmax
  conf = SFS_config;
else
  isargstruct(conf);
end

%% ===== Variables =======================================================
src = conf.source_type;

X0 = conf.secondary_sources.center;

xt = conf.xt;
phit = atan2d(xt(2),xt(1));
rt = norm(xt);

f = conf.frequency(:);
Nf = length(f);

Mprime = conf.Mprime;  % maximum order of sound field expansion
M = conf.M;  % maximum order of driving functions
m = -M:M;

Lprime = (Mprime+1)^2;
L = (M+1)^2;

%% ===== Computation of shifted driving function =========================
% spherical expansion
switch src
  case 'ps'
    xs = conf.distance*[cos(conf.azimuth), sin(conf.azimuth), 0];
    Pnumu = sphexp_mono_ps(xs, 'R', Mprime, f, X0 + xt, conf);
  case 'pw'
    xs = -[cos(conf.azimuth), sin(conf.azimuth), 0];
    Pnumu = sphexp_mono_pw(xs, Mprime, f, X0 + xt, conf);
  otherwise
    error('%s: unknown source type',upper(mfilename));
end

Pnm = zeros(L,Nf);
if norm(xt) > 0  
  % translatory shift of expansion (spherical re-expansion)
  for idx=1:Nf
    % regular-to-regular spherical reexpansion (translatory shift)
    RR = get_translation(-xt, M, f(idx));
    Pnm(:,idx) = RR(1:L,1:Lprime)*Pnumu(:,idx);
  end
else
  Pnm(1:Lprime,:) = Pnumu;
end

% spherical harmonics expansion of driving function
Dnm = driving_function_mono_nfchoa_sht_sphexp(Pnm, f, conf);

% circular harmonics expansion of driving function
Dm = zeros(2*M+1, Nf);
l = 1;
for mu=m
  v = sphexp_index(mu);
  Dm(l, :) = Dnm(v,:);
  l = l+1;
end

% gnuplot
suffix = sprintf('Mprime%d_phit%1.1f_rt%1.3f', Mprime, phit, rt);
gp_save_matrix(['spectrum_D_' suffix '.dat'], m, f, 20*log(abs(Dm.')));

%% ===== Computation of geometric approximation ==========================
% asymmetric skew for bandlimitation (see Hahn2015-DAGA)
Mshift = round( 2*pi* [ 0; f(end)] / conf.c*rt*sin(conf.azimuth - phit) );
% spectrum of Green's function
MG0 = 2*pi* [0; f(end)] / conf.c*r0;

% gnuplot
gp_save( ['spectrum_limits_' suffix '.txt'], ...
  [ [ 0; f(end)], Mshift+Mprime+1, Mshift-Mprime-1 ] );
gp_save( 'spectrum_G0_limits.txt', [ [ 0; f(end)], MG0+1, -MG0-1 ] );
