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
set t epslatex size 18.7cm,6.5cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

# some stats
stats 'eta0_rays.txt' skip 1 nooutput
colrays = STATS_columns/2
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
set yrange [-0.25:2]
set ytics 1 offset 0.5,0
set ylabel offset 3,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# palette
set palette maxcolor 0
# colorbar
load 'colorbar.cfg'
# axes
set size ratio -1
set tics scale 0.75 out nomirror
# style
set style line 101 lc rgb 'cyan' pt 7 ps 1 linewidth 3
set style line 102 lc rgb 'white' pt 7 ps 1 linewidth 3
set style line 103 lc rgb 'yellow' pt 7 ps 1 linewidth 3
set style line 104 lc rgb '#00AA00' pt 7 ps 1 linewidth 3
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.075 center front
set label 2 at graph 0.0, 1.075 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 3 center front tc rgb '#808080'
# variables
sx = 0.17
sy = 0.45
dx = 0.01
oriy1 = 0.53
oriy2 = 0.075
orix1 = 0*sx + 1*dx + 0.04
orix2 = 1*sx + 2*dx + 0.04
orix3 = 2*sx + 3*dx + 0.04
orix4 = 3*sx + 4*dx + 0.04
orix5 = 4*sx + 5*dx + 0.06
vlen = 0.12
eta = 0
# functions
db(x) = 20*log10(x)
Plabel(x) = sprintf('\ft $\sfpressure[superscript=sampled]_{%d}(\sfx,\sfy,\sfomega)$', x)
epslabel(x) = sprintf('\ft $\hat\varepsilon_{%d,\mathrm{SPA}}(\sfx,\sfy,\sfomega)$',x)

################################################################################
set multiplot layout 1,5

#### plot 1 ####
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
unset colorbox
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
# variables
eta = 0
# labels
set label 1 Plabel(eta)
# plotting
load 'plotP.gnu'

#### plot 2 ####
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# variables
eta = 1
# labels
set label 1 Plabel(eta)
# plotting
load 'plotP.gnu'

#### plot 3 ####
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top
# variables
eta = 2
# labels
set label 1 Plabel(eta)
# plotting
load 'plotP.gnu'

#### plot 4 ####
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_top
# colorbar
set colorbox vert user origin screen 0.8, 0.570 size graph 0.05,1.0
# variables
eta = 3
# labels
set label 1 Plabel(eta)
set label 3 at screen 0.83, 0.965
# plotting
load 'plotP.gnu'

#### plot 5 ####
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# c-axis
set cbrange [-40:0]
set cbtics 10
# palette
load 'sequential/Reds.plt'  # see gnuplot-colorbrewer
set palette positive
set palette maxcolors 0
# colorbar
unset colorbox
# variables
eta = 0
# labels
set label 1 epslabel(eta)
set label 3 ''
# plotting
load 'ploteps.gnu'

#### plot 6 ####
# variables
eta = '1'
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom
# variables
eta = 1
# labels
set label 1 epslabel(eta)
# plotting
load 'ploteps.gnu'

#### plot 7 ####
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# variables
eta = 2
# labels
set label 1 epslabel(eta)
# plotting
load 'ploteps.gnu'

#### plot 8 ####
# positioning
set size sx, sy
set origin orix4, oriy2
@pos_bottom
# colorbar
set colorbox vert user origin screen 0.875, 0.570 size graph 0.05,1.0
# variables
eta = 3
# labels
set label 1 epslabel(eta)
set label 3 at screen 0.880, 0.96 '\ft dB'
# plotting
load 'ploteps.gnu'

#### plot 9 ####
# positioning
set size sx, sy
set origin orix5, oriy2
@pos_bottom_right
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# labels
set label 1 '\ft $\sfvirtualsource(\sfx,\sfy,\sfomega)$'
# colorbar
unset colorbox
# plotting
plot 'eta0_S.dat' binary matrix with image

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
