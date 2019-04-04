#*****************************************************************************
# Copyright (c) 2013-2019 Fiete Winter                                       *
#                         Institut fuer Nachrichtentechnik                   *
#                         Universitaet Rostock                               *
#                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
#                                                                            *
# This file is part of the supplementary material for Fiete Winter's         *
# scientific work and publications                                           *
#                                                                            *
# You can redistribute the material and/or modify it  under the terms of the *
# GNU  General  Public  License as published by the Free Software Foundation *
# , either version 3 of the License,  or (at your option) any later version. *
#                                                                            *
# This Material is distributed in the hope that it will be useful, but       *
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
# or FITNESS FOR A PARTICULAR PURPOSE.                                       *
# See the GNU General Public License for more details.                       *
#                                                                            *
# You should  have received a copy of the GNU General Public License along   *
# with this program. If not, see <http://www.gnu.org/licenses/>.             *
#                                                                            *
# http://github.com/fietew/publications           fiete.winter@uni-rostock.de*
#*****************************************************************************

plot for [idx=1:10] filename.'_ci.txt' u (column(4*idx-3)+r_spread*column(4*idx-1)):(column(4*idx-2)+r_spread*column(4*idx)) with filledcurves lc rgb "grey",\
  filename.'_loc.txt' @localization_grey_line,\
  filename.'_avr.txt' using (0.40):(0.4):(print_loc($1)) with labels left offset 0.0,-0.35,\
  filename.'_avr.txt' using (0.40):(-0.4):(print_blur(abs($3))) with labels left offset 0.0,-0.35,\
  filename.'_loc.txt' @localization_arrow,\
  'array.txt' @array_active,\
  set_point_source(0,2.5) @point_source
