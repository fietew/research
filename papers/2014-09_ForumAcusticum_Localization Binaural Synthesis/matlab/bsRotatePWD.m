function [P, p] = bsRotatePWD(P, phi)
% Rotates the PWD about a specified angle
%
%   Usage: [P, p] = bsRotatePWD(P, phi)
%
%   Input parameters:
%       P           - PWD in frequency domain
%       phi         - shift angle (rounded to fit angular grid of the PWD)
%
%   Output parameters:
%       irs         - directional HRIRs for phi=[-180:360/pi:180). Contains
%                     .right and .left (each [Nhrir x Npw])
%
%   bsRotatePWD(P, phi) shifts the PWD about the specified angle phi 
%   rounded to angular grid of the PWD. This can be used to generate the 
%   wavefield of a rotated source.
%
%   see also: bsShiftPWD
  
  Nf = size(P,1);  % Number of frequency samples
  Npw = size(P,2);  % Number of angular samples 
  shift = round(phi/(2*pi)*Npw);  % compute angular shift (rounding)
  
  P = circshift(P,[0 shift]);  % shift PWD

  p = ifft(cat(1,P,zeros(Nf-2,Npw)),[],1,'symmetric');  % get time-PWD
end

