SFS_start;

f = [0:0.01:4].';
deltatau = 0.5;

spectrum = sqrt(2*(1 + cos(2*pi*f*deltatau)));

gp_save('spectrum.txt', [f, spectrum]);