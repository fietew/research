function [P, p, tau] = bsShiftPWD(P, f, kpw, xT, params)
% Shifts PWD about specified translation vector
%
%   Usage: [P, p, tau] = bsShiftPWD(P, f, kpw, xT, params)
%
%   Input parameters:
%       P           - PWD in frequency domain [Nf x Npw]
%       f           - corresponding frequency axis [Nf x 1]
%       kpw         - corresponding incidence vectors [3 x Npw]
%       xT          - cartesian shift vector [1 x 3]
%
%   Output parameters:
%       P           - shifted PWD in frequency domain [Nf x Npw]
%       p           - cooresponding PWD in time domain [2*(Nf-1) x Npw]
%
%   see also: bsRotatePWD

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

Nf = size(P,1);  % number of frequency samples
Npw = size(P,2);  % number of equi-angular samples

% row vector of delays (rounded to integer delays, if defined)
tau = (xT*kpw)/params.conf.c;  
if (params.integer_delay)
  tau = round(tau*params.conf.fs)/params.conf.fs;  
end
omega = 2*pi*f;                   % column vector of frequencies
factor = exp(1j*omega*tau);       % matrix of delay factors

P = P.*factor;  % apply shift in frequency domain
p = ifft(cat(1,P,zeros(Nf-2,Npw)),[],1,'symmetric');  % ifft
