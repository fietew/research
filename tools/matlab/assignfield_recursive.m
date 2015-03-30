function S = assignfield_recursive(S, fieldname, fieldvalue)
% Recursively assigns values to fields of structure
%
% input:
%   S           - a scalar structure
%   fieldname   - either a string or a cell array of strings with the names
%                 of the fields (may contain dots defining sub-structures).
%                 All fieldnames have to exist in the scalar structure S.
%   fieldvalue  - either a value or a cell array of values corresponding to
%                 the field names defined in fieldname
%
% output:
%   S           - a scalar structure with new values assigned to it
%
% Example:
%   test.blub.blub = 2;
%   test.blub.bla = 2;
%   assignfield_recursive(test,{'blub.bla', 'blub.blub'}, {1, 3})
%
%
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

% check fieldname variable
if ~iscell(fieldname)
  fieldname = {fieldname};
end
if ~iscellstr(fieldname)
  error('fieldname has to contain string(s)');
end
test_existence = ~isfield_recursive(S, fieldname);
if any(test_existence)
  fprintf('Regarding the fieldnames:\n');
  for idx=find(test_existence)
    fprintf('%s\n', fieldname{idx});
  end
  error('These fields do not exist in %s!', inputname(1));
end
% check fieldvalue variable
if ~iscell(fieldvalue)
  fieldvalue = {fieldvalue};
end
if any(size(fieldname) ~= size(fieldvalue))
  error('Dimension mismatch between %s and %s', inputname(2), inputname(3));
end

%% Computation
for idx=1:numel(fieldname)
  dots = find(fieldname{idx} == '.');  % find dots in fieldname

  if isempty(dots)
    % is there is no dot in the fieldname anymore the recursion terminates and
    % one can assign the value to the structure field
    S.(fieldname{idx}) = fieldvalue{idx};
  else
    S.(fieldname{idx}(1:dots(1)-1)) = assignfield_recursive(...
      S.(fieldname{idx}(1:dots(1)-1)), ...
      fieldname{idx}(dots(1)+1:end), ...
      fieldvalue{idx});
  end
end

end
