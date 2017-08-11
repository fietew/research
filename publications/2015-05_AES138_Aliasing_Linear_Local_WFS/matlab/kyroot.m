function [res] = kyroot(wc, kx, mode)
% calculates ky out of omega/c and kx
%
% Parameters:
%   wc : matrix of 2*pi*f/c with temporal frequency f and sound velocity c
%   kx : matrix of spatial frequency in x direction
%   mode : 'evanescent' for computing the evanescent contribution


res = zeros(size(wc));
select = abs(kx) < abs(wc);  %
res(select) = 1j.*sqrt(wc(select).^2 - kx(select).^2);  % propagating part
if nargin == 3 && strcmp('evanescent', mode)
  res(~select) = sqrt(kx(~select).^2 - wc(~select).^2);
else
  res(~select) = inf;
end

end