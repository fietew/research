function [ filename ] = evalGenerateFilename(conf)

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

phi = conf.azimuth / pi *180;
r = conf.localsfs.vss.size/2;
Nl = conf.localsfs.vss.number;
N = conf.N;

filename = 'hrtf';
filename = [filename, '_phi', num2str(phi,'%1.1f')];
filename = [filename, '_Rl', num2str(r,'%1.3f')];
filename = [filename, '_Nl', num2str(Nl)];
filename = [filename, '_N', num2str(N)];
if conf.use_ear_correction
  filename = [filename, '_Ctrue'];
else
  filename = [filename, '_Cfalse'];
end
filename = [filename, '.mat'];

end
