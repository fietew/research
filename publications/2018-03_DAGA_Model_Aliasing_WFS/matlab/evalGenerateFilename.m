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

% virtual sound field
filename = sprintf('%s', conf.src);

% 
filename = sprintf('%s_%s', filename, conf.method);

switch conf.method
    case 'nfchoa'
        filename = sprintf('%s_M%d', filename, conf.nfchoa.order);
    case 'lwfs-sbl'
        filename = sprintf('%s_M%d_xref%2.2f_yref%2.2f', filename, ...
            conf.localwfs_sbl.order, conf.xref(1), conf.xref(2));
end

if ~strcmp(conf.method, 'gt')
    filename = sprintf('%s_%s_s%2.2f_N%d', ...
        filename, ...
        conf.secondary_sources.geometry, ...
        conf.secondary_sources.size, ...
        conf.secondary_sources.number);
end

filename = sprintf('%s_f%4.2f', filename, conf.f);
filename = sprintf('%s_eta%d', filename, conf.eta);