function [ filename ] = evalGenerateFilename(conf)

%*****************************************************************************
% Copyright (c) 2017      Fiete Winter                                       *
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

%
x = conf.xeval(1);
y = conf.xeval(2);
filename = sprintf('x%2.2f_y%2.2f', x, y);
% virtual sound field
filename = sprintf('%s_%s', filename, conf.src);
% method
filename = sprintf('%s_%s', filename, conf.method);

if ~strcmp('gt', conf.method)
  % loudspeakers
  filename = sprintf('%s_NLS%d', filename, conf.secondary_sources.number);
  
  xr = conf.xref(1);
  yr = conf.xref(2);
  switch conf.method
    case 'nfchoa'
      % Ambisonics order
      if isempty(conf.nfchoa.order)
        % Get maximum order of spherical harmonics
        order = nfchoa_order(conf.secondary_sources.number,conf);
      else
        order = conf.nfchoa.order;
      end
      filename = sprintf('%s_M%d', filename, order);
    case 'wfs'
      filename = sprintf('%s_xref%2.2f_yref%2.2f', filename, xr, yr);
    case 'lwfs-sbl'
      if strcmp( conf.src, 'ps' ) && conf.localsfs.sbl.useap
        filename = sprintf('%s_ap', filename);
      end
      filename = sprintf('%s_xref%2.2f_yref%2.2f', filename, xr, yr);
  end 
end
