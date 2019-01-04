function [out] = evalLocalization(P, params)
% evaluate localization properties of plane wave decomposition

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

Npw = params.Npw;
Nfft = params.Nfft;
Nf = Nfft/2 + 1;
Nshift = size(params.shift,1);
Nrot = length(params.rot);
fs = params.conf.fs;

tpw = ((0:Nfft-1) - Nfft/2)/fs;
fpw = linspace(0,fs/2.0,Nf)';

phipw= 2.0*pi/Npw*(0:(Npw-1)) - pi;
thetapw = pi/2.0*ones(1,Npw);
% direction of plane wave decomposition (pwd)
kpw = [ ...
  cos(phipw).*sin(thetapw); ...
  sin(phipw).*sin(thetapw); ...
  cos(thetapw); ...
  ];

% open HRTF-Dataset
hrirs = read_irs(params.files.hrirs,params.conf);
% open lookup-table
%lookup = load(params.files.lookup);
load(params.files.lookup,'lookup');

% input for binaural model
input = localization_noise();

out.P = zeros(Nf, Nshift, Nrot);
out.p = zeros(Nfft, Nshift, Nrot);
out.phi = zeros(Nshift, Nrot);
out.delta = zeros(Nshift, Nrot);
out.phi_real = zeros(Nshift, Nrot);

for kdx=1:Nrot
  progress_bar(kdx,Nrot);
  % rotate source position
  M = eye(3);
  rot = params.rot(kdx);
  M(1:2,1:2) = [cosd(rot), -sind(rot); sind(rot), cosd(rot)];
  source_pos = params.source.position*M.';
  % rotate PWD
  P_rot = bsRotatePWD(P,rot);

  for idx=1:Nshift
    xT = params.shift(idx,:);
    %% Apply Shift and auralization
    % shift of plane wave decomposition
    [Pwd, pwd] = bsShiftPWD(P_rot, fpw, kpw, xT, params);

    % compute pressure for xT
    out.P(:,idx,kdx) = squeeze(sum(Pwd,2));
    out.p(:,idx,kdx) = squeeze(sum(pwd,2));

    % auralize pwd
    bir = bsAuralizePWD(pwd, tpw, hrirs, params);
    ir.left = sum(bir.left,2);
    ir.right = sum(bir.right,2);

    %% Auralize input data
    output = [];
    output(:,1) = conv(ir.left, input);
    output(:,2) = conv(ir.right, input);

    %% Localization with binaural model
    % determine desired azimuth
    switch params.source.type
      case 'plane'
        phi_real = atan2d(source_pos(2), source_pos(1));
      case 'point'
        r_shift = source_pos - xT;
        phi_real = atan2d(r_shift(2), r_shift(1));
    end

    try
      out.phi(idx,kdx) = ...
        wierstorf2013estimateazimuth(output,lookup,params.model.name);
    catch
      out.phi(idx,kdx) = ...
        wierstorf2013estimateazimuth(output,lookup,params.model.altname);
    end
    out.delta(idx,kdx) = abs(out.phi(idx,kdx)-phi_real);
    out.phi_real(idx,kdx) = phi_real;
  end
end
out.Pwd = P;
out.xshift = params.shift;
end
