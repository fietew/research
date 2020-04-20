% comparison of equidistant and optimised sampling for point source
close all
clear all

addpath('../../matlab');
SFS_start;

conf = SFS_config;
conf.plot.usenormalisation = false;
conf.resolution = 300;
conf.xref = [0, 0, 0];

N0 = 21;
N0ref = 1024;
f = 2000;
X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

circ_piston = @(x,y,z,xs,f,conf) ...
  circarc_piston_mono(x,y,z,xs,f,deg2rad(30), conf);

%% Test scenarios
scenarios = {
  'linear', 'ps', [ 0, 2.5, 0], 'none', 0.25, [-0.5, 0, 0], 90, 90, 'ps';
  'linear', 'ps', [ 0, 2.5, 0], 'none', 0.25, [-0.5, 0, 0], 30, 30, circ_piston;
  'linear', 'ps', [ 0, 2.5, 0], 'both', 0.25, [-0.5, 0, 0], 90, 90, 'ps';
  'linear', 'ps', [ 0, 2.5, 0], 'both', 0.25, [-0.5, 0, 0], 90, 30, circ_piston;
  'linear', 'ps', [ 0, 2.5, 0], 'both', 0.25, [-0.5, 0, 0], 30, 30, circ_piston;
};

%%
for ii=1:size(scenarios,1)
  
  geometry = scenarios{ii, 1};
  src = scenarios{ii, 2};
  xs = scenarios{ii,3};
  [phis, rs] = cart2pol(xs(1),xs(2));  % polar coordinates
  opt = scenarios{ii,4};
  Rc = scenarios{ii,5};
  xc = scenarios{ii,6};
  alpha_opt = scenarios{ii,7};
  alpha_sim = scenarios{ii,8};
  ls_fun = scenarios{ii,9};  % loudspeaker model
  
  conf.secondary_sources.geometry = geometry;
  switch geometry
    case {'line', 'linear'}
      conf.secondary_sources.size = 3;
      conf.secondary_sources.center = [0, 1.5, 0];
      L = conf.secondary_sources.size;
      Xc = conf.secondary_sources.center;
      x0fun = @(s) linear(s,Xc);
      smin = -L/2;
      smax = +L/2;
    case {'circular', 'circle'}
      conf.secondary_sources.size = 3;
      conf.secondary_sources.center = [0,0,0];
      R = conf.secondary_sources.size/2;  % radius circular array
      x0fun = @(s) circle(s,R);
      if strcmp(src,'ps')
        smin = R.*(-acos(R/rs) + phis);
        smax = R.*(+acos(R/rs) + phis);
      elseif strcmp(src, 'pw')
        smin = R.*(-pi - phis);
        smax = R.*(+pi - phis);
      end 
  end
  
  switch opt
    case {'none', 'src'}
      % no restriction with respect to position == infinite radius
      minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,[0,0,0],Inf,sind(alpha_opt));
    case {'both', 'pos'}
      % circular area at xc with radius Rc
      minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,Rc,sind(alpha_opt));
  end
  switch opt
    case {'none', 'pos'}
      aliasing_fun = @(x0, kS, x) ...
        aliasing_extended_abitrary_soundfield(x0, x, minmax_kGt_fun, conf);
    case {'both', 'src'}
      % aliasing for xc  
      aliasing_fun = @(x0, kS, x) ...
        aliasing_extended(x0, kS, x, minmax_kGt_fun, conf);
  end
        
  % x0ref
  s0ref = linspace(smin, smax, N0ref).';
  x0ref = x0fun(s0ref);
  x0ref(:,7) = (smax - smin)./(N0-1);

  % local wavenumber kS of virtual sound field at x0ref
  kSx0ref = local_wavenumber_vector(x0ref(:,1:3), xs, src);

  % aliasing for xc  
  [fSxcold, fx0ref] = aliasing_fun(x0ref, kSx0ref, xc);
  fx0ref = min(fx0ref, 100000);
  
  % optimized aliasing (now constant wrt. to x0)
  fu = N0ref./sum(1./fx0ref);
  
  % compute u(s) as the integral over u'(s) ~ 1/fS(s) (trapezoidal integration)
  u0ref = cumtrapz(1./fx0ref.');
  
  % find s0 according to equidistant sampling w.r.t. u0 (linear interpolation)
  u0 = linspace(u0ref(1),u0ref(end),N0);
  s0 = interp1(u0ref,s0ref,u0,'linear');
  
  % secondary sources x0
  x0 = x0fun(s0);
  x0(:,7) = (smax - smin)./(N0-1);
  kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);
  [~, fx0] = aliasing_fun(x0, kSx0, xc);
  fx0 = min(fx0, 100000);
  x0(:,7) = fx0.'./fu.*x0(:,7);
  
  % sound field
  D = driving_function_mono_wfs(x0,xs,src,f,conf);
  [P,x,y] = sound_field_mono_custom(X,Y,Z,x0,ls_fun,D,f,conf);
  
  % normalisation factor 
  xref = xc;
  g = sound_field_mono(xref(1),xref(2),xref(3),[xs,0,1,0,1],src,1,f,conf);
  
  % aliasing frequency  
  x0ref(:,7) = fx0ref.'./fu.*x0ref(:,7);  % adjust sampling distance
  xvec = [x(:), y(:)];
  xvec(:,3) = 0;
  minmax_kGt_pos = @(x0p,xp) minmax_kt_circle(x0p,xp,0,sind(alpha_sim));
  fS = aliasing_extended(x0ref,kSx0ref,xvec,minmax_kGt_pos,conf);
  fS = reshape(fS, size(x));
  
  % new aliasing frequency for xc
  fSxcnew = aliasing_fun(x0ref, kSx0ref, xc);
  fSxcnew./fSxcold
  
  %% labels
  plottitle = sprintf('%s array, %s (%2.2f, %2.2f, %2.2f)\n', geometry, ...
    src, xs);
  prefix = sprintf('%s_%s_as%d_%s', src, geometry, alpha_sim, opt);
  if strcmp(opt, 'none')
    plottitle = sprintf('%s no sampling optimisation', plottitle);
  else
    plottitle = sprintf('%s sampling optimised w.r.t. %s', plottitle, opt);
    prefix = sprintf('%s_ao%d', prefix, alpha_opt);
    if any(strcmp(opt, {'pos', 'both'}))
      plottitle = ...
        sprintf('%s\nwith xc=[%2.2f, %2.2f, %2.2f] m and Rc=%2.2f m', ...
        plottitle, xc, Rc);
      prefix = sprintf('%s_xc%2.2f_yc%2.2f_Rc%2.2f', prefix, xc(1), ...
        xc(2), Rc);
    end
  end 
  
  %% plotting
  phiplot = (0:359).';
  switch src
    case 'ps'
      xplot = rs*cosd(phiplot) + xs(1);
      yplot = rs*sind(phiplot) + xs(2);
  end 
  conf.plot.usedb = false;
  plot_sound_field(P./abs(g),X,Y,Z,x0,conf);
  hold on
  contour(x,y,fS,[f,f],'k-');
  switch opt
    case {'pos', 'both'}
      xplot = Rc*cosd(phiplot) + xc(1);
      yplot = Rc*sind(phiplot) + xc(2);
      plot(xplot,yplot,'g');
  end
  hold off
  xlim(X);
  ylim(Y);
  title(['sound field', plottitle]);
  
  figure;
  imagesc(X,Y,fS)
  colorbar;
  hold on;
  contour(x,y,fS,[500, 1000, 1500, 2000, 2500, 3000],'r-','ShowText','on');
  draw_loudspeakers(x0,[1 1 0], conf);
  switch opt
    case {'pos', 'both'}
      xplot = Rc*cosd(phiplot) + xc(1);
      yplot = Rc*sind(phiplot) + xc(2);
      plot(xplot,yplot,'g');
  end
  hold off; 
  xlim(X);
  ylim(Y);
  set(gca, 'YDir', 'normal');
  set(gca, 'Clim', [1000, 3000]);
  title(['aliasing frequency', plottitle]);
  
  %% gnuplot
  gp_save_matrix([prefix '_P.dat'], x, y, P./abs(g));
  gp_save_matrix([prefix '_fS.dat'], x, y, fS);
  gp_save_loudspeakers([prefix '_x0.txt'], x0);
  gp_save([prefix '_xc.txt'], xc);

  xplot = Rc*cosd(phiplot) + xc(1);
  yplot = Rc*sind(phiplot) + xc(2);
  gp_save([prefix '_circle.txt'], [xplot, yplot]);  
end


