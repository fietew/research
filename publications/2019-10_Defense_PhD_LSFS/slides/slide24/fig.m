SFS_start

% listening positions
x = [0.00; 0.50; 1.00; 0.00; 0.50; 1.00; 1.25;  0.00;  0.50;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75];

% calibration position
xcalib = 0;
ycalib = 0;

% loudspeaker array
phi0 = (0:55).'*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

gp_save('listener.txt', [x,y,zeros(10,2)]);
gp_save('calib.txt', [xcalib,ycalib]);
gp_save('array.txt', [x0,y0])
