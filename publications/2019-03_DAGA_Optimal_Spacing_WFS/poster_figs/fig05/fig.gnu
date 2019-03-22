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
load 'array.cfg' # for @array_active
load 'localization.cfg' # @point_source

################################################################################
set t epslatex size @intposterhalfwidth,12cm color colortext standalone header intpostera0
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Paired.plt'
set style line 10 lc rgb 'black'
# positioning
load 'positions.cfg'
# variables
Nxc = 4
NRc = 2
# labels
load 'labels.cfg'
set label 5 at graph 0.0, screen 0.94 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 6 at graph 0.5, screen 0.94 center front
# function
calc_index(nx,nr) = (nx-1)*NRc + nr
calc_shift(x) = x == 4 ? -0.6 : 0.6

################################################################################

set multiplot

################################################################################
#### plot 1 #####
# labels
set label 1 at first 0, 1.6 center '$\overset{u}{\rightarrow}$'
set label 2 at +1.8*cos(pi/4), 1.8*sin(pi/4) center front rotate by -45 '$+\frac{\pi}{4}$'
set label 3 at -1.8*cos(pi/4), 1.8*sin(pi/4) center front rotate by +45 '$-\frac{\pi}{4}$'
set label 6 'scenario'
# arrows
set arrow 1 from +1.4*cos(pi/4), 1.4*sin(pi/4) to +1.6*cos(pi/4), 1.6*sin(pi/4) nohead lw 2 lc rgb 'black'
set arrow 2 from -1.4*cos(pi/4), 1.4*sin(pi/4) to -1.6*cos(pi/4), 1.6*sin(pi/4) nohead lw 2 lc rgb 'black'
# x-axis
set xrange [-1.50:1.50]
LABEL_X = ''
# y-axis
set yrange [-1.5:2.55]
LABEL_Y = ''
# positioning
SPACING_HORIZONTAL = 0
SPACING_VERTICAL = 0.35
OUTER_RATIO_B = 1.0
OUTER_RATIO_L = 0.0
set size 0.175, 1.0
set size ratio -1
set origin 0.01, 0.0
@pos_bottom_left
# border
load 'noborder.cfg'
unset xtics
unset ytics
# plotting
set parametric
set trange [0:2*pi]
plot 1.5*cos(t), 1.5*sin(t) w l lw 2 lc rgb 'grey',\
  for [ii=2:4] ii*0.1*cos(t), ii*0.1*sin(t)+2.5 w l lw 2 lc rgb 'grey',\
  'array.txt' w l lw 4 lc rgb 'black',\
  set_point_source(0,2.5) @point_source,\
  for[ii=1:Nxc] for[jj=1:NRc] 'circles.txt' u 2*calc_index(ii,jj)-1:2*calc_index(ii,jj) w l ls calc_index(ii,jj) lw 5 dt jj

#### plot 2 #####
# border
load 'xyborder.cfg'
# labels
unset label 1
unset label 2
unset label 3
set label 4 at graph 0.05, 0.75 left front '\shortstack[l]{larger\\spacing}'
set label 6 'arbitrary sound field'
# arrows
unset arrow 1
unset arrow 2
set arrow 3 from graph 0.025, 0.6 to graph 0.025, 0.9 head filled lw 4 lc rgb 'black'
# x-axis
set xrange [-acos(1.5/2.5):acos(1.5/2.5)]
set xlabel offset 0,-2.0
set xtics offset 0,-1.0 (0, '+$\frac{\pi}{4}$' pi/4.0, '$-\frac{\pi}{4}$' -pi/4.0)
LABEL_X = '$u / \mathrm{rad}$'
# y-axis
set ylabel offset -4,0
set yrange [0.9:1.2]
set ytics 0.1 offset 0.5,0
LABEL_Y = 'normalised spacing'
# grid
load 'grid.cfg'
set grid ytics xtics
# positioning
SPACING_HORIZONTAL = 12.0
SPACING_VERTICAL = 10
OUTER_RATIO_B = 0.6
OUTER_RATIO_L = 0.95
set size 0.4, 1.0
set size noratio
set origin 0.225, 0.0
@pos_bottom_left
# plotting
plot for[ii=1:Nxc] for[jj=1:NRc] 'ratio_pos.txt' u 1:calc_index(ii,jj)+1 w l ls calc_index(ii,jj) lw 5 dt jj

#### plot 3 #####
# labels
set label 6 'known sound field'
# y-axis
set yrange [0.5:6.5]
set ytics 0.5,2.0
LABEL_Y = ''
# positioning
set origin 0.6, 0.0
@pos_bottom_left
# plotting
plot for[ii=1:Nxc] for[jj=1:NRc] 'ratio_both.txt' u 1:calc_index(ii,jj)+1 w l ls calc_index(ii,jj) lw 5 dt jj,\

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
