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
set t epslatex size 18.0cm,8cm color colortext standalone header daga.footnotesize
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
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 2,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
# style
set style line 101 lc rgb 'black' lw 4
set style line 102 lc rgb 'red' lw 4
# labels
load 'labels.cfg'
set label 1 at graph 0.15, 1.1 left front
set label 2 at graph 1.0, 1.1 right front
set label 3 center front tc rgb '#808080'
set label 5 at graph 0.0, 1.1 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# variables
sx = 0.17
sy = 0.40
oriy1 = 0.515
oriy2 = 0.105
orix1 = 0*sx + 0.06
orix2 = 1*sx + 0.07
orix3 = 2*sx + 0.08
orix4 = 3*sx + 0.09
orix5 = 4*sx + 0.10

################################################################################
set multiplot layout 2,5

#### plot 1 ####
# labels
set label 1 '\small equidistant'
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
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
filename = 'ps_circular_none'
# plotting
load 'plotP.gnu'

#### plot 2 ####
# labels
set label 1 '\small area'
set label 2 '\small Eq.~(10)'
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# variables
filename = 'ps_circular_pos_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotP.gnu'

#### plot 3 ####
# labels
set label 1 '\small \shortstack{area and\\soundfield}'
set label 2 '\small Eq.~(7)'
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotP.gnu'

#### plot 4 ####
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_top_right
# colorbar
set colorbox @colorbar_east
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.50'
# plotting
load 'plotP.gnu'

#### plot 5 ####
# labels
set label 1 '\small soundfield'
set label 2 '\small Eq.~(9)'
# positioning
set size sx, sy
set origin orix5, oriy1
@pos_top_right
# colorbar
set colorbox @colorbar_east
# variables
filename = 'ps_circular_src'
# plotting
load 'plotP.gnu'

#### plot 6 ####
# c-axis
set cbrange [1:3]
set cbtics 0.5
set format cb '\ft $%g$'
# palette
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette maxcolors 4
# labels
unset label 1
unset label 2
unset label 5
# colorbar
unset colorbox
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# variables
filename = 'ps_circular_none'
# plotting
load 'plotfS.gnu'

#### plot 7 ####
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom
# variables
filename = 'ps_circular_pos_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotfS.gnu'

#### plot 8 ####
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotfS.gnu'

#### plot 9 ####
# positioning
set size sx, sy
set origin orix4, oriy2
@pos_bottom
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.50'
# plotting
load 'plotfS.gnu'

#### plot 10 ####
# labels
set label 3 at graph 1.085, -0.075 '\ft kHz'
# positioning
set size sx, sy
set origin orix5, oriy2
@pos_bottom_right
# colorbar
set colorbox @colorbar_east
# variables
filename = 'ps_circular_src'
# plotting
load 'plotfS.gnu'


################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
