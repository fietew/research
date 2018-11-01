% comparison of aliasing model of Donley and current approach

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
clear variables;

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

RcVec = ([0:0.01:0.5 0.6:0.1:2*R])+0.01;
Rl = 0.25;
xc = [-0.9,   0, 0];
xl = [ 0.5,-0.75, 0];
conf.xref = xc;

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;


%% Aliasing Frequencies
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);  % a_S(x0) >= 0
x0(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0
kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);

% 
minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,Rl);
% the old aliasing model only considers the centre line of the main lobe
minmax_kSt_fun_old = @(x0p) minmax_kt_circle(x0p,xc,0.01);

fS = zeros(size(RcVec));
fSdonley = fS;
rdx = 0;
for Rc = RcVec
  rdx = rdx+1;
  
  % the old aliasing assumes, that the grating lobe has a width of Rc
  % the aliasing frequency is reached if the distance between xl and the center
  % line is (Rl + Rc)
  minmax_kGt_fun_old = @(x0p,xp) minmax_kt_circle(x0p,xp,Rl+Rc);
  
  % 
  minmax_kSt_fun = @(x0p) minmax_kt_circle(x0p,xc,Rc);
  
  fS(rdx)    = aliasing_extended_control(x0, kSx0, xl, minmax_kGt_fun, minmax_kSt_fun, conf);
  fSdonley(rdx) = aliasing_extended_control(x0, kSx0, xl, minmax_kGt_fun_old, minmax_kSt_fun_old, conf);
end

%% plot 
figure;
plot(RcVec, fS, RcVec, fSdonley);
title('estimated aliasing frequencies');
legend('current approach', 'approach of Donley et al.');
xlabel('R_c');
ylabel('f^S');
axis tight

%% gnuplot
gp_save('fS.txt', [RcVec; fSdonley; fS].');

