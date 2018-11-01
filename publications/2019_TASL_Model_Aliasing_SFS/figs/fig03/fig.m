% comparison of aliasing components and their SPA for monochromatic point source

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

SFS_start;
addpath('../../matlab');
%% Parameters
conf = SFS_config;

conf.secondary_sources.geometry = 'linear';
conf.secondary_sources.size = 129;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 2048;

conf.xref = [0,1,0];

xref = conf.xref;

X = [-2, 2];
Y = [-1.0, 3];
Z = 0;

src = 'ps';
xs = [0, -1, 0];
f = 1500;
k = 2*pi*f/conf.c;

x0SPA = [-0.50, 0, 0, 0, 1, 0, 1];

deltax = 0.5;

x0rays = [
    -1.75, 0, 0, 0, 1, 0, deltax 
    -1.50, 0, 0, 0, 1, 0, deltax 
    -1.25, 0, 0, 0, 1, 0, deltax 
    -1.00, 0, 0, 0, 1, 0, deltax 
    -0.75, 0, 0, 0, 1, 0, deltax 
    -0.25, 0, 0, 0, 1, 0, deltax 
     0.00, 0, 0, 0, 1, 0, deltax
    +0.25, 0, 0, 0, 1, 0, deltax 
    +0.50, 0, 0, 0, 1, 0, deltax
    +0.75, 0, 0, 0, 1, 0, deltax
    +1.00, 0, 0, 0, 1, 0, deltax
    +1.25, 0, 0, 0, 1, 0, deltax
    +1.50, 0, 0, 0, 1, 0, deltax
    +1.75, 0, 0, 0, 1, 0, deltax
    ];

for eta = [0, 1, 2, 3]
    
    %% sound field
    % normalisation factor
    g = abs(sound_field_mono_point_source(xref(1),xref(2),xref(3),xs,f,conf));
    
    % virtual source
    S = sound_field_mono_point_source(X,Y,Z,xs,f,conf);
    
    % synthesised sound field
    x0 = secondary_source_positions(conf);
    x0(:,4:6) = -x0(:,4:6);  % let the array point into positive y-direction
    x0 = secondary_source_selection(x0,xs,src);
    D = driving_function_mono_wfs(x0,xs,src,f,conf);
    D = D.*exp(-1j*2*pi*eta*x0(:,1)./deltax);    
    P = sound_field_mono(X,Y,Z,x0,'ps',D,f,conf);
    
    % SPA of synthesised sound field
    DSPA = driving_function_mono_wfs(x0SPA,xs,src,f,conf);
    DSPA = DSPA.*exp(-1j*2*pi*eta*x0SPA(:,1)./deltax);    
    [PSPA,x,y] = sound_field_mono(X,Y,Z,x0SPA,'ps',DSPA,f,conf);
    
    y0s = x0SPA(2)-xs(2);
    r0s = vector_norm(x0SPA(1:2)-xs(1:2),2);
    y0 = x0SPA(2)-y;
    r0 = sqrt((x0SPA(1)-x).^2 + y0.^2);
    weight = sqrt(-1j*2*pi./(k*(y0s.^2./r0s.^3 + y0.^2./r0.^3)));
    PSPA = PSPA.*weight;
    
    %% rays
    w = 0:0.1:10;
    kvec = local_wavenumber_vector(x0rays(:,1:3),xs,src);
    kvec = local_aliasing_vector(kvec,x0rays(:,4:6),x0rays(:,7),k,eta);
    
    kvecSPA = local_wavenumber_vector(x0SPA(:,1:3),xs,src);
    kvecSPA = local_aliasing_vector(kvecSPA,x0SPA(:,4:6),deltax,k,eta);
    
    % rays for x0rays
    rays = zeros(2*size(x0rays,1),length(w));
    rays(1:2:end,:) = bsxfun(@plus, x0rays(:,1), kvec(:,1)*w);
    rays(2:2:end,:) = bsxfun(@plus, x0rays(:,2), kvec(:,2)*w);
    
    % rays for x0SPA
    raysSPA = [];
    raysSPA(1,:) = bsxfun(@plus, x0SPA(:,1), kvecSPA(:,1)*w);
    raysSPA(2,:) = bsxfun(@plus, x0SPA(:,2), kvecSPA(:,2)*w);
    
    %% secondary sources
    select = isnan(kvec(:,1));
    x0rays_active = x0rays(~select,:);
    x0rays_inactive = x0rays(select,:);
    
    %% plot
    conf.plot.usedb = false;
    plot_sound_field(P./abs(g),X,Y,Z,[],conf);
    hold on;
    plot(rays(1:2:end,:).', rays(2:2:end,:).', 'c');
    plot(x0rays_active(:,1), x0rays_active(:,2), 'c*');
    plot(x0rays_inactive(:,1), x0rays_inactive(:,2), 'y*');
    plot(raysSPA(1:2:end,:).', raysSPA(2:2:end,:).', 'g');
    plot(raysSPA(1:2:end,1).', raysSPA(2:2:end,1).', 'g*');
    plot(x0(:,1), x0(:,2), 'k');
    hold off;
    xlim(X);
    ylim(Y);
    title(sprintf('%dth aliasing component of synthesises sound field', eta));
    
    conf.plot.usedb = true;
    plot_sound_field(PSPA./P-1,X,Y,Z,[],conf);
    hold on;
    plot(raysSPA(1:2:end,:).', raysSPA(2:2:end,:).', 'g');
    plot(raysSPA(1:2:end,1).', raysSPA(2:2:end,1).', 'g*');
    plot(x0(:,1), x0(:,2), 'k');
    hold off;
    xlim(X);
    ylim(Y);
    title(sprintf('error between %dth aliasing component and its SPA', eta));
    
    %% gnuplot
    datastring = sprintf('eta%d_', eta);
    
    gp_save_matrix([datastring 'S.dat'],x,y,real(S)./abs(g));
    gp_save_matrix([datastring 'P.dat'],x,y,real(P)./abs(g));
    gp_save_matrix([datastring 'PSPA.dat'],x,y,real(PSPA)./abs(g));
    gp_save_matrix([datastring 'error.dat'],x,y,db(PSPA./P-1));
    
    gp_save([datastring 'rays.txt'], rays.');
    gp_save([datastring 'raysSPA.txt'], raysSPA.')
    
    gp_save_loudspeakers([datastring 'x0SPA.txt'], x0SPA);
    gp_save_loudspeakers([datastring 'x0rays_active.txt'], x0rays_active);
    gp_save_loudspeakers([datastring 'x0rays_inactive.txt'], x0rays_inactive );
    gp_save_loudspeakers([datastring 'array.txt'], x0);    
end
