function bsPlotPWDFrequency(P, kpw, fpw, cb)
% function for plotting plane wave decomposition
% 
% F.Winter, F.Schultz, S.Spors

if nargin < 4
  cb = false;
end


fnorm = 500;
phinorm = 0;

% minimum db
db_min = -50;
db_max = 0;

fmin = 100;
fmax = 20000;

% compute azimuth angle (in deg)
phi = atan2(kpw(2,:), kpw(1,:))/pi*180;

phimin = min(phi);
phimax = max(phi);

[~, idx_fmin] = min(abs(fpw - fmin));
[~, idx_fmax] = min(abs(fpw - fmax));

% normalize
P=db(P/max(max(abs(P(idx_fmin:idx_fmax,:)))));

P(isinf(P)) = db_min; %note that this handles P=+/-inf we might not that what ge want

surf(phi, fpw, P);
set(gca,'XDir','reverse');
set(gca,'YDir','normal');
shading interp;
view(0,90);
xlabel('\(\phi\) / deg');
ylabel('\(f\) / Hz');
set(gca,'YScale','Log')
set(gca,'CLim',[db_min db_max], ...
  'XTick',[-180; -120; -60; 0; 60; 120; 179], ...
  'XTickLabel',{'-180'; '-120'; '-60'; '0'; '60'; '120'; '180'});
axis([phimin phimax fmin fmax])
axis square
cm = colormap('jet');
cm = [cm; 1.0, 1.0, 1.0];
colormap(cm);
if (cb)
  colorbar;
end

end

