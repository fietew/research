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
set terminal epslatex size @intbeamerwidth,3.5cm color colortext standalone header intbeamer.footnotesize
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.2
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 3,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
# axes
set size ratio -1
set tics scale 0.75 out nomirror
# style
set style line 101 lc rgb 'black' lw 4
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.07 center front
set label 3 center front tc rgb '#808080'
# variables
sx = 0.21
sy = 1.0
oriy1 = 0.044
orix1 = 0*sx + 0.06
orix2 = 1*sx + 0.07
orix3 = 2*sx + 0.08
orix4 = 3*sx + 0.09
f = 0
# functions
db(x) = 20*log10(x)
flabel = 'sprintf(''\footnotesize $f = %1.1f$ kHz'', f/1000.0)'

################################################################################
set multiplot layout 1,5

# set contours
set view map
unset surface
set contour base
set format '%g'
do for [f=1500:2500:500] {
  set cntrparam level incremental f/1000.0, 500.0/1000.0, f/1000.0
  set table sprintf('cont_f%d.txt', f)
  splot 'fS.dat' u 1:2:($3/1000) binary matrix w l
  unset table
}

#### plot 1 ####
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
unset colorbox
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_bottom_left
# variables
f = 1500
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 2 ####
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_bottom
# variables
f = 2000
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 3 ####
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_bottom
# variables
f = 2500
# labels
set label 1 @flabel
set label 3 at screen 0.83, 0.965
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 4 ####
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_bottom_right
# c-axis
set cbrange [1:3]
set cbtics 0.5
# labels
set label 1 '$\sffS(\sfpos)$'
set label 3 at graph 1.075, 1.075 'kHz'
# palette
set palette maxcolors 4
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette positive
# colorbar
set colorbox @colorbar_east
# plotting
plot 'fS.dat' u 1:2:($3/1000) binary matrix with image,\
  'array.txt' @array_active

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
