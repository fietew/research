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

# reset
set macros
set loadpath '../../../../tools/gnuplot/'

load 'border.cfg'
load 'array.cfg'
load 'standalone.cfg'

################################################################################
set t epslatex size @intposterhalfwidth,10cm color colortext standalone header intpostera0
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0
SPACING_VERTICAL = 0
OUTER_RATIO_L = 0.5
OUTER_RATIO_R = 0.5
OUTER_RATIO_T = 1.0
OUTER_RATIO_B = 0.5
# axes
set size ratio -1
set format '\footnotesize $%g$'
set tics scale 1 out nomirror
# x-axis
set xrange [-3.75:3.75]
set xtics 2 offset 0,-1
set xlabel offset 0,-2
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0,0
set ylabel offset -2,0
LABEL_Y = '$y$ / m'
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
# colorbar
load 'colorbar.cfg'
unset colorbox
# style
set style line 101 lc rgb '#black' pt 6 ps 3 linewidth 4
set style line 102 lc rgb 'white' pt 6 ps 3 linewidth 4
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.1 center front
# variables
vlen = 0.2
sx = 0.44
sy = 0.92
oriy = 0.1
orix1 = 0.07
orix2 = 0.55

################################################################################
set multiplot layout 1,2

#### plot 1 ####
# labels
set label 1 'plane wave'
# positioning
set size sx, sy
set origin orix1, oriy
@pos_bottom_left
# plotting
plot 'Ppw.dat' binary matrix u 1:2:3 with image,\
  'kpw.txt' u ($1-$4*0.5*vlen):($2-$5*0.5*vlen):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 101

#### plot 2 ####
# labels
set label 1 'point source'
# positioning
set size sx, sy
set origin orix2, oriy
@pos_bottom_right
# plotting
plot 'Pps.dat' binary matrix u 1:2:3 with image,\
  'kps.txt' u ($1-$4*0.5*vlen):($2-$5*0.5*vlen):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 101

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
