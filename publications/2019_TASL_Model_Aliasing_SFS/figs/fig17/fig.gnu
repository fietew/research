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
set t epslatex size 8.7cm,8.5cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 4,0
LABEL_Y = '$y$ / m'
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
load 'colorbar.cfg'
unset colorbox
# axes
set size ratio -1
set tics scale 0.75 out nomirror
# style
set style line 1 lc rgb 'black' lw 4
set style line 2 lc rgb 'cyan' lw 3
set style line 3 lc rgb 'cyan' lw 3 dt 3
set style line 4 lc rgb 'magenta' lw 3
set style line 5 lc rgb 'magenta' lw 3 dt 3
set style line 6 lc rgb 'green' lw 3 pt 7 ps 1
set style line 7 lc rgb 'green' lw 4

# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.075 center front
set label 2 at graph 1.1, 1.15 center front
set label 3 center front tc rgb '#808080'
set label 4 at graph 0.0, 1.075 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# variables
sx = 0.375
sy = 0.4
orix1 = 0.105
orix2 = 0.5
oriy1 = 0.55
oriy2 = 0.095

################################################################################
set multiplot

#### plot 1 ####
# labels
set label 1 '\ft $\sfRc = 0.15$ m'
# positioning
@pos_top_left
set size sx,sy
set origin orix1,oriy1
# variables
prefix = '_Rc0.15'
oldnew = 0
# plotting
plot 'P'.prefix.'.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'Cl.txt' u 1:2 w l ls 1,\
  'xl.txt' u 1:2 w p ls 1 pt 2 ps 1,\
  'Cc'.prefix.'.txt' u 1:2 w l ls 2,\
  'xc.txt' u 1:2 w p ls 2 pt 2 ps 1,\
  'rays'.prefix.'.txt' u 1:2 w l ls 2,\
  '' u 3:4 w l ls 3,\
  '' u 5:6 w l ls 3,\
  '' u  7+oldnew: 8+oldnew w l ls 4,\
  '' u  9+oldnew:10+oldnew w l ls 5,\
  '' u 11+oldnew:12+oldnew w l ls 5,\
  '' every ::0::0 u 1:2 w p ls 6

#### plot 2 ####
# labels
set label 1 '\ft $\sfRc = 0.15$ m'
# positioning
@pos_top_right
set size sx,sy
set origin orix2,oriy1
# variables
oldnew = 6
# plotting
plot 'P'.prefix.'.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'Cl.txt' u 1:2 w l ls 1,\
  'xl.txt' u 1:2 w p ls 1 pt 2 ps 1,\
  'Cc'.prefix.'.txt' u 1:2 w l ls 2,\
  'xc.txt' u 1:2 w p ls 2 pt 2 ps 1,\
  'rays'.prefix.'.txt' u 1:2 w l ls 2,\
  '' u 3:4 w l ls 3,\
  '' u 5:6 w l ls 3,\
  '' u  7+oldnew: 8+oldnew w l ls 4,\
  '' u  9+oldnew:10+oldnew w l ls 5,\
  '' u 11+oldnew:12+oldnew w l ls 5,\
  'array_select'.prefix.'.txt' w l ls 7

#### plot 3 ####
# labels
set label 1 '\ft $\sfRc = 0.5$ m'
# positioning
@pos_bottom_left
set size sx,sy
set origin orix1,oriy2
# variables
prefix = '_Rc0.50'
oldnew = 0
# plotting
plot 'P'.prefix.'.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'Cl.txt' u 1:2 w l ls 1,\
  'xl.txt' u 1:2 w p ls 1 pt 2 ps 1,\
  'Cc'.prefix.'.txt' u 1:2 w l ls 2,\
  'xc.txt' u 1:2 w p ls 2 pt 2 ps 1,\
  'rays'.prefix.'.txt' u 1:2 w l ls 2,\
  '' u 3:4 w l ls 3,\
  '' u 5:6 w l ls 3,\
  '' u  7+oldnew: 8+oldnew w l ls 4,\
  '' u  9+oldnew:10+oldnew w l ls 5,\
  '' u 11+oldnew:12+oldnew w l ls 5,\
  '' every ::0::0 u 1:2 w p ls 6

#### plot 4 ####
# labels
set label 1 '\ft $\sfRc = 0.5$ m'
# colorbar
set colorbox @colorbar_east
# positioning
@pos_bottom_right
set size sx,sy
set origin orix2,oriy2
# variables
oldnew = 6
# plotting
plot 'P'.prefix.'.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'Cl.txt' u 1:2 w l ls 1,\
  'xl.txt' u 1:2 w p ls 1 pt 2 ps 1,\
  'Cc'.prefix.'.txt' u 1:2 w l ls 2,\
  'xc.txt' u 1:2 w p ls 2 pt 2 ps 1,\
  'rays'.prefix.'.txt' u 1:2 w l ls 2,\
  '' u 3:4 w l ls 3,\
  '' u 5:6 w l ls 3,\
  '' u  7+oldnew: 8+oldnew w l ls 4,\
  '' u  9+oldnew:10+oldnew w l ls 5,\
  '' u 11+oldnew:12+oldnew w l ls 5,\
  'array_select'.prefix.'.txt' w l ls 7

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
