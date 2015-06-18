addpath('../../matlab/');
script_parameters;

% uniform distribution in azimuth and frequency
params.source.type = 'uniform';  

% shift vector
xT = [0.0, 0.343, 0.0];

% plane wave decomposition
[P, p, kpw, fpw, tpw] = bsPlaneWaveDecomposition(params.source, params);

% shift of plane wave decomposition
[P_shift, p_shift, tau] = bsShiftPWD(P, fpw, kpw, xT, params);

% plot
f1 = figure;
bsPlotPWDTime(p,kpw,tpw);
ylim([-2,2]);

f2 = figure;
bsPlotPWDTime(p_shift,kpw,tpw, true);
ylim([-3,3]);

matlab2tikz( 'fig02-1.tex', ...
  'figurehandle', f1, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'parseStrings', false, ...
  'relativeDataPath', 'fig02');

matlab2tikz( 'fig02-2.tex', ...
  'figurehandle', f2, ...
  'height', '\fheight', ...
  'width', '\fwidth', ...
  'parseStrings', false, ...
  'relativeDataPath', 'fig02');