function kvec = local_wavenumber_vector(x, xs, src)
%

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

%% ===== Checking of input  parameters ===================================
nargmin = 3;
nargmax = 3;
narginchk(nargmin,nargmax);

isargmatrix(x)
isargxs(xs);
isargchar(src);

%% ===== Main ============================================================

switch src
case 'ps'
    kvec = bsxfun(@minus, x, xs);
case 'fs'
    kvec = bsxfun(@minus, xs(1:3), x);
case 'pw'
    kvec = repmat(xs,[size(x,1),1]);
end
kvec = bsxfun(@rdivide, kvec, vector_norm(kvec,2)); 
