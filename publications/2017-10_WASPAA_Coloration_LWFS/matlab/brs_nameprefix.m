function prefix = brs_nameprefix( conf )
% generate filename prefix 

%*****************************************************************************
% Copyright (c) 2018      Fiete Winter                                       *
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
if any( strcmp(conf.method,  {'wfs', 'nfchoa', 'lwfs-sbl'}) )
  prefix = sprintf( '%s_%s_nls%04.0f_dls%02.02f', prefix, ...
    conf.secondary_sources.geometry, conf.secondary_sources.number, ...
    conf.secondary_sources.size);
end

% if reproduction technique
prefix = sprintf( '%s_%s', prefix, conf.method );

% if localwfs then specification of virtual secondary source distribution
if strcmp( conf.method, 'lwfs-sbl' )
  prefix = sprintf( '%s_M%02.0f_npw%04.0f', prefix, ...
    conf.localwfs_sbl.order, conf.localwfs_sbl.Npw);
end
