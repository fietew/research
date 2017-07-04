function soundfields( conf )
% time domain sound field plots of plane wave including spatial bandwidth
% limitation and NFC-HOA synthesis

%*****************************************************************************
% Copyright (c) 2017      Fiete Winter                                       *
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

%% ===== Configuration ==================================================
xs = conf.xs;  % source position
method = conf.method;
order = conf.nfchoa.order;  % order of truncation window
pos = conf.pos;  % listener position
c = conf.c;  % speed of sound

X = conf.X;
Y = conf.Y;
Z = conf.Z;

%% ===== Computation ====================================================

% propagation direction of virtual plane wave
phis = atan2( xs(:,2), xs(:,1) );
% ensure that plane wave is arriving at listener position in time-domain plot
toffset = pos(1:2)*[cos(phis); sin(phis)]./c;

switch method
  case 'ref'
    % === Reference ===
    x0 = [-xs, xs, ones(size(xs,1),1)];
    d = ones(1,size(xs,1));
    % compute sound field
    [P, x, y] = sound_field_imp(X,Y,Z, x0, 'pw', d, -toffset, conf);
  case 'pw'
    % === Modally bandwidth-limited plane wave ===
    % invert secondary source positions to get propagation direction
    x0 = secondary_source_positions(conf);
    phi0 = atan2(-x0(:,2),-x0(:,1));
    % modal weighting function
    wm = modal_weighting(order, conf);
    % inverse DTFT of weighting function (weight for each plane wave)
    wm(2:end) = wm(2:end)*2;  % weighting for real-valued inverse DTFT
    d = wm*cos((phi0-phis)*(0:order)).'./(2*pi);  % real-valued inverse DTFT
    % compute sound field
    conf.plot.loudspeakers = false;
    [P, x, y] = sound_field_imp(X,Y,Z, x0,'pw', d, -toffset, conf);
  case 'nfchoa'
    % === NFC-HOA ===
    % Get secondary sources
    x0 = secondary_source_positions(conf);
    % Calculate driving function
    [d, ~, doffset] = driving_function_imp_nfchoa(x0,xs,'pw',conf);
    % compute sound field
    [P, x, y] = sound_field_imp(X,Y,Z,x0,'ps', d, doffset-toffset,conf);
end

prefix = brs_nameprefix(conf);

%% ===== Plotting =======================================================

plot_sound_field(P,X,Y,Z,x0,conf);
title( prefix, 'Interpreter', 'none' );

%% ===== Gnuplot ========================================================

prefix = brs_nameprefix( conf );
gp_save_matrix(['soundfield_' prefix '.dat'], x,y, db(P));
gp_save_loudspeakers(['array_' prefix '.txt'],  [x0; x0(1,:)]);
