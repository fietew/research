function res = isfield_recursive(S, fieldname)
% Recursively determines whether the input is a field of the structure
%
% input:
%   S           - structure array
%   fieldname   - either a string or a cell array of strings with the names
%                 of the fields (may contain dots defining sub-structures)
%
% output:
%   res         - boolean matrix of the same size as fieldname indicating
%                 the existence of the fields
%
% Example:
%   test.blub.bla.blub = 2;
%   isfield_recursive(test,'blub.bla.blub')      % true
%   isfield_recursive(test,'blub.bla.')          % false (trailing dot)
%   isfield_recursive(test,'blub.bla.test')      % false ('test' is not a field)
%   isfield_recursive(test,'.blub.bla')          % false (leading dot)
%   isfield_recursive(test,{'blub.bla', 'blub'}) % true true
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

if ~iscell(fieldname)
  fieldname = {fieldname};
end

if ~iscellstr(fieldname)
  error('fieldname has to contain string(s)');
end

res = false(size(fieldname));

for idx=1:numel(res)
  dots = find(fieldname{idx} == '.');  % find dots in fieldname

  T = S;  % temporary structure
  lastdot = 0;
  for dot=dots
    % conditions checks the existence of the current field.
    if ~isfield(T, fieldname{idx}(lastdot+1:dot-1))
      res(idx) = false;
      break;
    end
    % recursion: re-assign the existing fields as the struct
    T = T.(fieldname{idx}(lastdot+1:dot-1));
    % move on to next part of fieldname
    lastdot = dot;
  end

  res(idx) = isfield(T, fieldname{idx}(lastdot+1:end));
end

end
