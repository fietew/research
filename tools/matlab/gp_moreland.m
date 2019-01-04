function gp_moreland( filename, N, rgb1, rgb2 )
% calculate diverging colormap after Moreland (2009) and create gnuplot
% compatible palette file. The function diverging_map from
% http://kennethmoreland.com/color-maps/

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

s = linspace(0.0, 1.0, N);
cmap = diverging_map(s, rgb1, rgb2);

fid = fopen(filename, 'w');

fprintf(fid, '# Color pallete after Moreland (2009)\n');
fprintf(fid, '# http://www.sandia.gov/~kmorel/documents/ColorMaps/\n');
fprintf(fid, '# http://bastian.rieck.ru/blog/posts/2012/gnuplot_better_colour_palettes/\n');
fprintf(fid, '# from RGB[%1.3f, %1.3f, %1.3f] to RGB[%1.3f, %1.3f, %1.3f]\n\n', ...
  rgb1(1), rgb1(2), rgb1(3), rgb2(1), rgb2(2), rgb2(3) );

fprintf(fid, 'set palette defined (\\\n');
for idx=1:length(s)-1;
  fprintf(fid, '%1.7f %1.7f %1.7f %1.7f,\\\n', s(idx), cmap(idx,1), ...
    cmap(idx,2), cmap(idx,3));
end
fprintf(fid, '%1.7f %1.7f %1.7f %1.7f)\n', s(end), cmap(end,1), cmap(end,2), ...
  cmap(end,3));