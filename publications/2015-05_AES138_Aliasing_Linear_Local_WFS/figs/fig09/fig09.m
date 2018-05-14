% kx spectra of truncated driving functions for local wave field synthesis

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

clear all;
close all;

addpath('../../matlab');

c = 343;  % velocity of sound

kxvec = linspace(-100,100, 500);  % spatial frequency vector in x direction
fvec = linspace(0, 2000, 500);  %  temporal frequency vector
[kx, f] = meshgrid(kxvec, fvec);  % grid of both frequencies

ky = kyroot(2*pi*f/c,kx, 'evanescent');  % spatial frequency in y-direction

% local domain 
xl = 2.0;
yl = 1.0; % position of virtual secondary sources
Ll = 2.0;
wl = winF_rect(kxvec,Ll).*exp(1j*kxvec*xl); % truncation window

% NOTE: The shift theorem of the fourier transform dependence on the
% definition of the fourier transform. 
% For the temporal fourier transform:
% f(t-t0) <---> F(f) e^(-j*2*pi*f*t0)
% For the spatial fourier transform:
% f(x-x0) <---> F(kx) e^(j*kx*x0)

% loudspeaker domain
x0 = 0;
y0 = 0;  % position of loudspeaker array
L0 = 3.0;
w0 = winF_rect(kxvec,L0).*exp(1j*kxvec*x0); % truncation window

% virtual source
xs = -1.0;
ys = -3.0;
Dl = exp(1j.*kx.*xs + ky.*(ys - yl));  % spectrum of driving function for local domain
Dltr = conv2(Dl, wl, 'same');  % truncation

% spectrum of driving function for one focused source
Dfs = conj(exp(ky.*(y0 - yl)));

% spectrum of driving function for the loudspeaker domain
D0 = Dfs.*Dl;
D0tr_ = Dfs.*Dltr;
D0_tr = conv2(D0, w0, 'same');  % truncation
D0trtr = conv2(D0tr_, w0, 'same');  % truncation

% geometric approximations
alpha01 = atan2(y0 - ys, x0 + L0 / 2 - xs);
alpha02 = atan2(y0 - ys, x0 - L0 / 2 - xs);

alphal1 = atan2(yl - ys, xl + Ll / 2 - xs);
alphal2 = atan2(yl - ys, xl - Ll / 2 - xs);

ml1 = 2*pi/c*cos(alphal1);
ml2 = 2*pi/c*cos(alphal2);

m01 = 2*pi/c*cos(alpha01);
m02 = 2*pi/c*cos(alpha02);

m1 = 2*pi/c*cos(max(alpha01, alphal1));
m2 = 2*pi/c*cos(min(alpha02, alphal2));

%% plotting
dbmin = -100;
dbmax = 0;

line_vector = fvec([1, end]);

h1 = figure;
imagesc(kxvec, fvec, 20*log(abs(Dltr)./max(abs(Dltr(:)))));
caxis([dbmin dbmax]);
xlim([-40, 40]);
set(gca, 'XTick', [-40, 40]);
set(gca, 'YTick', [0, 500, 1000, 1500, 2000]);
title('$\tilde D^{\mathrm{tr}}_\localindex(\kx, \omega)$');
xlabel('$\kx / \frac{\mathrm{rad}}{m}$');
ylabel('$f / \mathrm{Hz}$');
line(line_vector*ml1, line_vector, 'Color', [0 0 0], 'LineWidth', 1.5);
line(line_vector*ml2, line_vector, 'Color', [0 0 0], 'LineWidth', 1.5);
axis xy;

h2 = figure;
imagesc(kxvec, fvec, 20*log(abs(D0_tr)./max(abs(D0_tr(:)))));
caxis([dbmin dbmax]);
xlim([-40, 40]);
set(gca, 'YTickLabels', {});
set(gca, 'XTick', [-40, 40]);
set(gca, 'YTick', [0, 500, 1000, 1500, 2000]);
title('$\tilde D^{\mathrm{tr}}_\lsindex(\kx, \omega)$');
xlabel('$\kx / \frac{\mathrm{rad}}{m}$');
axis xy;

line(line_vector*m01,line_vector, 'Color', [0 0 0], 'LineWidth', 1.5);
line(line_vector*m02,line_vector, 'Color', [0 0 0], 'LineWidth', 1.5);

h3 = figure;
imagesc(kxvec, fvec, 20*log(abs(D0trtr)./max(abs(D0trtr(:)))));
caxis([dbmin dbmax]);
xlim([-40, 40]);
title('$\tilde D^{\mathrm{tr}}_\lsindex(\kx, \omega)$');
set(gca, 'YTickLabels', {});
set(gca, 'YTick', [0, 500, 1000, 1500, 2000]);
set(gca, 'XTick', [-40, 40]);
xlabel('$\kx / \frac{\mathrm{rad}}{m}$');
axis xy;
hcb = colorbar;
xlabel(hcb, '[dB]');

line(line_vector*m1,line_vector, 'Color', [0 0 0], 'LineWidth', 1.5);
line(line_vector*m2,line_vector, 'Color', [0 0 0], 'LineWidth', 1.5);

%% MATLAB2TIKZ

matlab2tikz( 'fig09-1.tex', ...
  'figurehandle', h1, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false);

matlab2tikz( 'fig09-2.tex', ...
  'figurehandle', h2, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false);

matlab2tikz( 'fig09-3.tex', ...
  'figurehandle', h3, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false);
