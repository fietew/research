function spatial_aliasing_rays(conf)

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

src = conf.src;
xs = conf.xs;
f = conf.f;
k = 2*pi*f./conf.c;
eta = conf.eta;
idSPA = conf.idSPA;

%% Local Wave Vector at SSD
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);
x0SPA = x0(idSPA,:);
x0(idSPA ,:) = [];

kvec = local_wave_vector(x0(:,1:3),xs,src);
kSeta = local_aliasing_vector(kvec,x0(:,4:6),x0(:,7),k,eta);

w = 0:0.1:10;
rays = zeros(2*size(x0,1),length(w));
rays(1:2:end,:) = bsxfun(@plus, x0(:,1), kSeta(:,1)*w);
rays(2:2:end,:) = bsxfun(@plus, x0(:,2), kSeta(:,2)*w);

% ray for x0approx
kvecSPA = local_wave_vector(x0SPA(:,1:3), xs, 'ps');
kSetaSPA = local_aliasing_vector(kvecSPA,x0SPA(:,4:6),x0SPA(:,7),k,eta);
raysSPA(1,:) = bsxfun(@plus, x0SPA(:,1), kSetaSPA(:,1)*w);
raysSPA(2,:) = bsxfun(@plus, x0SPA(:,2), kSetaSPA(:,2)*w);

%% gnuplot
prefix = evalGenerateFilename(conf);

gp_save([prefix '_rays.txt'], rays.');
gp_save([prefix '_raysSPA.txt'], raysSPA.');
gp_save_loudspeakers([prefix '_x0Son.txt'],  x0(~isnan(kSeta(:,1)),:));
gp_save_loudspeakers([prefix '_x0Soff.txt'], x0( isnan(kSeta(:,1)),:));
gp_save_loudspeakers([prefix '_x0SSPA.txt'], x0SPA);
