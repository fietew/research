function nonsmooth_area(conf)

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
if strcmp(conf.dimension,'2D')
  src = 'ls';
else
  src = 'ps';
end
Rl = conf.localsfs.vss.size/2;

X = conf.xref(1);
Y = conf.xref(2);
Z = conf.xref(3);
%% ===== Computation ===========================================================

% compute soundfield
ratio = 0.0:0.05:1.0;
area = Rl.^2*(4+ratio.^2*(pi-4));
P = zeros(size(phis,2),size(ratio,2));
for jdx=1:numel(ratio)
  conf.localsfs.vss.corner_radius = ratio(jdx)*Rl;
  for idx=1:numel(phis)  
    xs = rs*[cosd(phis(idx)), sind(phis(idx)), 0];    
    P(idx, jdx) = sound_field_mono_localwfs(X,Y,Z,xs,src,f,conf); 
  end
end
Pref = sound_field_mono(X,Y,Z,[xs, 1 0 0, 1],src,1,f,conf);

%% ===== Plotting + GNUplot ====================================================
filename = eval_filename(conf);  % filename
filename = sprintf('%s_f%.0f', filename, conf.frequency);
% gnuplot
gp_save_matrix([filename, '_full.dat'], ratio, phis.', P);
gp_save([filename, '_stats.txt'], [ratio.', min(db(P./Pref),[],1).', db(sqrt(mean(abs(P./Pref).^2,1))).', max(db(P./Pref),[],1).'] );

end