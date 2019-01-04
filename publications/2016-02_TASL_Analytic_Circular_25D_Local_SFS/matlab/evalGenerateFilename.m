function [ filename ] = evalGenerateFilename(conf)

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

%% ===== Checking of input  parameters ===================================
nargmin = 0;
nargmax = 1;
narginchk(nargmin,nargmax);
if nargin<nargmax
  conf = SFS_config;
else
  isargstruct(conf);
end

%% ===== Variables =======================================================
src = conf.source_type;

r = conf.distance;
phi = conf.azimuth / pi * 180;

rref = norm(conf.xref);

rt = norm(conf.xt);
phit= atan2d(conf.xt(2), conf.xt(1));

f = conf.frequency;

Nse = conf.Nse;
Nce = conf.Nce;

%% ===== Computation =====================================================

filename = src;
filename = [filename, '_phi', num2str(phi,'%1.1f')];
if strcmp(src, 'ps')
  filename = [filename, '_r', num2str(r,'%1.3f')];
end
filename = [filename, '_rref', num2str(rref,'%1.3f')];
filename = [filename, '_phit', num2str(phit,'%1.1f')];
filename = [filename, '_rt', num2str(rt,'%1.3f')];
filename = sprintf('%s_Nset%d_Nce%d', filename, Nse, Nce);
switch length(f(:))
  case 0
  case 1
    filename = sprintf('%s_f%.0f', filename, f);
  otherwise
    filename = sprintf('%s_f%.0f-%.0f', filename, min(f(:)), max(f(:)));
end