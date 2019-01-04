function nonsmooth_soundfields(conf)

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

%% ===== Variables =============================================================
rs = conf.rs;
phis = conf.phis;
f = conf.frequency;
xs = rs*[cosd(phis), sind(phis), 0];
if strcmp(conf.dimension,'2D')
  src = 'ls';
else
  src = 'ps';
end

X = [-2.5,2.5];
Y = [-2.5,2.5];
Z = 0;
%% ===== Computation ===========================================================
% select method and compute
switch conf.method
  case 'gt'
    [P,x,y] = sound_field_mono(X,Y,Z,[xs, 1 0 0, 1],src,1,f,conf);    
  case 'esa-rect'
    [P,x,y] = sound_field_mono_esa_rect(X,Y,Z,xs,src,f,conf);
  case 'wfs'
    [P,x,y] = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
  case 'lwfs'
    [P,x,y] = sound_field_mono_localwfs(X,Y,Z,xs,src,f,conf);
  otherwise
    error('%s: unknown sfs method (%s)', upper(mfilename), conf.method);
end
Pref = sound_field_mono(0,0,0,[xs, 1 0 0, 1],src,1,f,conf);

%% ===== Plotting + GNUplot ====================================================
filename = eval_filename(conf);  % filename

x0 = secondary_source_positions(conf);
plot_sound_field(P./abs(Pref),X,Y,Z,x0,conf);
% focused sources
if strcmp(conf.method, 'lwfs')
  hold on;
  xv = virtual_secondary_source_positions(x0, xs, src, conf);
  draw_loudspeakers(xv, [1 1 0], conf);
  hold off;
end
title(filename, 'Interpreter', 'none');

% gnuplot
gp_save_matrix([filename '_real.dat'],x,y,real(P)./abs(Pref));
gp_save_matrix([filename '_db.dat'],x,y,db(P));
gp_save_loudspeakers('array.txt',x0);
if strcmp(conf.method, 'lwfs')
  xv = [xv; xv(1,:)];
  gp_save_loudspeakers([filename '_array.txt'],xv);
end

end