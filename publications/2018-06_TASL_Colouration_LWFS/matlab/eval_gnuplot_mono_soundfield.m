function eval_gnuplot_mono_soundfield(conf)
% reads file generated by brs_driving_signals.m and computes a monochromatic
% sound field

%% ===== Configuration ========================================================
xs = conf.xs;
pos = conf.pos;
src = conf.src;
method = conf.method;
fs = conf.fs;
conf.plot.useplot = conf.useplot;
c = conf.c;
f = conf.f;
N = conf.N;
k = 2*pi*f/c;
r0 = conf.secondary_sources.size/2;

%% ===== Computation ==========================================================
load( [brs_nameprefix(conf), '.mat'], 'res');

X = [-1.6, 1.6];
Y = [-1.6, 1.6];
Z = 0;

switch src
  case 'pw'
    t = xs*pos.'/c;
    g = 1;
  case 'ps'
    r = norm(xs - pos);
    t = r/c;
    g = 1/(4*pi*r);
end
t = t + res.delay_offset + 0.01;

if ~any(strcmp(method, {'gt', 'anchor'}))
  src = 'ps';
end

% radius of high accuracy
phitmp = (0:360).';
switch method
  case 'nfchoa'
    M = conf.nfchoa.order;
  case 'lwfs-sbl'
    M = conf.localwfs_sbl.order;
  case 'lwfs-vss'
    M = conf.localwfs_vss.size/2*k; 
  case 'wfs'
    M = conf.secondary_sources.size/2*k;
  case {'ref', 'stereo'}
    M = NaN;
  otherwise
    error('unknown method');
end

rM = [M/k*cosd(phitmp)+pos(1), M/k*sind(phitmp)+pos(2)];

% approxmiation for spectral repetitions
phis = atan2d( pos(2)-xs(2), pos(1)-xs(1) );
[phial, ral, xsec] = nfchoa_grating_lobes(pos, phis, f, M, 1, conf);
nal = [cosd(phial), sind(phial)];
north = [-sind(phial), cosd(phial)];

xal = [];
for idx=1:length(phial)
  gal = bsxfun(@plus, (-1)^idx*r0*[-4:0.25:4].'*nal(idx,:), xsec);
  galmin = bsxfun(@plus, gal, ral(idx)*north(idx,:));
  galmax = bsxfun(@plus, gal, -ral(idx)*north(idx,:));

  xal = [xal; [gal, galmin, galmax]];
end 

d = cos( 2*pi*f/fs*(0:N-1)).';
d = convolution(real(res.d), d);
[P,x,y] = sound_field_imp(X,Y,Z,res.x0, src, d/g, t, conf);
if conf.plot.useplot
  hold on;
  plot(rM(:,1), rM(:,2), 'g--');
  plot(xal(:,1), xal(:,2), 'y');
  plot(xal(:,3), xal(:,4), 'y');
  plot(xal(:,5), xal(:,6), 'y');
  hold off;
  title(brs_nameprefix(conf), 'Interpreter', 'none');
end

gp_save_matrix([brs_nameprefix(conf) '.dat'], x, y, real(P));
gp_save_loudspeakers([brs_nameprefix(conf) '_ls.txt'], res.x0);
gp_save([brs_nameprefix(conf) '_xc.txt'], pos(:,1:2));
gp_save([brs_nameprefix(conf) '_rM.txt'], rM);
gp_save([brs_nameprefix(conf) '_xal.txt'], xal );

end