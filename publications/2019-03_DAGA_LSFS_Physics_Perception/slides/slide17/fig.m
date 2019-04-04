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

conf.plot.usenormalisation = true;
conf.plot.normalisation = 'center';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;

R = conf.secondary_sources.size/2.0;
Lref = 2^15;
L = 56;
Mvec = 0:120;
Rl = 0.25;
xps = [0 2.5 0];
[phips, rps] = cart2pol(xps(1), xps(2));
xvec = [
  +0.25, 0, 0
   -0.35,0.75,0
].';

%% Frequencies
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0gt = secondary_source_positions(conf);
x0gt = secondary_source_selection(x0gt,xps,'ps');  % a_S(x0) >= 0
x0gt(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0gt
kSx0gt = local_wavenumber_vector(x0gt(:,1:3), xps, 'ps');

fSwfs = zeros(2,size(xvec,2));
fMwfs = fSwfs;
[fShoa, fMhoa, fSlwfs, fMlwfs] = deal(zeros(length(Mvec), size(xvec,2)));

xdx = 1;
for pos = xvec
  xl = pos.';
  
  % circular area with radius Rl
  minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,Rl);
  
  % WFS
  fSwfs(:,xdx) = aliasing_extended(x0gt,kSx0gt,xl,minmax_kGt_fun,conf);
  fMwfs(1,xdx) = 30000;
  fMwfs(2,xdx) = 200;
  
  mdx = 1;
  for M = Mvec
    % NFCHOA
    fShoa(mdx,xdx) = aliasing_extended_modal(x0gt,kSx0gt,xl,minmax_kGt_fun, [0,0,0], M, conf);

    % distance between xl and the line x0 + w*k_P(x0)       
    dlx0 = vector_norm(cross(bsxfun(@minus, xl, x0gt(:,1:3)),kSx0gt,2),2);
    % remove all x0, which do not contribute to the listening area
    select = dlx0 <= Rl;
    
    dcx0 = vector_norm(cross(x0gt(select,1:3),kSx0gt(select,:),2),2);
    fMhoa(mdx,xdx) = min( M.*conf.c./(2.*pi.*dcx0) );
    
    % LWFS
    fSlwfs(mdx,xdx) = aliasing_extended_modal(x0gt,kSx0gt,xl,minmax_kGt_fun, xl, M, conf);
    fMlwfs(mdx,xdx) = M*conf.c/(2*pi*Rl);
    
    mdx = mdx + 1;
  end
  xdx = xdx + 1;
end

gp_save('wfs.txt', [fSwfs,fMwfs]);
gp_save('hoa.txt', [fShoa,fMhoa]);
gp_save('lwfs.txt', [fSlwfs,fMlwfs]);

%% SSD
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);

%%
phiplot = (0:360).';
xplot = [cosd(phiplot), sind(phiplot)];

pos1 = [xvec(1,1) + Rl*cosd(phiplot), xvec(2,1) + Rl*sind(phiplot)];
pos2 = [xvec(1,2) + Rl*cosd(phiplot), xvec(2,2) + Rl*sind(phiplot)];

gp_save('pos1.txt',pos1);
gp_save('pos2.txt',pos2);
