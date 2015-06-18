function [in, kpw] = bsAngularResolution(in, kpw, res)
%Change angular resolution of plane wave decomposition
%
%   Usage: [in, kpw] = bsAngularResolution(in, kpw, res)
%
%   Input parameters:
%       in          - plane wave decomposition (time or frequency domain)
%       kpw         - corresponding plane wave incidence direction vectors
%       res         - resolution in degree (no upsampling possible)
%
%   Output parameters:
%       in          - subsampled plane wave decomposition
%       kpw         - corresponding plane wave incidence direction vectors
%
%   BSANGULAR_RESOLUTION(nk,x0,f,conf)

% subsampling factor
% new resolution / old resolution
k = res/(360/ size(in,2));

% at the moment only integer subsampling is possible
if (k < 1)
  error('TODO: interpolation of PWD (for fractional k)');
elseif (round(k) ~= k)
  error('only integers of old resolution');
end

in = in(:,1:k:end);
kpw = kpw(:,1:k:end);
