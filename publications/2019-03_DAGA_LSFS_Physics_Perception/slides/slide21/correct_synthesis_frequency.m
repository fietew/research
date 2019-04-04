function correct_synthesis_frequency(conf)

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

src = conf.src;
xs = conf.xs;
rl = conf.rl;
rc = conf.rc;
xl = conf.xl;
xc = conf.xc;
M = conf.M;

%%
if ~isempty(rc) && ~isempty(M) && ~isnan(rc) && ~isnan(M)
    error('rc and M cannot be defined at the same time!')
end

switch conf.secondary_sources.geometry
    case {'circle', 'circular'}
        delta = conf.secondary_sources.size*pi/conf.secondary_sources.number;
    case {'line', 'linear'}
        delta = conf.secondary_sources.size/(conf.secondary_sources.number-1);
end
tmpconf = conf;
tmpconf.secondary_sources.number = 2^14; % densely sampled SSD for calculations
x0full = secondary_source_positions(tmpconf);
x0 = secondary_source_selection(x0full,xs,src);

kPx0 = local_wavenumber_vector(x0(:,1:3),xs,src);  % unit vectors

% is xl inside array?
if any(sum(bsxfun(@minus, xl, x0full(:,1:3)).*x0full(:,4:6),2) < 0)
    fcs = NaN;
else    
    % distance between xl and the line x0 + w*k_P(x0)
    dlx0 = vector_norm(cross(bsxfun(@minus, xl, x0(:,1:3)),kPx0,2),2);
    % remove all x0, which do not contribute to the listening area
    select = dlx0 <= rl;
  
    % distance between xc and the line x0 + w*k_P(x0)
    dcx0 = vector_norm(cross(bsxfun(@minus, xc, x0(select,1:3)),kPx0(select,:),2),2);
    if ~isempty(rc) && ~isnan(rc)        
       if any(dcx0 >= rc);
         fcs = 0;
       else
         fcs = inf;  
       end
    else
       fcs = min( M.*conf.c./(2.*pi.*dcx0) );
    end
end

if exist(conf.fcsfile, 'file')
  fcs = [gp_load(conf.fcsfile); fcs];
end
gp_save( conf.fcsfile, fcs );
