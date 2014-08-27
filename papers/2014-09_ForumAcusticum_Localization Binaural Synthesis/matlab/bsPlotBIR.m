function bsPlotBIR(bir, kpw, tbir)
%IRPLOT Summary of this function goes here
%   Detailed explanation goes here

% minimum db
db_lim = -50;

% normalize
bmax = max(abs(bir.left), abs(bir.right));
n = max(bmax(:));

bl = db(bir.left/n);
br = db(bir.right/n);
bl(bl < db_lim) = db_lim;
br(br < db_lim) = db_lim;

bmax = db(bmax/n);

%
if (nargin < 3)
  tbir = (0:size(bir.left,1)-1)/bir.fs;
end

tlim = max(abs(tbir(any(bmax > db_lim, 2)))) + 1e-3;
tmin = max(-tlim, tbir(1));
tmax = min(tlim, tbir(end));

if nargin < 2 || isempty(kpw)
  figure
  subplot(1,2,1)
  plot(tbir, bir.left);
  xlabel('time (s)');
  xlim([tmin tmax])

  subplot(1,2,2)
  plot(tbir, bir.right);
  xlabel('time (s)');
  xlim([tmin tmax])
else
  % compute azimuth angle (in deg)
  phi = atan2(kpw(2,:), kpw(1,:))/pi*180;

  phimin = min(phi);
  phimax = max(phi);

  figure
  subplot(1,2,1)
  imagesc(phi, tbir, bl);
  set(gca,'XDir','reverse');
  set(gca,'YDir','normal');
  xlabel('angle (deg)');
  ylabel('time (s)');
  set(gca,'CLim',[db_lim 0]);
  axis([phimin phimax tmin tmax])
  axis square
  colorbar;

  subplot(1,2,2)
  imagesc(phi, tbir, br);
  set(gca,'XDir','reverse');
  set(gca,'YDir','normal');
  xlabel('angle (deg)');
  ylabel('time (s)');
  set(gca,'CLim',[db_lim 0]);
  axis([phimin phimax tmin tmax])
  axis square
  colorbar;
end
end
