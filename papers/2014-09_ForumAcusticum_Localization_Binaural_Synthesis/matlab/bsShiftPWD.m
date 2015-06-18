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
%
%   F.Winter, F.Schultz, S.Spors 

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
