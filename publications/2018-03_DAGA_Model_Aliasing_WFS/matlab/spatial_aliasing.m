function spatial_aliasing(conf)

%*****************************************************************************
% Copyright (c) 2013-2019 Fiete Winter                                       *
%                         Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
%                                                                            *
% This file is part of the supplementary material for Fiete Winter's         *
% scientific work and publications                                           *
%                                                                            *
% You can redistribute the material and/or modify it  under the terms of the *
% GNU  General  Public  License as published by the Free Software Foundation *
% , either version 3 of the License,  or (at your option) any later version. *
%                                                                            *
% This Material is distributed in the hope that it will be useful, but       *
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
% or FITNESS FOR A PARTICULAR PURPOSE.                                       *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy of the GNU General Public License along   *
% with this program. If not, see <http://www.gnu.org/licenses/>.             *
%                                                                            *
% http://github.com/fietew/publications           fiete.winter@uni-rostock.de*
%*****************************************************************************

src = conf.src;
xs = conf.xs;
f = conf.f;
k = 2*pi*f./conf.c;
eta = conf.eta;

%% Local Wave Vector

switch conf.secondary_sources.geometry
  case 'linear'
    N0 = 129;
    L = 64;
    X0 = [0, 0, 0];
    
    % SSD
    conf.secondary_sources.number = N0;
    conf.secondary_sources.size = L;
    conf.secondary_sources.center = X0;
    
    tmpconf = conf;
    tmpconf.secondary_sources.grid = 'equally_spaced_points';
    x0 = secondary_source_positions(tmpconf);
    x0(:,4:6) = -x0(:,4:6);  % SSD point towards +y-direction
    
    switch conf.secondary_sources.grid
      case 'equally_spaced_points'
        dx = L./(N0-1);
      case 'logarithmic'
        q = 2;
        u0 = N0/2.*log(q)./log(L/2+1);
        dx = (abs(x0(:,1)-X0(1))+1).*log(q)./u0;
    end
    
    conf.xref = [0, 1, 0];
    X = [-4, 4];
    Y = [-4, 4];
    Z = 0;
end
x0 = secondary_source_selection(x0,xs,src);

kvec = local_wave_vector(x0(:,1:3),xs,src);
kSeta = local_aliasing_vector(kvec,x0(:,4:6),dx,k,eta);

w = 0:0.1:10;
xSeta = zeros(2*size(x0,1),length(w));
xSeta(1:2:end,:) = bsxfun(@plus, x0(:,1), kSeta(:,1)*w);
xSeta(2:2:end,:) = bsxfun(@plus, x0(:,2), kSeta(:,2)*w);

lambdaSeta = dx./abs(eta).*(1-sign(eta)*kvec(:,1));
lambda = ones(size(lambdaSeta)).*2.*pi./k;

%% Sound Field Simulations
tmp = conf.plot.useplot;
conf.plot.useplot = false;
x0S = secondary_source_positions(conf);
DS = driving_function_mono_wfs(x0S,xs,src,f,conf);
[PS,x,y] = sound_field_mono(X,Y,Z,x0S,'ps',DS,f,conf);
conf.plot.useplot = tmp;

%% Sound Field Simulations with dense SSD for aliasing-free calculations

% densely sampled SSD for aliasing-free calculations
refconf = conf;
refconf.secondary_sources.number = 2048;
x0ref = secondary_source_positions(refconf);
switch conf.secondary_sources.geometry
  case 'linear'
    x0ref(:,4:6) = -x0ref(:,4:6);
end
x0ref = secondary_source_selection(x0ref,xs,src);

% driving functions
D = driving_function_mono_wfs(x0ref,xs,src,f,conf);

% spectral repetition of driving function (aliasing)
u = linspace(-N0/2,N0/2,refconf.secondary_sources.number).';
du = N0/(N0-1);
DSeta = D.*exp(-1j*2*pi*eta*u./du);

% normalisation factor for gnuplot
tmp = conf.plot.useplot;
conf.plot.useplot = false;
xref = conf.xref;
switch src
  case 'pw'
    g = sound_field_mono_plane_wave(xref(1),xref(2),xref(3),xs,f,conf);
  case 'ps'
    g = sound_field_mono_point_source(xref(1),xref(2),xref(3),xs,f,conf);
end
conf.plot.useplot = tmp;

% sound field
PSeta = sound_field_mono(X,Y,Z,x0ref,'ps',DSeta,f,conf);
plot_sound_field(PSeta./g,X,Y,Z,x0ref,conf);
hold on
plot(xSeta(1:2:end,:).', xSeta(2:2:end,:).', 'r');
hold off
xlim(X);
ylim(Y);
title(evalGenerateFilename(conf), 'Interpreter', 'None');

%% Ground Truth Sound Field
% Sound Pressure
Xgt = [-4 4];
Ygt = [-4 0];
Zgt = 0;
switch src
  case 'pw'
    [Pgt,xgt,ygt] = sound_field_mono_plane_wave(Xgt,Ygt,Zgt,xs,f,conf);
  case 'ps'
    [Pgt,xgt,ygt] = sound_field_mono_point_source(Xgt,Ygt,Zgt,xs,f,conf);
end
% Local Wave Vector
conf.resolution = 30;
[xk,yk] = xyz_grid(X,Y,Z,conf);
xk = [xk(:),yk(:)];
xk(:,3) = Z;
kgt = local_wave_vector(xk, xs, src);

%% gnuplot
prefix = evalGenerateFilename(conf);

gp_save_matrix([prefix '_PSeta.dat'],x,y,real(PSeta./g));
gp_save_matrix([prefix '_PS.dat'],x,y,real(PS./g));
gp_save([prefix '_xSeta.txt'], xSeta.');
gp_save([prefix '_lambdaSeta.txt'], [x0(:,1:2), lambdaSeta]);
gp_save([prefix '_lambda.txt'], [x0(:,1:2), lambda]);
gp_save_loudspeakers([prefix '_x0al.txt'], x0);
gp_save_loudspeakers([prefix '_x0on.txt'],  x0(~isnan(kSeta(:,1)),:));
gp_save_loudspeakers([prefix '_x0off.txt'], x0( isnan(kSeta(:,1)),:));
gp_save_loudspeakers([prefix '_x0S.txt'], x0S);

% ground truth
gp_save_matrix([prefix, '_Pgt.dat'],xgt,ygt,real(Pgt./g));
gp_save([prefix, '_kgt.txt'],[xk,kgt]);

