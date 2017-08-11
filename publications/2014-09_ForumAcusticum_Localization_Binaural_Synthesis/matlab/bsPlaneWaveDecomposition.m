function [P, p, kpw, fpw, tpw] = bsPlaneWaveDecomposition(source, params)
%Plane Wave Decomposition of plane or spherical wave
%
%   Usage: [P, p, kpw, fpw, tpw] = bsPlaneWaveDecomposition(source, params)
%
%   Input parameters:
%       source      - source struct (see script_parameters)
%       params      - parameter struct (see script_parameters)
%
%   Output parameters:
%       P           - PWD in frequency domain [(Nfft/2 + 1) x Npw]
%       p           - PWD in time domain [Nfft x Npw]
%       kpw         - corresponding incidence vectors [3 x Npw]
%       fpw         - corresponding frequency samples [(Nfft/2 + 1) x 1]
%       tpw         - corresponding time samples [Nfft x 1]
%
%   bsPlaneWaveDecomposition(source, params) generates PWD for
%   plane/spherical wave with delay&sum-beamformer (DSB) or modal
%   beamformer (MB). One may choose the sampling mode (discrete or
%   continuous). Discrete Processing is done by SOFiA Toolbox.
%   Everything has to be specified in the params-struct.
%
%   see also: script_parameters, sofia_lebedev

%*****************************************************************************
% Copyright (c) 2014-2015 Fiete Winter, Frank Schultz, Sascha Spors          *
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

%% Check Arguments
% check source type
if (~strcmp(source.type,'plane') ...
    && ~strcmp(source.type,'point') ...
    && ~strcmp(source.type,'uniform'))
  error('source type not supported');
end
% check beamformer type
if (~strcmp(params.beamformer,'MB') && ~strcmp(params.beamformer,'DSB'))
  error('beamformer not supported');
end
% check sampling mode
if (~strcmp(params.sampling.mode,'continuous') ...
    && ~strcmp(params.sampling.mode,'discrete'))
  error('sampling mode not supported');
end

xi = source.position;       % position of source (only for spherical wave)
phii = atan2(xi(2),xi(1));  % incidence azimuth angle
thetai = acos(xi(3));       % incidence ele. angle
ri = norm(source.position); % distance to source (only for spherical wave)
ki = xi/ri;                 % incidence vector

Nsht = params.Nsht;  % Order of Spherical Harmonics Transformation
Npw = params.Npw;    % Number of plane waves in PWD
Nfft = params.Nfft;  % Number of temporal samples
Nf = Nfft/2 + 1;     % Number of frequency samples
Npoints = params.sampling.Npoints;  % sphere samples (see sofia_lebedev)
R = params.R;        % radius of spherical array
fs = params.conf.fs; % sampling frequency
c = params.conf.c;   % speed of sound

taupw = (Nfft/2)/fs;  % shift to prevent cyclic shift due to ifft
tpw = (0:Nfft-1)/fs - taupw;   % time axis
fpw = linspace(0,fs/2.0,Nf).'; % frequency axis

% equi-angular sampling
phi= 2.0*pi/Npw*(0:(Npw-1)) - pi;
theta = pi/2.0*ones(1,Npw);

% incidence direction vectors of plane wave decomposition (PWD)
kpw = [ ...
  cos(phi).*sin(theta); ...
  sin(phi).*sin(theta); ...
  cos(theta); ...
  ];

P = zeros(Npw,Nf);  % PWD in frequency domain
k = 2*pi*fpw/c;  % wave number vector

%% get sampling grid for discrete cases
if strcmp(params.sampling.mode,'discrete')
  switch params.sampling.pattern
    case 'lebedev'
      try
        gridData = sofia_lebedev(Npoints, 0);
      catch
        sofia_lebedev;
        error('Number of Samples on Sphere is not supported!');
      end
    otherwise
      error('sampling pattern not supported');
  end
end

%% uniform case (plane waves from all directions)
% this is just for testing purposes
if strcmp(source.type,'uniform')
  P(:) = 1;
