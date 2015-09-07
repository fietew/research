%*****************************************************************************
% Copyright (c) 2014-2015 Fiete Winter                                       *
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

%% ===== Parameters ==========================================================
addpath('../../matlab/');
script_parameters;
%
params.source.position = [1.0, 0.0, 0];
%
params.Nsht = 23;
% uniform distribution in azimuth and frequency
params.source.type = 'plane';
% shift vector
xT = [0.0, 0.343, 0.0];

%% ===== Computation =========================================================

% plane wave decomposition
[P, p, kpw, fpw, tpw] = bsPlaneWaveDecomposition(params.source, params);

% shift of plane wave decomposition
[P_shift, p_shift, tau] = bsShiftPWD(P, fpw, kpw, xT, params);

%% ===== Plotting ============================================================

f1 = subplot(2,2,1);
bsPlotPWDFrequency(P, kpw, fpw, false);
title('transfer function');
xlabel('');
set(gca, ...
  'XTick',[],...
  'XTickLabel',{});

f2 = subplot(2,2,3);
bsPlotPWDTime(p, kpw, tpw, false);
ylim([-1.1,1.1]);
title('\shortstack{impulse response \\ \footnotesize{\,}}');

f3  = subplot(2,2,4);
bsPlotPWDTime(p_shift, kpw, tpw, true);
title('\shortstack{shifted impulse response \\ \footnotesize{\(\mathbf x_{\mathrm T} = (0, 0.343, 0)^T\)}}');
ylim([-1.1,1.1]);
ylabel('');
set(gca, ...
  'YTick',[],...
  'YTickLabel',{});
colorbar('YTick',-50:10:0, ...
    'YTickLabel', {'-50dB', '-40dB', '-30dB', '-20dB', '-10dB', '0dB'});

matlab2tikz( 'fig.tex', ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'parseStrings', false);
