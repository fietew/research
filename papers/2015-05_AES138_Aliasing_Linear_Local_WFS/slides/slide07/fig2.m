clear all;
close all;

addpath('../../matlab');
SFS_start;

c = 343;  % velocity of sound

kxvec = linspace(-100,100, 500);  % spatial frequency vector in x direction
fvec = linspace(0, 2000, 500);  %  temporal frequency vector
[kx, f] = meshgrid(kxvec, fvec);  % grid of both frequencies

ky = kyroot(2*pi*f/c,kx, 'evanescent');  % spatial frequency in y-direction

% NOTE: The shift theorem of the fourier transform dependence on the
% definition of the fourier transform. 
% For the temporal fourier transform:
% f(t-t0) <---> F(f) e^(-j*2*pi*f*t0)
% For the spatial fourier transform:
% f(x-x0) <---> F(kx) e^(j*kx*x0)

% loudspeaker domain
x0 = 0;
y0 = 0;  % position of loudspeaker array
L0 = 3.0;
w0 = winF_rect(kxvec,L0).*exp(1j*kxvec*x0); % truncation window

% virtual source
xs = -1.0;
ys = -3.0;
D0 = exp(1j.*kx.*xs + ky.*(ys - y0));  % spectrum of driving function
D0tr = conv2(D0, w0, 'same');  % truncation

% geometric approximations
alpha01 = atan2(y0 - ys, x0 + L0 / 2 - xs);
alpha02 = atan2(y0 - ys, x0 - L0 / 2 - xs);

m01 = 2*pi/c*cos(alpha01);
m02 = 2*pi/c*cos(alpha02);

flim = [0,fvec(end)];

%% gnuplot

gp_save_matrix('spectrum_D0tr.dat', ...
  kxvec,fvec,20*log(abs(D0tr)./max(abs(D0tr(:)))));

gp_save('approx.dat', [m01*flim; flim; m02*flim; flim]');