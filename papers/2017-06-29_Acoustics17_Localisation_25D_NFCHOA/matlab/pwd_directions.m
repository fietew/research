function pwd_directions( conf )
%

%% ===== Configuration ==================================================
xs = conf.xs;  % propagation of plane wave

order = conf.nfchoa.order;  % order of truncation window
window = conf.nfchoa.modal_window;  % type of truncation window

pos = conf.pos;  % listener position
c = conf.c;  % speed of sound

Nphi = conf.Nphi;  % resolution of inverse fourier series

%% ===== Computation ====================================================

% grid of propagation directions of plane wave decompositions
phi0 = (0:2*pi/Nphi:2*pi*(1-1/Nphi)).';  % [Nphi x 1]
% propagation direction of virtual plane wave
phis = atan2( xs(:,2), xs(:,1) );

% angular weighting function
wm = modal_weighting(order, conf);  % modal window
W = wm*transpose(exp(1j*(phi0-phis)*(-order:order)));  % inverse DTFT
W = real(W.')./max(abs(W(:)));  % normalize

% delay depending on listening positions
tau = [cos(phi0), sin(phi0)]*pos(:,1:2).'/c;
tau = tau*1000;  % scale to milliseconds

% convert from propagation direction to directions of appearence
phi0 = phi0+pi;

% gnuplot
prefix = sprintf('posx%02.02f_posy%02.02f',pos(:,1),pos(:,2));
switch window
  case 'rect'
    prefix = sprintf('%s_rect_M%d', prefix, order);
  case 'kaiser'
    alpha = conf.nfchoa.modal_window_parameter;
    prefix = sprintf('%s_kaiser_M%d_alpha%02.02f', prefix, order, alpha);
end
gp_save( [prefix '_directions.txt'], [phi0, tau, db(W)] );
