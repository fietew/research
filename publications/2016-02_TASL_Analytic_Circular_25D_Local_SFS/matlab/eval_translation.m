% computes spherical translation coefficients and saves them on hard disk.
% they can be read by get_translation
%
% See also: get_translation

%*****************************************************************************
% Copyright (c) 2016      Fiete Winter                                       *
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

%% general settings
conf.dimension = '2.5D';
conf.showprogress = false;
conf.plot.useplot = false;
conf.usenormalisation = false;

conf.c = 343;  % speed of sound

%% config for evaluation
conf.xt = [0, 1.0, 0];
conf.frequency = 10;
conf.Nse = 60; % maximum order of spherical expansion

%% parameters which should be iterated
% parameters which should be varied for the evaluation
param_names = { 'xt', 'frequency'};

%% generate disired combinations of parameter values
phit = 0:45:135;
rt = 0.25:0.25:1.25;
[phit, rt] = meshgrid(phit, rt);
xt = [rt(:).*cosd(phit(:)), rt(:).*sind(phit(:)), zeros(numel(rt),1)];

frequency = 50;

param_values = allcombs( mat2cell(xt,ones(size(xt,1),1),size(xt,2))', ...
  mat2cell(frequency, size(frequency,1), ones(size(frequency,2),1)) ...
  );

%%
% compute sound pressure on regular grid
exhaustive_evaluation(@nfchoa_translation, param_names, param_values, conf);
