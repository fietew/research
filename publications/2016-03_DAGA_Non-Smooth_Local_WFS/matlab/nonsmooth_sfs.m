function nonsmooth_sfs(conf)

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

%% ===== Variables =======================================================
rs = conf.rs;
phis = conf.phis;
f = conf.frequency;
if strcmp(conf.dimension,'2D')
  src = 'ls';
else
  src = 'ps';
end

X = 0;
Y = 0;
Z = 0;
%% ===== Computation of shifted driving function =========================

% secondary source distribution
x0 = secondary_source_positions(conf);
% select method
switch conf.method
  case 'esa-rect'
    sfs = @(xs) esa_helper(x0,xs,src,f,conf);
  case 'wfs'
    sfs = @(xs) wfs_helper(x0, xs, src, f, conf);
  case 'lwfs'
    sfs = @(xs) localwfs_helper(x0, xs, src, f, conf);    
  otherwise
    error('%s: unknown sfs method (%s)', upper(mfilename), conf.method);
end

D = zeros(size(x0,1), size(phis,2));
P = zeros(size(phis));
Pgt = P;
for idx=1:numel(phis)
  xs = rs*[cosd(phis(idx)), sind(phis(idx)), 0];
  [Dtmp, sdx] = sfs(xs);
  D(sdx,idx) = Dtmp;
  P(idx) = sound_field_mono(X,Y,Z,x0, src, D(:,idx), f, conf);
  Pgt(idx) = sound_field_mono(X,Y,Z,[xs,1,0,0,1], src, 1, f, conf);
end
P = db(P);
Pgt = db(Pgt);

%% ===== Plotting ========================================================
tstring = conf.method;
if strcmp(conf.method, 'lwfs')
  tstring = sprintf('%s %2.2f %2.2f', tstring, conf.localsfs.vss.size, ...
    conf.localsfs.vss.corner_radius);
end

figure;
plot(phis, P, 'r', phis, Pgt, 'b-');
ylim([-15, 15]+Pgt(1));
xlim([phis(1),phis(end)]);
title(tstring);

figure;
imagesc([phis(1),phis(end)], [1,size(x0,1)], abs(D));
title(tstring);

end
%% Helper functions
function [D, idx] = localwfs_helper(x0, xs, src, f, conf)    
    [D, ~, ~, idx] = driving_function_mono_localwfs(x0,xs,src,f,conf);
end
function [D, idx] = wfs_helper(x0, xs, src, f, conf)
    [x0, idx] = secondary_source_selection(x0,xs,src);
    x0 = secondary_source_tapering(x0,conf);
    D = driving_function_mono_wfs(x0,xs,src,f,conf);
end
function [D, idx] = esa_helper(x0, xs, src, f, conf)
    idx = true(size(x0,1),1);
    D = driving_function_mono_esa_rect(x0,xs,src,f,conf);
end
