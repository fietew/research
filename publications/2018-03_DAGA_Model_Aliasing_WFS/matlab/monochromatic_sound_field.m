function monochromatic_sound_field(conf)

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
c = conf.c;
k = 2*pi*f/c;
method = conf.method;
xref = conf.xref;
X = conf.X;
Y = conf.Y;
Ygt = conf.Ygt;
Z = conf.Z;

%% Reproduced Sound Field
x0 = secondary_source_positions(conf);
switch method
    case 'wfs'
        [P,x,y] = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
    case 'nfchoa'
        [P,x,y] = sound_field_mono_nfchoa(X,Y,Z,xs,src,f,conf);
    case 'lwfs-sbl'
        [P,x,y] = sound_field_mono_localwfs_sbl(X,Y,Z,xs,src,f,conf);
end

% normalisation factor for gnuplot
useplot = conf.plot.useplot;
conf.plot.useplot = false;
switch src
    case 'pw'
        g = sound_field_mono_plane_wave(xref(1),xref(2),xref(3),xs,f,conf);
    case {'ps', 'fs'}
        g = sound_field_mono_point_source(xref(1),xref(2),xref(3),xs(1:3),f,conf);
end
conf.plot.useplot = useplot;

% radius of high accuracy
phitmp = (0:360).';
switch method
  case 'nfchoa'
    M = conf.nfchoa.order;
  case 'lwfs-sbl'
    M = conf.localwfs_sbl.order;
  case 'lwfs-vss'
    M = conf.localwfs_vss.size/2*k; 
  case {'wfs', 'gt'}
    M = conf.secondary_sources.size/2*k;
  case {'ref', 'stereo'}
    M = NaN;
  otherwise
    error('unknown method');
end
rM = [M/k*cosd(phitmp)+xref(1), M/k*sind(phitmp)+xref(2)];

%% Aliasing-Free Reproduced Sound Field
refconf = conf;
refconf.secondary_sources.number = 2048;
switch method
    case 'wfs'
        Pref = sound_field_mono_wfs(X,Y,Z,xs,src,f,refconf);
    case 'nfchoa'
        Pref = sound_field_mono_nfchoa(X,Y,Z,xs,src,f,refconf);
    case 'lwfs-sbl'
        Pref = sound_field_mono_localwfs_sbl(X,Y,Z,xs,src,f,refconf);
end

%% Ground Truth Sound Field
% Sound Pressure
switch src
  case 'pw'
    [Pgt,xgt,ygt] = sound_field_mono_plane_wave(X,Ygt,Z,xs,f,conf);
  case {'fs', 'ps'}
    [Pgt,xgt,ygt] = sound_field_mono_point_source(X,Ygt,Z,xs(1:3),f,conf);
end
% Local Wave Vector
conf.resolution = 21;
[xk,yk] = xyz_grid(X,Ygt,Z,conf);
xk = [xk(:),yk(:)];
xk(:,3) = Z;
kgt = local_wave_vector(xk, xs, src);

%% gnuplot
prefix = evalGenerateFilename(conf);

gp_save_matrix( [prefix, '_P.dat'] ,x,y,real(P./g));
gp_save_matrix([prefix, '_Pgt.dat'],xgt,ygt,real(Pgt./g));  % ground truth
gp_save_matrix([prefix, '_Pref.dat'],x,y,real(Pref./g)); 
gp_save_matrix([prefix, '_Perror.dat'],x,y,abs(P./Pref-1));

gp_save([prefix, '_kgt.txt'],[xk,kgt]);

gp_save_loudspeakers([prefix '_x0.txt'], x0);
gp_save([prefix '_xref.txt'], xref);
gp_save([prefix '_rM.txt'], rM);
