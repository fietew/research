%

%*****************************************************************************
% Copyright (c) 2015      Fiete Winter                                       *
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

clear all;

SFS_start;  % start Sound Field Synthesis Toolbox
addpath('../../matlab');

%% general settings
conf.dimension = '2.5D';
conf.showprogress = false;
conf.plot.useplot = false;
conf.resolution = 300;
conf.usenormalisation = false;

conf.c = 343;  % speed of sound
conf.phase = 0;

%% config for real array
conf.secondary_sources.x0 = [];
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.size = 3.0;
conf.secondary_sources.center = [0, 0, 0];
conf.driving_functions = 'default';

conf.xref = [0, 0, 0];

%% ===== Variables =======================================================
X0 = conf.secondary_sources.center;
r0 = conf.secondary_sources.size/2;

src = 'pw';
phis = -90;
xs = [cosd(phis), sind(phis), 0];

rc = 0.75;

Nse = 83;
Lse = (Nse+1)^2;

X = [-2, 2];
Y = [-2, 2];
Z = 0;

%% ===== Computation of sound fields =====================================

for N0 = [32, 56]
  
  conf.secondary_sources.number = N0;
  
  % secondary sources
  x0 = secondary_source_positions(conf);
  gp_save_loudspeakers(sprintf('array_L%d.txt', N0), x0);
  
  for f = [2000, 3000]  % frequency
    for phic = [-45, 45]  % azimuth of local center
      
      
      xc = rc*[cosd(phic), sind(phic), 0];
      gp_save(sprintf('local_phit%d.txt', phic), xc);
      
      % propagation direction of virtual plane wave
      xpw = [ xc(1) + r0*[-4:0.25:4].'*cosd(phis), ...
        xc(2) + r0*[-4:0.25:4].'*sind(phis) ];
      gp_save(sprintf('Xpw_phit%d.txt', phic), xpw );
      
      for Nse_local = [14, 21]
        
        Lse_local = (Nse_local+1)^2;
        
        % local regular spherical expansion of sound field at X0 + xt
        Pnumu = sphexp_mono_pw(xs, Nse_local, f, X0+xc, conf);
        
        % shift spherical expansion back to X0
        RR = get_translation(-xc, Nse, f);
        Pnm = RR(1:Lse,1:Lse_local) * Pnumu;
        
        % driving function
        D = driving_function_mono_nfchoa_sphexp(x0, Pnm, f, conf);
        % sound field
        [P, x, y] = sound_field_mono(X, Y, Z, x0, 'ps', D, f, conf);
        
        % rM - approximation for high accuracy area
        rM = Nse_local/(2*pi*f/conf.c);
        tmpconf = conf;
        tmpconf.secondary_sources.size = 2*rM;
        tmpconf.secondary_sources.center = xc;
        xM = secondary_source_positions(tmpconf);
        xM = [xM; xM(1,:)];
        
        % approxmation for spectral repetitions
        [phial, ral, xsec] = nfchoa_grating_lobes(xc, phis, f, Nse_local, [-3:-1,1:3], conf);
        nal = [cosd(phial), sind(phial)];
        north = [-sind(phial), cosd(phial)];
        
        xal = [];
        Xaux = [];
        for idx=1:length(phial)
          gal = bsxfun(@plus, (-1)^idx*r0*[-4:0.25:4].'*nal(idx,:), xsec);
          galmin = bsxfun(@plus, gal, ral(idx)*north(idx,:));
          galmax = bsxfun(@plus, gal, -ral(idx)*north(idx,:));
          
          xal = [xal; [gal, galmin, galmax]];
          
          % auxilary circle to compare width of grating lobes
          Xtmp = bsxfun(@plus, xM(:,1:2), xsec-xc(1:2)+0.75*r0*nal(idx,:));
          Xaux = [Xaux,Xtmp(:,1:2)];
        end
        
        % gnuplot
        fileid = sprintf('_Mprime%d_phit%d_f%d', Nse_local, phic, f);        
        gp_save_loudspeakers( [ 'rM' fileid '.txt' ], xM );
        
        fileid = sprintf('_L%d_Mprime%d_phit%d_f%d', N0, Nse_local, phic, f);        
        gp_save_matrix( [ 'sound_field' fileid '.dat' ] , x, y, P);
        gp_save( [ 'Xal' fileid '.txt' ], xal );
        gp_save( [ 'rAux' fileid '.txt' ], Xaux );
      end
    end
  end  
end