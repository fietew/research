function w = winF_hann(k,X)
% transfer function of 1D-Hann window
%
% Parameters:
%   k - matrix of frequency points where the transfer function should be evaluated
%   X - width of window

  shift = 2.*pi./X;
  w = 0.5*winF_rect(k,X) ...
    + 0.25*winF_rect(k + shift,X) ...
    + 0.25*winF_rect(k - shift,X); 
end