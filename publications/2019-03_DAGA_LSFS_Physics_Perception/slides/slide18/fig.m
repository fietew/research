SFS_start

% listening positions
x = [0.00; 0.50; 1.00; 0.00; 0.50; 1.00; 1.25;  0.00;  0.50;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75];

% initial orientation
phiinit = 90;
vector_length = 0.3;
xinit = vector_length*cosd(phiinit);
yinit = vector_length*sind(phiinit);

listener = [x,y];
listener(:,3) = xinit;
listener(:,4) = yinit;

% loudspeaker array
phi0 = (0:55).'*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

gp_save('listener.txt', listener);
gp_save('array.txt', [x0,y0])
