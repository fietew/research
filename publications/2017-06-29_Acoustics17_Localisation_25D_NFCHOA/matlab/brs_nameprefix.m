function prefix = brs_nameprefix( conf )
% naming scheme

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

% reproduction method
prefix = sprintf('%s_%s',prefix,conf.method);

% loudspeaker setup
if strcmp(conf.method,'nfchoa')
    prefix = sprintf('%s_nls%04d',prefix,conf.secondary_sources.number);
end

% modal windowing
if any(strcmp(conf.method,{'nfchoa' 'pw'}))
    prefix = sprintf('%s_wo%02d_w%s',prefix,conf.nfchoa.order, ...
        conf.modal_window);
         
    % window specific stuff
    switch conf.modal_window
        case 'kaiser'
            prefix = sprintf('%s%02.02f',prefix,conf.modal_window_parameter);
    end
end
