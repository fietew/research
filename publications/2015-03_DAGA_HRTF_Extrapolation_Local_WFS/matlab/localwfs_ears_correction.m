function [wL, wR] = localwfs_ears_correction(w0, x0, xv, conf)

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

%% ===== Checking of input  parameters ===================================
nargmin = 3;
nargmax = 4;
narginchk(nargmin,nargmax);
isargsecondarysource(x0, xv);
isargmatrix(w0);
if nargin<nargmax
    conf = SFS_config;
else
    isargstruct(conf);
end

%% ===== Configuration ===================================================

dimension = conf.dimension;

%% ===== Variables =======================================================
N0 = size(x0,1);
Nv = size(xv,1);

xref = conf.xref;
xrefL = conf.xref + conf.ear_xref_shift;
xrefR = conf.xref - conf.ear_xref_shift;

dimension = conf.dimension;

%% ===== Computation =====================================================

wL = w0;
wR = w0;

if strcmp('2.5D',dimension)
  for idx=1:N0
    % correct amplitude error for each loudspeaker
    g0 = vector_norm(xref-x0(idx,1:3),2);
    wL(idx,:) = wL(idx,:) * sqrt( vector_norm(xrefL-x0(idx,1:3),2) / g0 );
    wR(idx,:) = wR(idx,:) * sqrt( vector_norm(xrefR-x0(idx,1:3),2) / g0 );
    % correct amplitude error for each virtual secondary source
    for kdx=1:Nv
      gv = vector_norm(xref-xv(kdx,1:3),2);
      wL(idx,kdx) = wL(idx,kdx) * sqrt( vector_norm(xrefL-xv(kdx,1:3),2) / gv );
      wR(idx,kdx) = wL(idx,kdx) * sqrt( vector_norm(xrefR-xv(kdx,1:3),2) / gv );
    end
  end
end

end
