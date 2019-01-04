% circular harmonics spectrum of a sampled local WFS driving function and
% spectrum of a virtual focused source

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
addpath('../../matlab');
SFS_start;

%% Parameters
Rl = 0.5;  % radius of virtual secondary sources
R0 = 1.5;  % radius of loudspeaker array
r = 0.5;  % radius of evaluation

Nl = 50;  % number of virtual secondary sources

numax = 200;  %  maximum order
nuvec = linspace(-numax,numax, 2*numax+1);  % index for angular fourier transform
fvec = linspace(1, 3000, 500);  %  temporal frequency vector

[nu, f] = meshgrid(nuvec, fvec);  % grid

c = 343;  % velocity of sound
k = 2*pi*f/c;

alphapw = deg2rad(90);  % angle of ARRIVAL of virtual plane wave

%% sampled local domain of localWFS
% series of secondary source selection criterion for virtual plane wave
al = 1./(2*pi).*winF_rect(nuvec, pi).*exp(-1j*nuvec*alphapw);

% Dl^s = 2 * (Sl conv al conv diraccomb) = 2*( al conv (Sl conv diraccomb))
Sl = zeros(size(nu));
for idx=-3:3
  nutemp = nu - idx*Nl;
  nuvectemp = nuvec - idx*Nl;

  % series of driving function for virtual plane wave without secondary
  % source selection criterion
  Jprime = 1./2 .* (besselj(nutemp-1, k.*Rl) - besselj(nutemp+1, k.*Rl));
  Sl = Sl + -2 .* k .* Jprime .* 1j.^(-nutemp) .* exp(-1j.*nutemp.*alphapw);
end

Dlsampled = 2*conv2(Sl, al, 'same');

%% driving function of focussed sources

% series of secondary source selection criterion for focused source
alphafs = 2*acos(Rl./R0);
afs = 1./(2*pi).*winF_rect(nuvec, alphafs);
% derivative of cylindrical hankel function
Hprime = 1/2 .* (besselh(nu-1, 1, k.*R0) - besselh(nu+1, 1, k.*R0));
% spectrum of driving function for virtual focused source without secondary
% source selection criterion
Sfs = -1j.* k./4 .* Hprime .* besselj(nu, k.*Rl);
% spectrum of continous driving function for virtual focused source
Dfs = 2*conv2(Sfs, afs, 'same');

%% Gnuplot
gp_save_matrix('spectrum_Dlsampled.dat', ...
  nuvec,fvec,20*log(abs(Dlsampled)./max(abs(Dlsampled(:)))));
gp_save_matrix('spectrum_Dfs.dat', ...
  nuvec,fvec,20*log(abs(Dfs)./max(abs(Dfs(:)))));
