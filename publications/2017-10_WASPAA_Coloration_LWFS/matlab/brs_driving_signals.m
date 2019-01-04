function brs_driving_signals( conf )
% time-domain driving signal for various SFS techniques

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

%% ===== Configuration ==================================================
xs = conf.xs;  % source position
src = conf.src;  % source type
pos = conf.pos;  % listener position
xref = conf.xref;  % reference position
method = conf.method;  % SFS method
c = conf.c;  % speed of sound

% switch off the stupid warnings for not using wavwrite and wavread anymore
warning('off', 'MATLAB:audiovideo:wavwrite:functionToBeRemoved');
warning('off', 'MATLAB:audiovideo:wavread:functionToBeRemoved');

%% ===== Computation ====================================================

% listener orientation 
switch src
  case 'ps'
    phi = atan2( xs(2)-pos(2), xs(1)-pos(1) );
  case 'pw'
    phi = atan2( -xs(2), -xs(1) );
end

switch method
  case {'ref', 'anchor'}
    % === Reference & Anchor ===    
    x0 = [xs 0 -1 0 1];
    d = 1;
    delay_offset = 0;
  case 'stereo'
    % === Stereo ===
    xsl = [-1.4434 2.5 0]; % left loudspeaker
    xsr = [1.4434 2.5 0];  % right loudspeaker
    
    % always turn to the nearest loudspeaker
    if pos(1) < 0
      phi = atan2( xsl(2)-pos(2), xsl(1)-pos(1) );      
    elseif pos(1) > 0
      phi = atan2( xsr(2)-pos(2), xsr(1)-pos(1) );
    else
      phi = atan2( xsr(2)-pos(2), -pos(1) );
    end
    
    x0 = [xsl 0 -1 0 1; xsr 0 -1 0 1];
    d = [1, 1];
    delay_offset = (norm(xsl - xref) - norm(xs - xref))/c;
  case 'wfs'
    % === WFS ===
    % secondary sources
    x0 = secondary_source_positions(conf);
    x0 = secondary_source_selection(x0,xs,src);
    x0 = secondary_source_tapering(x0,conf);
    % driving signals
    [d, ~, ~, delay_offset] = driving_function_imp_wfs(x0,xs,src,conf);    
  case 'nfchoa'
    % === NFC-HOA ===
    % secondary sources
    x0 = secondary_source_positions(conf);
    % driving signals
    [d, ~, delay_offset] = driving_function_imp_nfchoa(x0,xs,src,conf);
  case 'lwfs-sbl'
    % === Local WFS using Spatial Bandwidth Limitation ===
    conf.xref = pos;
    % Get secondary sources
    x0 = secondary_source_positions(conf);
    % driving signals
    [d, delay_offset] = driving_function_imp_localwfs_sbl(x0, xs, src, conf);   
end

%% ===== Save File =======================================================
res.conf = conf;
res.x0 = x0;
res.d = d;
res.phi = phi;
res.delay_offset = delay_offset;
res.name = brs_nameprefix(conf);

save([res.name, '.mat'], 'res');
