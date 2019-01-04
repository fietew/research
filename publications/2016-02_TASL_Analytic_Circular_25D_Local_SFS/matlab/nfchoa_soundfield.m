function nfchoa_soundfield(conf)
% computes reproduced soundfield by nfchoa using different reference radius. The
% Results will be save in gnuplot-readable file formats using the respective
% functionalities of the Sound Field Synthesis Toolbox.

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
isargpositivescalar(conf.frequency);

%% ===== Variables =======================================================
src = conf.source_type;

normalize = norm(conf.xref) == 0;

X0 = conf.secondary_sources.center;
xt = conf.xt;

f = conf.frequency;

x = [-2 2];
y = [-2 2];
z = 0;

Nse = conf.Nse;
%% ===== Computation =====================================================

% spherical expansion
switch src 
  case 'ps'
    xs = conf.distance*[cos(conf.azimuth), sin(conf.azimuth), 0];
    Anm = sphexp_mono_ps(xs, 'R', Nse, f, X0, conf);
  case 'pw'
    xs = -[cos(conf.azimuth), sin(conf.azimuth), 0];
    Anm = sphexp_mono_pw(xs, Nse, f, X0, conf);
  otherwise
    error('%s: unknown source type',upper(mfilename));
end

% driving functions
Dnm = driving_function_mono_nfchoa_sht_sphexp(Anm, f, conf);
% normalize field ground truth value at xref
if normalize
  P_gt = ...
    sound_field_mono_sphexp(xt(1),xt(2),xt(3), Anm, 'R', f, X0,conf);
  P = sound_field_mono_sht(xt(1),xt(2),xt(3), Dnm, f, conf);
  Dnm = Dnm .* P_gt ./ P;
end

% sound fields
[P,X,Y] = sound_field_mono_sht(x, y, z, Dnm, f, conf);
P_gt = sound_field_mono(x, y, z, [xs, 1, 0, 0, 1], src, 1, f, conf);

% gnuplot
gp_save_matrix(sprintf('%s_rep.dat', evalGenerateFilename(conf)),X,Y, P);
gp_save_matrix(sprintf('%s_gt.dat', evalGenerateFilename(conf)),X,Y, P_gt);
gp_save_matrix(sprintf('%s_err.dat', evalGenerateFilename(conf)),X,Y, db(abs(P./P_gt-1)));
