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

reset
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
# labels
load 'labels.cfg'
set label 1 @label_northeast
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 1.0
SPACING_VERTICAL = 1.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_R = 0.0
OUTER_RATIO_B = 1.0
INNER_RATIO_V = 0.0
INNER_RATIO_H = 1.0
# axes
set size ratio -1
set format '$%g$'
set tics scale 1 out nomirror
# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,-0.5
set xlabel offset 0,-1.5
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.0,0
set ylabel offset -1.0,0
LABEL_Y = '$y$ / m'
# colorbar
load 'colorbar.cfg'
# style
set style line 211 ps 2  # re-define point size for @array_active
# variables
sx = 0.195
sy = 1.0
oriy1 = 0.04
orix1 = 0*sx + 0.05
orix2 = 1*sx + 0.06
orix3 = 2*sx + 0.07
orix4 = 3.25*sx + 0.09

################################################################################
set multiplot layout 1,4

#### plot 1 #####
# positioning
set size sx, sy
set origin orix1, oriy1
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# labels
set label 1 '1 kHz'
# colobar
unset colorbox
# positioning
@pos_bottom_left
# plotting
plot 'P_wfs_f1000.dat' binary matrix with image, \
  'array.txt' @array_active, \

#### plot 2 #####
# positioning
set size sx, sy
set origin orix2, oriy1
# labels
set label 1 '2 kHz'
# positioning
@pos_bottom
# plotting
plot 'P_wfs_f2000.dat' binary matrix with image, \
  'array.txt' @array_active, \

#### plot 3 #####
# positioning
set size sx, sy
set origin orix3, oriy1
# labels
set label 1 '3 kHz'
# colorbar
set colorbox @colorbar_east
# positioning
@pos_bottom
# plotting
plot 'P_wfs_f3000.dat' binary matrix with image, \
  'array.txt' @array_active, \

#### plot 4 #####
# positioning
set size sx, sy
set origin orix4, oriy1
# c-axis
set cbrange [-40:0]
set cbtics 10
set cbtics add ('$0$ dB' 0)
# palette
load 'sequential/Blues.plt'
set palette positive
set palette maxcolor 0
# labels
set label 1 'Broadband'
# positioning
@pos_bottom_right
# plotting
plot 'p_wfs.dat' binary matrix with image, \
  'array.txt' @array_active, \

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
