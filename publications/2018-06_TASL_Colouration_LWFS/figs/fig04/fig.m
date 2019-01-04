% sound field of focused source at coordinates origin

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

clear variables
close all
SFS_start;
addpath('../../matlab');

%% parameters
brs_parameters;

% large array to avoid spatial aliasing and truncation
conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.number = 4096;
conf.secondary_sources.size = 40;
% avoids amplitude artefacs due to 2.5 synthesis
conf.xref = [0,0,0];

%%
f = [100, 1000, 10000];
ys = logspace(-2,1,100);
P = zeros(length(ys), length(f)+1);

for ydx = 1:length(ys)    
    Xs = [0, ys(ydx), 0];  % virtual source position    
    for fdx = 1:length(f)
        P(ydx,fdx) = sound_field_mono_wfs(0,0,0,[Xs, 0, -1, 0],...
            'fs',f(fdx),conf);
    end    
    P(ydx,end) = sound_field_mono_point_source(0,0,0,Xs,f(1),conf);
end

%% plot
figure;
semilogx(ys.',db(P));
%% gnuplot
gp_save('data.txt', [ys.', db(P)]);