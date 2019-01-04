function prefix = brs_nameprefix( conf )

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

% position of listener
prefix = sprintf( 'posx%02.02f_posy%02.02f', ...
  conf.pos(1), conf.pos(2));

% if sfs technique, then specification of loudspeaker array
if any( strcmp(conf.method,  {'wfs', 'nfchoa', 'lwfs-sbl', 'lwfs-vss'}) )
  prefix = sprintf( '%s_%s_nls%04.0f_dls%02.02f', prefix, ...
    conf.secondary_sources.geometry, conf.secondary_sources.number, ...
    conf.secondary_sources.size);
end

prefix = sprintf( '%s_%s', prefix, conf.method );

% if reproduction technique
switch conf.method
case 'nfchoa'
    prefix = sprintf( '%s_M%02.0f', prefix, conf.nfchoa.order);
    prefix = sprintf( '%s_%s', prefix, get_modal_window(conf));
case 'lwfs-sbl'
    prefix = sprintf( '%s_M%02.0f', prefix, conf.localwfs_sbl.order);
    prefix = sprintf( '%s_%s', prefix, get_modal_window(conf));
    prefix = sprintf( '%s_npw%04.0f', prefix, conf.localwfs_sbl.Npw);
case 'lwfs-vss'
    prefix = sprintf( '%s_%s_nvs%04.0f_dvs%02.02f_%s', prefix, ...
        conf.localwfs_vss.geometry, ...
        conf.localwfs_vss.number, ...
        conf.localwfs_vss.size, ...
        conf.localwfs_vss.method);
    
    if strcmp(conf.localwfs_vss.method, 'nfchoa')
        prefix = sprintf( '%s_M%02.0f', prefix, conf.localwfs_vss.nfchoa.order);
        prefix = sprintf( '%s_%s', prefix, get_modal_window(conf));
    end
end

end

function s = get_modal_window( conf )    
  s = conf.modal_window;
  if strcmp(conf.modal_window, {'kaiser', 'tukey'})
     s = sprintf('%s%02.02f', s, conf.modal_window_parameter);
  end
end
