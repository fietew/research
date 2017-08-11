% comparison of different circular harmonics spectra

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

alphapw = deg2rad(90);  % angle of ARRIVAL of virtual plane wave

Rl = 0.5;  % radius of virtual secondary sources
R0 = 1.5;  % radius of loudspeaker array
r = 0.5;  % radius of evaluation

Nl = 50;  % number of virtual secondary sources
N0 = 40;  % number of loudspeakers

numax = 200;  % maximum order
nuvec = linspace(-numax,numax, 2*numax+1);  % index for angular fourier transform direction
fvec = linspace(1, 3000, 500);  %  temporal frequency vector
[nu, f] = meshgrid(nuvec, fvec);  % grid

c = 343;  % velocity of sound
k = 2*pi*f/c;

%% local domain of localWFS
% series of driving function for virtual plane wave without secondary
% source selection criterion
Jprime = 1./2 .* (besselj(nu-1, k.*Rl) - besselj(nu+1, k.*Rl));
Sl = -2 .* k .* Jprime .* 1j.^(-nu) .* exp(-1j.*nu.*alphapw);
% series of secondary source selection criterion for virtual plane wave
al = 1./(2*pi).*winF_rect(nuvec, pi).*exp(-1j*nuvec*alphapw);

Dl = 2*conv2(Sl, al, 'same');

%% sampled local domain of localWFS

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

% series of driving function for a focused source without secondary
% source selection criterion
Hprime = 1/2 .* (besselh(nu-1, 1, k.*R0) - besselh(nu+1, 1, k.*R0));
Sfs = -1j.* k./4 .* Hprime .* besselj(nu, k.*Rl);
% series of secondary source selection criterion for focused source
alphafs = 2*acos(Rl./R0);
afs = 1./(2*pi).*winF_rect(nuvec, alphafs);

Dfs = 2*conv2(Sfs, afs, 'same');

%% loudspeaker domain of localWFS

D0 = 2*pi*Rl*Dl.*Dfs;

D0int = 2*pi*Rl*Dlsampled.*Dfs;

%% sampled loudspeaker domain of localWFS

D0sampled = zeros(size(nu));
for idx=-3:3

  selector = (1+max(0, idx*N0)):(2*numax+1 + min(0, idx*N0));

  D0sampled(:, selector) =  ...
    D0sampled(:, selector) + D0int(:,selector - idx*N0);
end

%% loudspeaker domain of WFS

% series of driving function for virtual plane wave without secondary
% source selection criterion
Jprime = 1./2 .* (besselj(nu-1, k.*R0) - besselj(nu+1, k.*R0));
Swfs = -2 .* k .* Jprime .* 1j.^(-nu) .* exp(-1j.*nu.*alphapw);
% series of secondary source selection criterion for virtual plane wave
awfs = al;

Dwfs = 2*conv2(Swfs, awfs, 'same');

%% sampled loudspeaker domain of WFS

Swfs = zeros(size(nu));
for idx=-3:3
  nutemp = nu - idx*N0;
  nuvectemp = nuvec - idx*N0;

  % series of driving function for virtual plane wave without secondary
  % source selection criterion
  Jprime = 1./2 .* (besselj(nutemp-1, k.*R0) - besselj(nutemp+1, k.*R0));
  Swfs = Swfs + -2 .* k .* Jprime .* 1j.^(-nutemp) .* exp(-1j.*nutemp.*alphapw);
end

Dwfssampled = 2*conv2(Swfs, awfs, 'same');

%% Reproduced sound field

% series of secondary line source
G = -1j./4 .* besselj(nu, k.*r) .* besselh(nu, 2, k.*R0);

P = 2*pi*R0*G.*D0;

%% Number of Degrees of Freedom (Kennedy 2007)

epsilon = 1e-5;
delta = ceil(-0.5*log(epsilon./0.0093));
freq_kennedy_Rl = (abs(nuvec) - delta)./(exp(1)*pi*Rl/c);
freq_kennedy_R0 = (abs(nuvec) - delta)./(exp(1)*pi*R0/c);

%% plotting
dbmin = -100;
dbmax = 0;

yticks = 0:500:3000;
xlimits = [-55,55];
xticks = [-40, 0, 40];
xtext = ('$\cylnu$');
ytext = ('$f / \mathrm{Hz}$');

h(1) = figure;
imagesc(nuvec, fvec, 20*log(abs(Dl)./max(abs(Dl(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
xlabel(xtext);
ylabel(ytext);
axis xy;

h(2) = figure;
imagesc(nuvec, fvec, 20*log(abs(Dfs)./max(abs(Dfs(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabels', {});
xlabel(xtext);
axis xy;

h(3) = figure;
imagesc(nuvec, fvec, 20*log(abs(D0)./max(abs(D0(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabels', {});
xlabel(xtext);
axis xy;
hcb = colorbar;
xlabel(hcb, '[dB]');
hold on;
plot(nuvec, freq_kennedy_Rl, 'Color', [1 1 1], 'LineWidth', 1.5);
hold off;

%%%%

h(4) = figure;
imagesc(nuvec, fvec, 20*log(abs(G)./max(abs(G(:)))));
caxis([-100 0]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
xlabel(xtext);
ylabel(ytext);
axis xy;
hcb = colorbar;
xlabel(hcb, '[dB]');

h(5) = figure;
imagesc(nuvec, fvec, 20*log(abs(Dwfs)./max(abs(Dwfs(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
xlabel(xtext);
axis xy;
hcb = colorbar;
xlabel(hcb, '[dB]');
hold on;
plot(nuvec, freq_kennedy_R0, 'Color', [1 1 1], 'LineWidth', 1.5);
hold off;

%%%%%

h(6) = figure;
imagesc(nuvec, fvec, 20*log(abs(Dlsampled)./max(abs(Dlsampled(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
xlabel(xtext);
ylabel(ytext);
axis xy;

h(7) = figure;
imagesc(nuvec, fvec, 20*log(abs(D0sampled)./max(abs(D0sampled(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabels', {});
xlabel(xtext);
axis xy;

h(8) = figure;
imagesc(nuvec, fvec, 20*log(abs(Dwfssampled)./max(abs(Dwfssampled(:)))));
caxis([dbmin dbmax]);
xlim(xlimits);
set(gca, 'XTick', xticks);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabels', {});
xlabel(xtext);
axis xy;
hcb = colorbar;
xlabel(hcb, '[dB]');

%% save pgfplot
for idx=1:8
  matlab2tikz( ['fig05-', num2str(idx), '.tex'], ...
    'figurehandle', h(idx), ...
    'height', '\fheight', ...
    'width', '\fwidth', ...
    'extraTikzpictureOptions', 'every axis label/.style={font=\small}, every tick label/.style={font=\footnotesize},', ...
    'parseStrings', false, ...
    'showInfo', false);
end
