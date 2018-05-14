function nonsmooth_amplitude(conf)

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

%% ===== Variables =============================================================
rs = conf.rs;
phis = conf.phis;
f = conf.frequency;
if strcmp(conf.dimension,'2D')
  src = 'ls';
else
  src = 'ps';
end

X = conf.xref(1);
Y = conf.xref(2);
Z = conf.xref(3);
%% ===== Computation ===========================================================

% select method
switch conf.method
  case 'gt'
    sfs = @(xs) sound_field_mono(X,Y,Z,[xs, 1 0 0, 1],src,1,f,conf);
  case 'esa-rect'
    sfs = @(xs) sound_field_mono_esa_rect(X,Y,Z,xs,src,f,conf);
  case 'wfs'
    sfs = @(xs) sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
  case 'lwfs'
    sfs = @(xs) sound_field_mono_localwfs(X,Y,Z,xs,src,f,conf);   
  otherwise
    error('%s: unknown sfs method (%s)', upper(mfilename), conf.method);
end
% compute soundfield
P = zeros(size(phis));
for idx=1:numel(phis)
  xs = rs*[cosd(phis(idx)), sind(phis(idx)), 0];
  P(idx) = sfs(xs);
end
Pref = sound_field_mono(X,Y,Z,[xs, 1 0 0, 1],src,1,f,conf);

%% ===== Plotting + GNUplot ====================================================
filename = eval_filename(conf);  % filename
filename = sprintf('%s_f%.0f.txt', filename, conf.frequency);
% gnuplot
gp_save(filename, [phis.', db(P./Pref).']);
end