%% continous case (MB and DSB)
% Implementation of equations (8) (9) in:
% Comparison of modal versus delay-and-sum beamforming.
% authors: Sascha Spors, Hagen Wierstorf and Matthias Geier
% code of Sascha Spors
% extension for point sources by Fiete Winter
elseif strcmp(params.sampling.mode,'continuous')
  % compute combination of Radial Filter and SHT Coefficients
  % circumventing unnecessary computations (also cancel zeros and poles)
  % check:
  % Radial Filter:
  % DSB   => 4*pi * 1i^(-n) * conj(sphbesselj(n,k*R))
  % MB    => 1 / (4*pi * 1i^(n) *sphbesselj(n,k*R))
  % SHT Coeffs:
  % plane => 4*pi * 1i^(n) *sphbesselj(n,k*R)
  % point => -1j*k.*sphbesselh(n,2,k*ri)*sphbesselj(n,k*R) 
  dn = ones(Nsht+1, Nf); 
  switch source.type
    case 'plane'
      for n=1:Nsht+1
        dn(n,:) = 4*pi * 1i^(n-1);  % *sphbesselj(n-1,k*R)
      end      
    case 'point'
      for n=1:Nsht+1
        dn(n,:) = -1j*k.'.*sphbesselh(n-1,2,k.'*ri); % *sphbesselj(n-1,k*R)
        dn(n,1) = dn(n,2);
      end
      % soft limiting (Benny Bernschütz, SOFiA)
      if ~isinf(params.dblimit)
        alpha = 10^(params.dblimit/20);
        dn = 2/pi*alpha*dn./abs(dn).*atan(pi/2*abs(dn)/alpha);
      end
  end 
  switch params.beamformer
    case 'DSB'
      for n=1:Nsht+1
        dn(n,:) = dn(n,:) .* 4*pi .* 1i^(-(n-1)) .* abs(sphbesselj(n-1,k.'*R)).^2;
      end
    case 'MB'
      for n=1:Nsht+1
        dn(n,:) = dn(n,:) ./ (4*pi * 1i^(n-1)); % ./ sphbesselj(n-1,k*R)
      end
  end
  
  % Compute Legendre-Polynoms
  L = zeros(Npw,Nsht+1);  % Legendre-Polynoms
  % cosine of angle between plane wave and current direction of PWD
  cosOmega = ki*kpw; %note: this works only for unit vectors!
  for n=1:Nsht+1
    tmp = legendre(n-1, cosOmega);
    L(:,n) = tmp(1,:).';
  end  
  
  % Compute PWD-Coefficients
  for m=1:Npw
    for n=1:Nsht+1
      P(m,:) = P(m,:) + dn(n,:) .* (2*(n-1)+1)/(4*pi) * L(m,n);
    end
  end
%% discrete modal beamformer (MB) of SOFiA
% code taken from the Examples of SOFiA (AE6, AE7)
elseif (strcmp(params.beamformer,'MB'))  
  % determine wavetype for SOFiA API
  switch source.type
    case 'point'
      wavetype = 1;
    case 'plane'
      wavetype = 0;
  end

  ac = 1;  % type of microphone array (see 'help sofia_wcg')
  
  [fftData, kr] = sofia_swg(R, gridData, ac, fs, Nfft, phii, ...
    thetai, 120, 0, c, wavetype, ri);

  Pnm = sofia_stc(Nsht, fftData, gridData);

  dn = sofia_mf(Nsht, kr, ac, params.dblimit);  % radial filter
  P = sofia_pdc(Nsht, [phi', theta'], Pnm, dn);  % PWD
%% discrete delay and sum beamformer (DSB)
% code of Frank Schultz
% extension for point sources by Fiete Winter
elseif (strcmp(params.sampling.mode,'discrete'))
  [X,Y,Z]=sph2cartFS(gridData(:,2),gridData(:,1),R);
  x = [X,Y,Z];  % position of sphere point
  weights = gridData(:,3);  % Lebedev-weights for sampling

  switch source.type
    case 'plane'
      for m=1:Npw
        for n=1:Npoints
          s = x(n,:)*(ki'-kpw(:,m));
          P(m,:) = P(m,:) + exp(+1j*k'*s) * weights(n);
        end
      end
    case 'point'
      for m=1:Npw
        for n=1:Npoints
          r = norm(xi - x(n,:));  % distance source, sphere surface point
          s = -x(n,:)*kpw(:,m);
          P(m,:) = P(m,:) + exp(-1j*k'*r)./r .* exp(+1j*k'*s) * weights(n);
        end
      end
  end
end

% compensate distance delay for point sources
if strcmp(source.type,'point')
  for m=1:Npw
    P(m,:) = P(m,:) .* exp(1j*k'*ri);
  end
end
% apply global delay 'taupw' (just to put the IR "in the middle")
for m=1:Npw
  P(m,:) = P(m,:) .* exp(-1j*2*pi*fpw'*taupw);
end
  
P = P.';  % don't forget the "." ! ("'" is for conjugate transpose) 
p = ifft(cat(1,P,zeros(Nf-2,Npw)),[],1,'symmetric');

end

