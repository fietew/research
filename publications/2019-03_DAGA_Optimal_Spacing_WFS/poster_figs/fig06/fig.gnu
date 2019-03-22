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
set t epslatex size @intposterhalfwidth,11cm color colortext standalone header intpostera0
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 0.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_B = 0.5
# axes
set size ratio -1
set format '$%g$'
set tics scale 1.0 out nomirror
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,-0.5
set xlabel offset 0,-1.5
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.0,0
set ylabel offset -1.0,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
# style
set style line 101 lc rgb 'black' lw 7
set style line 102 lc rgb 'red' lw 7
set style line 211 ps 2  # re-define point size for @array_active
# labels
load 'labels.cfg'
set label 1 at graph 0.2, 1.25 left front
set label 2 at graph 0.2, 1.1 left front
set label 5 at graph 0.0, 1.25 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 3 center front tc rgb '#808080'
# variables
sx = 0.17
sy = 1.0
oriy1 = 0.00
orix1 = 0*sx + 0.05
orix2 = 1*sx + 0.06
orix3 = 2*sx + 0.07
orix4 = 3*sx + 0.08
orix5 = 4*sx + 0.09

################################################################################
set multiplot layout 2,5

#### plot 1 ####
# labels
set label 1 'equidistant'
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
# colorbar
unset colorbox
# variables
pos_tmp = pos_bottom_left
filename = 'ps_circular_none'
# plotting
load 'plotP.gnu'

#### plot 2 ####
# labels
set label 1 'arbitrary'
set label 2 'sound field'
# positioning
set size sx, sy
set origin orix2, oriy1
# variables
pos_tmp = pos_bottom
filename = 'ps_circular_pos_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotP.gnu'

#### plot 3 ####
# labels
set label 1 'known'
# positioning
set size sx, sy
set origin orix3, oriy1
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotP.gnu'

#### plot 4 ####
# positioning
set size sx, sy
set origin orix4, oriy1
pos_tmp = pos_bottom
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.50'
# plotting
load 'plotP.gnu'

#### plot 5 ####
# positioning
set size sx, sy
set origin orix5, oriy1
# colorbar
set colorbox @colorbar_east
# variables
pos_tmp = pos_bottom_right
filename = 'ps_circular_both_xc0.00_yc0.00_Rc1.50'
# plotting
load 'plotP.gnu'

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
