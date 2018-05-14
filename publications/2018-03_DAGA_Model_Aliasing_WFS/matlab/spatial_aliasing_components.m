function spatial_aliasing_components(conf)

%*****************************************************************************
% Copyright (c) 2013-2018 Fiete Winter                                       *
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
k = 2*pi*f/conf.c;
eta = conf.eta;
X = conf.X;
Y = conf.Y;
Z = conf.Z;
N0 = conf.secondary_sources.number;
method = conf.method;
N0ref = 2048;
idSPA = conf.idSPA;

%%
switch conf.secondary_sources.geometry
    case {'circle', 'circular'}
        u = (0:N0ref-1)/N0ref*2*pi;  
        du = 2*pi./N0;
        uSPA = (idSPA-1);
    case {'linear', 'line'}
        L = conf.secondary_sources.size;
        u = linspace(L/2,-L/2,N0ref).';
        du = L./(N0-1);
        uSPA = (N0-1)/2-(idSPA-1);
    otherwise
        error('%s: SSD geometry (%s) not supported', upper(mfilename), ...
            conf.secondary_sources.geometry);
end
x0 = secondary_source_positions(conf);
x0SPA = x0(idSPA,:);
x0SPA(:,7) = 1;

refconf = conf;
refconf.secondary_sources.number = N0ref;
x0 = secondary_source_positions(refconf);
switch method
    case 'wfs'
        [~,xdx] = secondary_source_selection(x0,xs,src);
        D = zeros(N0ref,1);
        D(xdx,:) = driving_function_mono_wfs(x0(xdx,:),xs,src,f,conf);
    case 'nfchoa'
        D = driving_function_mono_nfchoa(x0,xs,src,f,conf);
    case 'lwfs-sbl'
        D = driving_function_mono_localwfs(x0,xs,src,f,conf);
end

% spectral repetition of driving function (aliasing)
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

% sound field
[PSeta,x,y] = sound_field_mono(X,Y,Z,x0,'ps',DSeta,f,conf);
conf.plot.useplot = tmp;
plot_sound_field(PSeta./g,X,Y,Z,conf);
xlim(X);
ylim(Y);
title(evalGenerateFilename(conf), 'Interpreter', 'None');

% stationary phase approximation of reproduced sound field at x0approx
DSetaSPA = driving_function_mono_wfs(x0SPA,xs,src,f,conf);
DSetaSPA = DSetaSPA.*exp(-1j*2*pi*eta*uSPA);
PSetaSPA = sound_field_mono(X,Y,Z,x0SPA,'ps',DSetaSPA,f,conf);

y0s = x0SPA(2)-xs(2);
r0s = vector_norm(x0SPA(1:2)-xs(1:2),2);
y0 = x0SPA(2)-y;
r0 = sqrt((x0SPA(1)-x).^2 + y0.^2);
weight = sqrt(-1j*2*pi./(k*(y0s.^2./r0s.^3 + y0.^2./r0.^3)));
PSetaSPA = PSetaSPA.*weight;

%% gnuplot
prefix = evalGenerateFilename(conf);

gp_save_matrix([prefix '_PS.dat'],x,y,imag(PSeta./g));
gp_save_matrix([prefix '_PSSPA.dat'],x,y,imag(PSetaSPA./g));
gp_save_matrix([prefix '_PSerror.dat'],x,y,abs(PSetaSPA./PSeta-1));

