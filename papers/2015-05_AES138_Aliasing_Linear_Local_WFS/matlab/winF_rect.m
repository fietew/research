function w = winF_rect(k, X)
% transfer function of 1D-rectangular window
%
% Parameters:
%   k - matrix of frequency points where the transfer function should be evaluated
%   X - width of window

  w = X.*sinc(k./(2*pi).*X);
end