function RR = get_translation(xt, Nse, f)
% get translation coefficients from hard disk computed by nfchoa_translation
%
% xt - translation vector [3 x 1]
% Nse - modal order
% f - time-frequency
%
% See also: nfchoa_translation

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
isargcoord(xt);
isargpositivescalar(Nse,f);

%% ===== Variables =======================================================
rt = norm(xt);
phit= atan2d(xt(2), xt(1));

%% ===== Computation =====================================================

try
  load(sprintf('RR_%1.1f_%1.3f_%d_f%.0f.mat', wrapTo180(phit), rt, Nse, f), 'RR');
catch
  load(sprintf('RR_%1.1f_%1.3f_%d_f%.0f.mat', wrapTo180(-phit), rt, Nse, f), 'RR');
  RR = conj(RR);
end
