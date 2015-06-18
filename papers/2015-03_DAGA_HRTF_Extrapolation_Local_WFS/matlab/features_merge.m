function features_merge(regular_expression)

%*****************************************************************************
% Copyright (c) 2015      Fiete Winter                                       *
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

files = dir(regular_expression);
if isempty(files)
  warning('not file found matching "%s"', regular_expression);
  return;
end

%
load(files(1).name, 'tfs');
tfs_merge = tfs;
fields = fieldnames(tfs_merge);

%
for idx=2:length(files)
  load(files(idx).name, 'tfs');

  for kdx=1:length(fields)
    tfs_merge.(fields{kdx}) = [tfs_merge.(fields{kdx}), tfs.(fields{kdx})];
  end
end

% sort entries
[~, idx] = sort(tfs_merge.Nl, 2);
[~, jdx] = sort(tfs_merge.Rl(idx), 2);
idx = idx(jdx);
[~, jdx] = sort(tfs_merge.apparent_azimuth(idx), 2);
idx = idx(jdx);

for kdx=1:length(fields)
  tmp = tfs_merge.(fields{kdx});
  tfs_merge.(fields{kdx}) = tmp(:,idx);
end

%% Save File
k = strfind(regular_expression, '*');
regular_expression(k) = [];
tfs = tfs_merge;
save(regular_expression, 'tfs');
