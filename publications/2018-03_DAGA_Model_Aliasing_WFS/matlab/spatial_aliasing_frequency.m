function spatial_aliasing_frequency(conf)

%*****************************************************************************
% Copyright (c) 2018      Fiete Winter                                       *
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
rl = conf.rl;
rc = conf.rc;
X = conf.X;
Y = conf.Y;
Z = conf.Z;

%%
switch conf.secondary_sources.geometry
    case {'circle', 'circular'}
        delta = conf.secondary_sources.size*pi/conf.secondary_sources.number;
    case {'line', 'linear'}
        delta = conf.secondary_sources.size/(conf.secondary_sources.number-1);
end
tmpconf = conf;
tmpconf.secondary_sources.number = 2048; % densely sampled SSD for calculations
x0full = secondary_source_positions(tmpconf);
x0 = secondary_source_selection(x0full,xs,src);

kPx0 = local_wave_vector(x0(:,1:3),xs,src);  % unit vectors

[x,y,~] = xyz_grid(X,Y,Z,conf);

fal = nan(numel(x), 1);
for xdx = 1:numel(x);
    
    xc = [x(xdx),y(xdx),0];
    xl = xc;
    
    % is xc inside array?
    if any(sum(bsxfun(@minus, xc, x0full(:,1:3)).*x0full(:,4:6),2) < 0)
        continue;
    end
   
    % distance between xc and the line x0 + w*k_P(x0)
    dlx0 = vector_norm(cross(bsxfun(@minus, xc, x0(:,1:3)),kPx0,2),2);
    
    x0select = x0(dlx0 <= rc,:);
    kPx0select = kPx0(dlx0 <= rc,:);
    if isempty(x0select)
       continue; 
    end
    
    [kal1, kal2] = local_aliasing_frequency(kPx0select, x0select, xl, rl, delta);
    
    fal(xdx) = min(min(kal1,kal2))*conf.c./(2*pi);    
end
fal = reshape(fal, size(x,1), size(x,2));

if conf.plot.useplot
    figure;
    imagesc(X,Y,fal);
    title(num2str(rc));
    hold on;
    draw_loudspeakers(x0,[1 1 0], conf);
    hold off;
    xlabel('x_c = x_l');
    ylabel('y_c = y_l');
    set(gca, 'YDir', 'normal');
end

%% gnuplot
prefix = sprintf('%s_s%2.2f_N%d_Rc%2.2f_Rl%2.2f', conf.secondary_sources.geometry, ...
    conf.secondary_sources.size, ...
    conf.secondary_sources.number, ...
    rc, ...
    rl);

gp_save_matrix([prefix '_fal.dat'],x,y,fal);
