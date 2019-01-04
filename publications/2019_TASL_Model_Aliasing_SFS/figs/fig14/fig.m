%

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

addpath('../../matlab');
SFS_start;

conf = SFS_config;

conf.plot.usenormalisation = false;
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;
conf.xref = [0,0,0];

Lref = 2048;
L = 56;
Lvec = [36, 896];
R = conf.secondary_sources.size/2;
xs = [0 2.5 0];
[phis, rs] = cart2pol(xs(1),xs(2));
phic = acos(R/rs);  % active part of SSD
src = 'ps';
srcgt = 'ps';
f = 2000;
xref = conf.xref;

% evaluation points x
X = [-2, 2];
Y = [-2, 2];
Z = 0;
[x,y,~] = xyz_grid(X,Y,Z,conf);
xvec = [x(:), y(:)];
xvec(:,3) = 0;

for Lu = Lvec
    filesuffix = sprintf('_L%d.dat', Lu);

    % find parameter for exponential sampling
    fun = @(mue) phic/pi - (exp(mue.*phic./pi.*L/Lu)-1)/(exp(mue)-1);
    [mu, fval, exitflag] = fzero(fun, [-100, 100]);
    mu

    %% Aliasing Frequency
    
    % secondary sources
    u = 2*pi*(0:Lref-1).'/Lref - pi;
    if mu == 0
      phi0 = u + phis;
      phi0prime = 1;
    else
      phi0 = pi.*sign(u).*(exp(mu.*abs(u/pi))-1)./(exp(mu)-1) + phis;
      phi0prime = exp(mu.*abs(u/pi))./(exp(mu)-1).*mu;
    end

    x0ref = [];
    x0ref(:,1) = R*cos(phi0);
    x0ref(:,2) = R*sin(phi0);
    x0ref(:,3) = 0;
    x0ref(:,4) = -cos(phi0);
    x0ref(:,5) = -sin(phi0);
    x0ref(:,6) = 0;
    x0ref(:,7) = 2*pi*R./Lu.*phi0prime;  % sampling distance deltax0

    x0ref = secondary_source_selection(x0ref,xs,src);    
    
    % local wavenumber of virtual sound field at x0
    kS = local_wavenumber_vector(x0ref(:,1:3), xs, src);

    % aliasing frequency at x
    fS = aliasing(x0ref,kS,xvec,conf);
    fS = reshape(fS, size(x));    
    
    %% Sound Fields
    
    % secondary sources
    u = 2*pi*(0:Lu-1).'/Lu - pi;
    if mu == 0
      phi0 = u + phis;
      phi0prime = 1;
    else
      phi0 = pi.*sign(u).*(exp(mu.*abs(u/pi))-1)./(exp(mu)-1) + phis;
      phi0prime = exp(mu.*abs(u/pi))./(exp(mu)-1).*mu;
    end
    
    x0plot = [];
    x0plot(:,1) = R*cos(phi0);
    x0plot(:,2) = R*sin(phi0);
    x0plot(:,3) = 0;
    x0plot(:,4) = -cos(phi0);
    x0plot(:,5) = -sin(phi0);
    x0plot(:,6) = 0;
    x0plot(:,7) = 2*pi*R./Lu.*phi0prime;  % sampling distance deltax0
    
    x0 = secondary_source_selection(x0plot,xs,src);

    % normalisaton factor
    g = sound_field_mono(xref(1), xref(2), xref(3), [xs, 0, 1, 0, 1], srcgt,...
      1, f, conf);
    
    % synthesises sound field
    D = driving_function_mono_wfs(x0,xs,src,f,conf);
    P = sound_field_mono(X,Y,Z,x0,'ps',D,f,conf);
    P = P./abs(g);
        
    % ground truth sound field
    conf.secondary_sources.number = Lref;
    Pgt = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
    Pgt = Pgt./abs(g);

    % error
    eps = db((P-Pgt)./Pgt);
    
    %% Plotting
    figure;
    imagesc(X,Y,fS)
    set(gca, 'YDir', 'normal');
    set(gca, 'Clim', [1000, 4000]);
    hold on;
    contour(x,y,fS,[1000, 1500, 2000, 2500, 3000],'r-','ShowText','on');
    draw_loudspeakers(x0plot,[1 1 0], conf);
    hold off;
    title('aliasing frequency');
    
    conf.plot.usedb = false;
    plot_sound_field(P,X,Y,Z,x0plot,conf);
    title('sound field synthesised by discrete SSD');

    conf.plot.usedb = true;
    plot_sound_field(P./Pgt-1,X,Y,Z,x0plot,conf);
    title('error between synthesised sound fields of discrete and continuous SSD');
    
    %% Gnuplot
    gp_save_matrix(['fS' filesuffix],x,y,fS);
    
    gp_save_matrix(['P' filesuffix], x, y, real(P));
    gp_save_matrix(['Pgt' filesuffix], x, y, real(Pgt));
    gp_save_matrix(['eps' filesuffix], x, y, eps);
    
    gp_save_loudspeakers(['array' filesuffix], x0plot);
end