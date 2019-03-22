#!/usr/bin/gnuplot

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

# contour for aliasing frequency
set view map
unset surface
set contour base
set cntrparam points 2
set cntrparam linear
set format '%g'
set cntrparam level discrete (2000)
set table 'cont.txt'
splot filename.'_fS.dat' binary matrix w l
unset table
# plot
set format x ''
set format y '$%g$'
set format cb '$%g$'
plot filename.'_P.dat' binary matrix with image,\
  filename.'_x0.txt' @array_active,\
  filename.'_circle.txt' w l ls 102,\
  'cont.txt' w l ls 101
