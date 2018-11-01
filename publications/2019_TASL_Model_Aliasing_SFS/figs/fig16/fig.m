%

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

conf = SFS_config;

conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;

xs = [0,2.5,0];
src = 'ps';

Lref = 2^16;
L = 56;
R = conf.secondary_sources.size/2;
Rl = 0.085;
Mvec = [0:0.1:90, 100];

x = -1.0:0.5:0;
y = -0.75:0.75:0.75;
[y,x] = meshgrid(y,x);
x = x(:);
x = [x; 0];
y = y(:);
y = [y; 1.25];

%% Aliasing Frequency for different xl==xc and M
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);  % a_S(x0) >= 0
x0(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0
kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);

% evaluation points x
xvec = [x(:), y(:)];
xvec(:,3) = 0;
xl = xvec;

% aliasing frequency at x for M
minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,Rl);
fS = zeros(size(Mvec,2), size(xvec,1));

for xdx = 1:size(xvec,1)
    xl = xvec(xdx,:);
    xc = xvec(xdx,:);
    
    mdx = 0;
    for M = Mvec;
        mdx = mdx + 1;
        
        fS(mdx,xdx) = aliasing_extended_modal(x0, kSx0, xl, minmax_kGt_fun, xc, M, conf);
    end
end

% plotting
figure;
plot(Mvec,fS.');
set(gca, 'ColorOrderIndex', 1);
xlim([1,100]);
ylim([1000,20000]);
xlabel('M');
ylabel('f^S / Hz');

% gnuplot
gp_save('fS.txt',[Mvec.',fS]);
gp_save('pos.txt', [x,y]);

%% Aliasing Frequency near Rl=Rc

% RSr = M/kS
RSr = bsxfun(@rdivide, Mvec.', 2*pi*fS./conf.c);
% find M for which RSr which is very close to Rl
[~, mdx] = min(abs(RSr - Rl), [],1);
MSr = Mvec(mdx);
% calculate frequency correspoding to kR == M
fSr = MSr./(2*pi.*Rl)*conf.c;
% gnuplot
gp_save('fSr.txt', [MSr; fSr].');

gS = fSr./fS(end,:)

%% Radius caused by Modal Bandwidth limitation
f = logspace(0,6,100);
Ml = 2.*pi.*f.*Rl/conf.c;

gp_save('Ml.txt',[f; Ml].');

%% SSD
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);
