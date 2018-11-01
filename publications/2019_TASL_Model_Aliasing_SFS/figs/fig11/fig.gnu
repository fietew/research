#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2018      Fiete Winter                                       *
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
set t epslatex size 18.7cm,8.0cm color colortext standalone header ieeetran10pt.normal
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
set ylabel offset 4,0
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
set label 2 at graph 0.0, 1.07 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 3 center front tc rgb '#808080'
# variables
sx = 0.17
sy = 0.45
dx = 0.01
oriy1 = 0.52
oriy2 = 0.065
orix1 = 0*sx + 1*dx + 0.04
orix2 = 1*sx + 2*dx + 0.04
orix3 = 2*sx + 3*dx + 0.04
orix4 = 3*sx + 4*dx + 0.04
orix5 = 4*sx + 5*dx + 0.06
f = 0
# functions
db(x) = 20*log10(x)
flabel = 'sprintf(''\footnotesize $f = %1.1f$ kHz'', f/1000.0)'

################################################################################
set multiplot layout 1,5

set view map
unset surface
set contour base
# set cntrlabel format '%8.3g' font ',7' start 0 interval 1000
# set cntrparam order 4
# set cntrparam points 5
# set cntrparam bspline
set format '%g'
do for [f=1000:2500:500] {
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
@pos_top_left
# variables
f = 1000
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 2 ####
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# variables
f = 1500
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 3 ####
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top
# variables
f = 2000
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 4 ####
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_top
# variables
f = 2500
# labels
set label 1 @flabel
set label 3 at screen 0.83, 0.965
# colorbar
set colorbox vert user origin screen 0.8, 0.5475 size graph 0.05,1.0
# labels
set label 1 @flabel
# plotting
load 'plotP.gnu'

#### plot 5 ####
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# c-axis
set cbrange [-15:10]
set cbtics 5
# palette
load 'sequential/Reds.plt'  # see gnuplot-colorbrewer
set palette positive
set palette maxcolors 0
# colorbar
unset colorbox
# variables
f = 1000
# labels
set label 1 @flabel
# plotting
load 'ploteps.gnu'

#### plot 6 ####
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom

# variables
f = 1500
# labels
set label 1 @flabel
# plotting
load 'ploteps.gnu'

#### plot 7 ####
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# variables
f = 2000
# labels
set label 1 @flabel
set label 4 ''
# plotting
load 'ploteps.gnu'

#### plot 8 ####
# positioning
set size sx, sy
set origin orix4, oriy2
@pos_bottom
# colorbar
set colorbox vert user origin screen 0.8625, 0.5475 size graph 0.05,1.0
# variables
f = 2500
# labels
set label 1 @flabel
# labels
set label 3 at screen 0.8675, 0.965 '\footnotesize dB'
# plotting
load 'ploteps.gnu'

#### plot 9 ####
# positioning
set size sx, sy
set origin orix5, oriy2
@pos_bottom_right
# c-axis
set cbrange [1:3]
set cbtics 0.5
# labels
set label 1 '\footnotesize $\sffS(\sfpos)$'
set label 3 at screen 0.93, 0.965 '\footnotesize kHz'
# palette
set palette maxcolors 4
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette positive
# colorbar
set colorbox vert user origin screen 0.925, 0.5475 size graph 0.05,1.0
# plotting
plot 'fS.dat' u 1:2:($3/1000) binary matrix with image,\
  'array.txt' @array_active

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
