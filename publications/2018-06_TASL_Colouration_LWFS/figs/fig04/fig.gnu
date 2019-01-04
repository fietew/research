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
load 'standalone.cfg'
load 'xyborder.cfg'

################################################################################
set t epslatex size 8.9cm,5.0cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Set1.plt'
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 6.0
SPACING_VERTICAL = 3.0
OUTER_RATIO_L = 0.8
OUTER_RATIO_B = 0.75
# x-axis
set xrange [0.01:10]
set logscale x 10
set xtics offset 0,0.5
set xlabel offset 0,1.5
LABEL_X = '\ft $y_{\mathrm fs}$ / m'
# y-axis
set yrange [-45:25]
set ytics 20 offset 0.5,0
set mytics 2
set ylabel  offset 4,0
LABEL_Y = '\ft $20 \lg |P(\mathbf 0, \omega)|$'
# grid
load 'grid.cfg'
set grid xtics ytics mxtics mytics
# labels
load 'labels.cfg'

do for [ii=1:3]{
  set label ii    at graph  0.8, 0.95-0.1*ii right front tc ls ii '\ft focused source'
  set label ii+10 at graph 0.95, 0.95-0.1*ii right front tc ls ii
}
set label  4 at graph  0.8, 0.55 right front tc rgb 'black' '\ft point source'

################################################################################

# labels
set label 11  '\ft $0.1$ kHz'
set label 12  '\ft $1$ kHz'
set label 13  '\ft $10$ kHz'

# positioning
@pos_bottom_left
# plotting
plot for[ii=1:3] 'data.txt' u 1:1+ii w l ls ii lw 4,\
    'data.txt' u 1:5 w l lw 4 lc rgb 'black' dt 2

################################################################################
call 'pdflatex.gnu' 'fig'
