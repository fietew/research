% circular harmonics spectrum of 2D Green's function for two listener positions

%*****************************************************************************
% Copyright (c) 2015      Fiete Winter                                       *
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

numax = 200;  %  maximum order
nuvec = linspace(-numax,numax, 2*numax+1);  % index for angular fourier transform
fvec = linspace(1, 3000, 500);  %  temporal frequency vector

[nu, f] = meshgrid(nuvec, fvec);  % grid

c = 343;  % velocity of sound
k = 2*pi*f/c;

alphapw = deg2rad(90);  % angle of ARRIVAL of virtual plane wave

%% Computation

R0 = 1.5;  % radius of loudspeaker array
r = 0.5;  % radius of evaluation
% spectrum of 2D greens function
G0 = -1j./4 .* besselj(nu, k.*r) .* besselh(nu, 2, k.*R0);
% gnuplot
gp_save_matrix('spectrum_G0_r0.5.dat', ...
  nuvec,fvec,20*log(abs(G0)./max(abs(G0(:)))))

R0 = 1.5;  % radius of loudspeaker array
r = 1.0;  % radius of evaluation
% spectrum of 2D greens function
G0 = -1j./4 .* besselj(nu, k.*r) .* besselh(nu, 2, k.*R0);
% gnuplot
gp_save_matrix('spectrum_G0_r1.0.dat', ...
  nuvec,fvec,20*log(abs(G0)./max(abs(G0(:)))))
