function evalEverything(params)
% evaluate localization properties of plane wave decomposition

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

% filename
filename = evalGenerateFilename(params);
  
% compute plane wave decomposition
[P, ~, kpw, ~, ~] = bsPlaneWaveDecomposition(params.source, params);
  
% save pwd to mat-file  
save(fullfile(params.files.basepath, 'pwds', [filename, '.mat']), ...
  'params', ...
  'P', '-v7.3');
  
% adapt angular resolution
P = bsAngularResolution(P, kpw, 360/params.Npw);
  
% evaluate Localization
out = evalLocalization(P, params);

% save results to mat file
save(fullfile(params.files.basepath, 'results', [filename,'.mat']), ...
'params', ...
'out', '-v7.3');

% save results to txt file (gnuplot)
M = eye(3);
tmp_params = params;
for jdx=1:length(params.rot)
    rot = params.rot(jdx);
    M(1:2,1:2) = [cosd(rot), -sind(rot); sind(rot), cosd(rot)];
    tmp_params.source.position = params.source.position*M.';
    filename = evalGenerateFilename(tmp_params);
    gp_save(fullfile(params.files.basepath, 'results', [filename,'.txt']), ...
        [params.shift(:,1:2),out.phi(:,jdx),out.delta(:,jdx)]);
end