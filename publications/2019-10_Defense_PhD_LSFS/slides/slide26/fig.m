SFS_start

% listening positions
x = -0.5;
y =  0.75;

% listening orientation
xs = [2.5, 0, 0];
phiori = cart2pol(xs(1) - x, xs(2) - y);
phiori = rad2deg(phiori);

% calibration position
xcalib = 0;
ycalib = 0;

% loudspeaker array
phi0 = (0:55).'*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

gp_save('listener.txt', [x,y,phiori, 0]);
gp_save('calib.txt', [xcalib,ycalib]);
gp_save('array.txt', [x0,y0])
