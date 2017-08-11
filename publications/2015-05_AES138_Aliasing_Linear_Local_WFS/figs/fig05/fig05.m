% kx spectra of driving functions and greens functions

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
close all;

addpath('../../matlab');

c = 343;  % velocity of sound
y0 = 0;  % position of loudspeaker array

kxvec = linspace(-100,100, 500);  % spatial frequency vector in x direction
fvec =linspace(0, 2000, 500);  % temporal frequency vector
[kx, f] = meshgrid(kxvec, fvec);  % grid of both frequencies

ky = kyroot(2*pi*f/c,kx, 'evanescent');  % spatial frequency in y-direction

% spectrum of greens function
y = 2;
G = 0.5*exp(-ky.*y).*(-ky);

% spectrum of driving function for one focused source
yl = 1;
Dfs = exp(-ky.*(yl - y0));

% spectrum of driving function for virtual point source
xs = 0;
ys = -1;
Ds = exp(1j.*kx.*xs - ky.*(yl - ys));

%% plotting
dbmin = -200;
dbmax = 0;

h1 = figure;
imagesc(kxvec, fvec, 20*log(abs(Ds)./max(abs(Ds(:)))));
caxis([dbmin dbmax]);
xlim([-40, 40]);
set(gca, 'XTick', [-40, 40]);
set(gca, 'YTick', [0, 500, 1000, 1500, 2000]);
xlabel('$\kx / \frac{\mathrm{rad}}{m}$');
ylabel('$f / \mathrm{Hz}$');
axis xy;

h2 = figure;
imagesc(kxvec, fvec, 20*log(abs(Dfs)./max(abs(Dfs(:)))));
caxis([dbmin dbmax]);
xlim([-40, 40]);
set(gca, 'YTickLabels', {});
set(gca, 'YTick', [0, 500, 1000, 1500, 2000]);
set(gca, 'XTick', [-40, 40]);
xlabel('$\kx / \frac{\mathrm{rad}}{m}$');
axis xy;

h3 = figure;
imagesc(kxvec, fvec, 20*log(abs(G)./max(abs(G(:)))));
caxis([dbmin dbmax]);
xlim([-40, 40]);
set(gca, 'YTickLabels', {});
set(gca, 'YTick', [0, 500, 1000, 1500, 2000]);
set(gca, 'XTick', [-40, 40]);
xlabel('$\kx / \frac{\mathrm{rad}}{m}$');
axis xy;
hcb = colorbar;
xlabel(hcb, '[dB]');

%% MATLAB2TIKZ

matlab2tikz( 'fig05-1.tex', ...
  'figurehandle', h1, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false);

matlab2tikz( 'fig05-2.tex', ...
  'figurehandle', h2, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false);

matlab2tikz( 'fig05-3.tex', ...
  'figurehandle', h3, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
  'parseStrings', false);