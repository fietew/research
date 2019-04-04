function spatial_aliasing_frequency(conf)

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
tmpconf.secondary_sources.number = 2^13; % densely sampled SSD for calculations
x0full = secondary_source_positions(tmpconf);
x0 = secondary_source_selection(x0full,xs,src);
x0(:,7) = delta;

kSx0 = local_wavenumber_vector(x0(:,1:3),xs,src);  % unit vectors

minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,rl);
if ~isempty(rc) && ~isnan(rc)
  minmax_kSt_fun = @(x0p) minmax_kt_circle(x0p,xc,rc);

  fS = aliasing_extended_control(x0, kSx0, xl, minmax_kGt_fun, ...
    minmax_kSt_fun, conf);
elseif ~isempty(M) && ~isnan(M)
  fS = aliasing_extended_modal(x0, kSx0, xl, minmax_kGt_fun, xc, M, conf);
else
  fS = aliasing(x0,kSx0,xl,conf);
end

if exist(conf.falfile, 'file')
  fS = [gp_load(conf.falfile); fS];
end
gp_save( conf.falfile, fS );
