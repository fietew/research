function features_comparison(conf)

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

%% config
xs = conf.distance*[cos(conf.azimuth), sin(conf.azimuth), 0];

%% reference hrirs
irs_orig = read_irs(conf.hrirfile, conf);

%%
load(evalGenerateFilename(conf), 'tfs');

tfs.ild = abs(tfs.left./tfs.right);

tfs.Rl = conf.localsfs.vss.size/2;
tfs.Nl = conf.localsfs.vss.number;
tfs.N = conf.N;

%%
ir_orig = get_ir(irs_orig, xs, 'cartesian', conf);

[ampl, ang, tfs.f_orig] = easyfft(ir_orig(:,1), conf);
tfs.left_orig = ampl.*exp(1j*ang);
[ampl, ang] = easyfft(ir_orig(:,2), conf);
tfs.right_orig = ampl.*exp(1j*ang);

tfs.ild_orig = abs(tfs.left_orig./tfs.right_orig);

%%
save(evalGenerateFilename(conf), 'tfs', 'conf');
