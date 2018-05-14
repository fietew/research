function nonsmooth_driving_functions(conf)

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
for idx=1:numel(phis)
  xs = rs*[cosd(phis(idx)), sind(phis(idx)), 0];
  [Dtmp, sdx] = sfs(xs);
  D(sdx,idx) = Dtmp;
end

%% ===== Plotting ========================================================
filename = eval_filename(conf);

gp_save_matrix([filename '.dat'],phis,(1:size(x0,1))',db(D));

figure;
imagesc([phis(1),phis(end)], [1,size(x0,1)], db(D));
set(gca, 'CLim', [-60, 0]);
title(filename, 'Interpreter', 'none');

end