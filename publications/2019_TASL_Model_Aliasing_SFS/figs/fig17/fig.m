% comparison of old and new aliasing model

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

addpath('../../matlab');
SFS_start;

close all;
clear all;

conf = SFS_config;

conf.plot.usenormalisation = 0;
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;

% conf.modal_window = 'max-rE';
conf.localwfs_sbl.Npw = 1024;
conf.localwfs_sbl.fc = 500;

xs = [0,-1,0];
src = 'pw';

Lref = 2^16;
L = 56;
R = conf.secondary_sources.size/2;
f = 2500;
k = 2*pi*f./conf.c;

Rl = 0.25;
xc = [-0.9,   0, 0];
xl = [ 0.5,-0.75, 0];
conf.xref = xc;

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

gp_save('xc.txt',xc);  % gnuplot

phiplot = (0:1:360).';
Rlplot = [xl(1)+Rl.*cosd(phiplot), xl(2)+Rl.*sind(phiplot)];
gp_save('Cl.txt',Rlplot);  % gnuplot
gp_save('xl.txt',xl);  % gnuplot

%% Sound Field
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt', x0);

RcVec = [0.15, 0.5];
for Rc = RcVec
  conf.localwfs_sbl.order = ceil(Rc.*k);
  [P,x,y] = sound_field_mono_localwfs_sbl(X,Y,Z,xs,src,f,conf);
  
  g = sound_field_mono(xc(1),xc(2),xc(3),[xs, 0 -1 0 1], src, 1, f, conf);
  
  % plot twice each to compare new and old aliasing model
  for idx=1:2
    plot_sound_field(P./abs(g),X,Y,Z,[],conf);
    hold on;
    draw_loudspeakers(x0, [1, 1, 0], conf);
    hold off;
  end
  
  % gnuplot
  filename = sprintf('P_Rc%2.2f.dat', Rc);
  gp_save_matrix(filename,x,y,real(P)./abs(g));  
end

%% Aliasing Wavenumber Vectors
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);  % a_S(x0) >= 0
x0(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0
kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);

% variable to plot rays
w = 0:0.1:10;

rdx = 0;
RcVec = [0.15, 0.5];
for Rc = RcVec

    % distance between xc and the line x0 + w*k_S(x0)
    xc0 = bsxfun(@minus, xc, x0(:,1:3));
    nxc0 = cross(xc0,kSx0,2);
    dlx0 = vector_norm(nxc0,2).*sign(nxc0(:,3));
    
    % select secondary source based on control region and sound field
    select = abs(dlx0) <= Rc;
    x0select = x0(select,:);  % all active secondary sources
    
    % get secondary sources at the edges (distance dlx0 should be extremal)
    [~, xdx] = min(dlx0(select));  % mininum distance (can be negative)
    x0edge(1,:) = x0select(xdx,:);  
    [~, xdx] = max(dlx0(select));  % maxium distance
    x0edge(2,:) = x0select(xdx,:);  
    
    % get secondary source for center line (minimal |dlx0|)
    [~, xdx] = min(abs(dlx0(select)));
    x0mid = x0select(xdx,:);
    
    % local wavenumber of virtual sound field (lazy)
    kSx0mid  = local_wavenumber_vector(x0mid(:,1:3), xs, src);
    kSx0edge = local_wavenumber_vector(x0edge(:,1:3), xs, src);
    
    % aliasing wavenumber vector
    kGx0mid  = local_aliasing_vector(kSx0mid, x0mid(:,4:6), x0mid(:,7), k, -1);
    kGx0edge = local_aliasing_vector(kSx0edge, x0edge(:,4:6), x0edge(:,7), k, -1);
    
    % rays for sound field
    vecSmid   = bsxfun(@plus,  x0mid(1,1:2), w.'* kSx0mid(:,1:2));
    vecSedge1 = bsxfun(@plus, x0edge(1,1:2), w.'*kSx0edge(1,1:2));
    vecSedge2 = bsxfun(@plus, x0edge(2,1:2), w.'*kSx0edge(2,1:2));
    % rays for aliasing (old model)
    vecGoldmid   = bsxfun(@plus,  x0mid(1,1:2), w.'* kGx0mid(:,1:2));
    vecGoldedge1 = bsxfun(@plus,  Rc.*[-kGx0mid(:,2),kGx0mid(:,1)], vecGoldmid);
    vecGoldedge2 = bsxfun(@plus, -Rc.*[-kGx0mid(:,2),kGx0mid(:,1)], vecGoldmid);
    % rays for aliasing
    vecGmid   = bsxfun(@plus,  x0mid(1,1:2), w.'* kGx0mid(:,1:2));
    vecGedge1 = bsxfun(@plus, x0edge(1,1:2), w.'*kGx0edge(1,1:2));
    vecGedge2 = bsxfun(@plus, x0edge(2,1:2), w.'*kGx0edge(2,1:2));
    % circle for control region
    Rcplot = [xc(1)+Rc.*cosd(phiplot), xc(2)+Rc.*sind(phiplot)];
    
    %% plot
    rdx = rdx + 1;
    figure(rdx);
    hold on;
    plot(      Rlplot(:,1),       Rlplot(:,2), 'k');
    plot(      Rcplot(:,1),       Rcplot(:,2), 'c');
    plot(     vecSmid(:,1),      vecSmid(:,2), 'c');
    plot(   vecSedge1(:,1),    vecSedge1(:,2), 'c--');
    plot(   vecSedge2(:,1),    vecSedge2(:,2), 'c--');
    plot(  vecGoldmid(:,1),   vecGoldmid(:,2), 'y');
    plot(vecGoldedge1(:,1), vecGoldedge1(:,2), 'y--');
    plot(vecGoldedge2(:,1), vecGoldedge2(:,2), 'y--');
    hold off;
    xlim(X);
    ylim(Y);
    
    rdx = rdx + 1;
    figure(rdx);
    hold on;
    plot(      Rlplot(:,1),       Rlplot(:,2), 'k');
    plot(      Rcplot(:,1),       Rcplot(:,2), 'c');
    plot(     vecSmid(:,1),      vecSmid(:,2), 'c');
    plot(   vecSedge1(:,1),    vecSedge1(:,2), 'c--');
    plot(   vecSedge2(:,1),    vecSedge2(:,2), 'c--');
    plot(     vecGmid(:,1),      vecGmid(:,2), 'm');
    plot(   vecGedge1(:,1),    vecGedge1(:,2), 'm--');
    plot(   vecGedge2(:,1),    vecGedge2(:,2), 'm--');
    hold off;
    xlim(X);
    ylim(Y);
    
    %% gnuplot
    gp_save( sprintf('Cc_Rc%2.2f.txt', Rc), Rcplot );

    gp_save(sprintf('rays_Rc%2.2f.txt', Rc), ...
        [vecSmid, vecSedge1, vecSedge2, ...
         vecGoldmid, vecGoldedge1, vecGoldedge2, ...
         vecGmid, vecGedge1, vecGedge2 ...
        ]);
    
    gp_save_loudspeakers(sprintf('array_select_Rc%2.2f.txt', Rc), x0select);
end
