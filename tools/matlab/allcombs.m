function combs = allcombs(varargin)
% generate all combinations of cell arrays' elements (similar to ndgrid)
%
% usage:
%   combMat = allcombs(A1,A2,...,An)
%   combMat = allcombs(A1,A2,...,An,groups)
%
% inputs:
%   A1,A2,...,An - cell arrays
%   groups       - vector of indexes indicating which cell arrays are merged
%                  into one group (and are therefore not combined).
%
% By default, any combination of the elements of A1,A2,...,An is generated. 
% However, giving a vector (groups) as the last arguments allows to group 
% cell arrays. The vector has to have the same length as he number of cell 
% arrays. The i-th element of the vector belongs to the i-th cell array. Cell
% arrays with the same index belong to one group. Cell arrays of the same
% group have to have the same size.
% A group is basically treated as one single cell array input. Hence, the 
% elements of the cell arrays in one group are not combined with each other.
%
% outputs:
%   combs - cell array where each column contains elements of the respective
%           cell array A1,A2,...,An. Each row represents one combination.
%
% example:
%   A1 = {'blub', 'test'}
%   A2 = {2, 'hello world', 'hihi', pi}
%   A3 = {1, inf }
%
%   combs = allcombs(A1, A2, ..., An, [1,2,1])  % A1 and A3 in one group

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

%% ===== Checking Arguments ==================================================

if isnumeric( varargin{end} )
  groups = varargin{end};
  
  if ~isvector( groups )
    error( '%s: if last input is numeric, it must be a vector!', ...
      upper(mfilename)) ;
  end
  if length( groups ) ~= nargin - 1
    error(['%s: if last input is numeric, its length must match', ...
      ' the number of remaining inputs!'], upper(mfilename) );
  end
  
  varargin = varargin(1:end-1);  % remove first input
else
  groups = 1:nargin;
end

% check if all remaning inputs are cell arrays
if ~all( cellfun( @iscell, varargin ) )
  error('%s: all the remaining inputs have be cell arrays!', ...
    upper(mfilename));
end

% check if merged inputs have the same length
sizeVec = cellfun('prodofsize', varargin);
for idx = unique( groups, 'sorted')
  selector = find( groups == idx );
  if length(selector) == 1
    continue;
  elseif any( sizeVec(selector(1)) ~= sizeVec(selector) )
    error('%s: size mismatch in merging group #%d!', ...
      upper(mfilename), idx );
  end
end

%% ===== Computation =========================================================

% remove duplicates from sizeVec, i.e. group dimensions
[~, ia, ic] = unique( groups, 'stable');
sizeVec = sizeVec( ia );

% generate a cell array where each element i contains the indices starting
% from 1 to sizeVec(i)
indices = fliplr(arrayfun(@(n) {1:n}, sizeVec));
% make a grid of all combinations of those indices
[indices{:}] = ndgrid(indices{:});
indices = fliplr(indices);
% vectorize each indices matrix and repeat grouped indices
indices = cellfun( @(idx) {idx(:)}, indices(ic) );
% finally create cell array of all combinations
combs = cellfun(@(c,idx) {reshape( c(idx(:)), [], 1)}, varargin(:), indices(:));
combs = [combs{:}];

end
