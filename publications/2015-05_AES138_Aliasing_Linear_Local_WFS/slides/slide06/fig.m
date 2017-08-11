clear all;
close all;

addpath('../../matlab');
SFS_start;

c = 343;  % velocity of sound
y0 = 0;  % position of loudspeaker array

kxvec = linspace(-100,100, 500);  % spatial frequency vector in x direction
fvec =linspace(0, 2000, 500);  %  temporal frequency vector
[kx, f] = meshgrid(kxvec, fvec);  % grid of both frequencies

ky = kyroot(2*pi*f/c,kx, 'evanescent');  % spatial frequency in y-direction

% spectrum of greens function
y = 2;
G = 0.5*exp(-ky.*y).*(-ky);

% spectrum of driving function for one focused source
yl = 1;
Dfs = exp(-ky.*(yl - y0));

% spectrum of driving function for virtual point source
xs = 0;
ys = -1;
Ds = exp(1j.*kx.*xs - ky.*(yl - ys));

%% gnuplot

gp_save_matrix('spectrum_D0.dat', ...
  kxvec,fvec,20*log(abs(Ds)./max(abs(Ds(:)))));

gp_save_matrix('spectrum_G0.dat', ...
  kxvec,fvec,20*log(abs(G)./max(abs(G(:)))));