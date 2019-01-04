% plane wave decompositions of planve wave + translatory shift

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

%% ===== Parameters ==========================================================

addpath('../../matlab/');
script_parameters;
% uniform distribution in azimuth and frequency
params.source.type = 'uniform';
% shift vector
xT = [0.0, 0.343, 0.0];

%% ===== Computation =========================================================
% plane wave decomposition
[P, p, kpw, fpw, tpw] = bsPlaneWaveDecomposition(params.source, params);
% shift of plane wave decomposition
[P_shift, p_shift, tau] = bsShiftPWD(P, fpw, kpw, xT, params);

%% ===== Plotting ============================================================
f1 = figure;
bsPlotPWDTime(p,kpw,tpw);
ylim([-2,2]);

f2 = figure;
bsPlotPWDTime(p_shift,kpw,tpw, true);
ylim([-3,3]);

matlab2tikz( 'fig1.tex', ...
  'figurehandle', f1, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'parseStrings', false);

matlab2tikz( 'fig2.tex', ...
  'figurehandle', f2, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'parseStrings', false);
