clear all;
close all;

SFS_start;
addpath('../../matlab');

c = 343;  % velocity of sound

kxvec = linspace(-100,100, 500);  % spatial frequency vector in x direction
fvec = linspace(0, 2000, 500);  %  temporal frequency vector
[kx, f] = meshgrid(kxvec, fvec);  % grid of both frequencies

ky = kyroot(2*pi*f/c,kx, 'evanescent');  % spatial frequency in y-direction

% local domain 
xl = 2.0;
yl = 1.0; % position of virtual secondary sources
Ll = 2.0;
wl = winF_rect(kxvec,Ll).*exp(1j*kxvec*xl); % truncation window

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
Dl = exp(1j.*kx.*xs + ky.*(ys - yl));  % spectrum of driving function for local domain
Dltr = conv2(Dl, wl, 'same');  % truncation

% spectrum of driving function for one focused source
Dfs = conj(exp(ky.*(y0 - yl)));

% spectrum of driving function for the loudspeaker domain
D0 = Dfs.*Dl;
D0tr_ = Dfs.*Dltr;
D0_tr = conv2(D0, w0, 'same');  % truncation
D0trtr = conv2(D0tr_, w0, 'same');  % truncation

% geometric approximations
alpha01 = atan2(y0 - ys, x0 + L0 / 2 - xs);
alpha02 = atan2(y0 - ys, x0 - L0 / 2 - xs);

m01 = 2*pi/c*cos(alpha01);
m02 = 2*pi/c*cos(alpha02);

flim = [0,fvec(end)];

%% gnuplot

gp_save_matrix('spectrum_D0tr.dat', ...
  kxvec,fvec,20*log(abs(D0_tr)./max(abs(D0_tr(:)))));

gp_save('approx.dat', [m01*flim; flim; m02*flim; flim]');