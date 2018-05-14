function pwd_modal_window( conf )
% store modal window into gnuplot compatible format

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

%% ===== Configuration ==================================================
order = conf.nfchoa.order;  % order of truncation window
Mmax = conf.Mmax;  % maximum order of window for gnuplot

%% ===== Computation ====================================================

% modal weighting function
wm = zeros(Mmax+1,1);
wm(1:order+1) = modal_weighting(order, conf);

%% ===== Gnuplot ========================================================

gp_save( ['wm_' brs_nameprefix( conf ) '.txt'], [(0:Mmax).', wm] );
