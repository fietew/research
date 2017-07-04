#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2017      Fiete Winter                                       *
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
load 'moreland.pal'
load 'array.cfg'

set style line 11 lc rgb 'black' lt 2 lw 4 ps 0.75

################################################################################
set t epslatex size 11cm,6cm color colortext header '\newcommand\ft\footnotesize'
set output 'tmp.tex';

# legend
unset key
# labels
set label 1 at graph 1.0,1.2 right front
set label 2 at graph 1.15, 0.5 center rotate by 90
# axes
set tics scale 0.75 out nomirror
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 0.5
# colorbar
load 'colorbar.cfg'
unset colorbox

################################################################################

set multiplot
set size 0.20, 0.40
set size ratio 0.5

################################################################################
#### Plot 1-4, window functions #####
# x-axis
set xrange [-0.6:19]
set xtics (0,13,'\ft $\infty$' 19) offset 0,0.5
set xlabel offset 0,1.5
LABEL_X = '\ft $m$'
# y-axis
set yrange [0:1]
set ytics 1 offset 0.5,0
set ylabel offset 4.0,0
LABEL_Y = '\ft $w_m$'
# arrows
set arrow 1 from 16.3,-0.1 to 17.3,0.1 nohead ls 101 # Inf break
set arrow 2 from 16.7,-0.1 to 17.7,0.1 nohead ls 101 #    "

#### plot 1 #####
set origin 0.05,0.6
# border
load 'xyborder.cfg'
# c-axis
load 'blues.pal'
# labels
set label 1 '\ft no bandwidth limitation'
# positioning
@pos_bottom_left
# plotting
plot 'wm_posx0.00_posy0.00_ref.txt' u 1:2 w impulses ls 7 lw 2, \
     ''                             u 1:2 w points ls 7 pt 6 ps 0.5 lw 2, \
     "<echo '19 1'"                 u 1:2 w impulses ls 7 lw 2, \
     "<echo '19 1'"                 u 1:2 w points ls 7 pt 6 ps 0.5 lw 2

#### plot 2 #####
set origin 0.275,0.6
# c-axis
load 'reds.pal'
# labels
set label 1 '\ft $M=7$, rect.'
# positioning
@pos_bottom
# plotting
plot 'wm_posx0.00_posy0.00_pw_wo07_wrect.txt' u 1:2 w impulses ls 7 lw 2, \
     ''                                       u 1:2 w points ls 7 pt 6 ps 0.5 lw 2, \
     "<echo '19 0'"                           u 1:2 w points ls 7 pt 6 ps 0.5 lw 2

#### plot 3 #####
set origin 0.5,0.6
# labels
set label 1 '\ft $M=13$, rect.'
# positioning
@pos_bottom
# plotting
plot 'wm_posx0.00_posy0.00_pw_wo13_wrect.txt' u 1:2 w impulses ls 7 lw 2, \
     ''                                       u 1:2 w points ls 7 pt 6 ps 0.5 lw 2, \
     "<echo '19 0'"                           u 1:2 w points ls 7 pt 6 ps 0.5 lw 2

#### plot 4 #####
set origin 0.725,0.6
# c-axis
load 'greens.pal'
# labels
set label 1 '\ft $M=13$, max-$r_E$'
set label 2 '\scriptsize window functions'
# positioning
@pos_bottom_right
# plotting
plot 'wm_posx0.00_posy0.00_pw_wo13_wmax-rE.txt' u 1:2 w impulses ls 7 lw 2, \
     ''                                         u 1:2 w points ls 7 pt 6 ps 0.5 lw 2, \
     "<echo '19 0'"                             u 1:2 w points ls 7 pt 6 ps 0.5 lw 2

################################################################################
#### Plot 5-8, sound field plots #####
set size 0.20, 0.40
set size ratio -1
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.0
LABEL_X = '\ft $x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 4.0,0
LABEL_Y = '\ft $y$ / m'
# borders
load 'xyborder.cfg'
# c-axis
set cbrange [-60:0]
# labels
unset label 1

#### plot 5 #####
set origin 0.05,0.2
# labels
set label 2 ''
# positioning
@pos_bottom_left
# c-axis
load 'blues.pal'
# plotting
plot 'soundfield_posx0.00_posy0.00_ref.dat' binary matrix with image

#### plot 6 #####
set origin 0.275,0.2
# positioning
@pos_bottom
# c-axis
load 'reds.pal'
# plotting
plot 'soundfield_posx0.00_posy0.00_pw_wo07_wrect.dat' binary matrix with image

#### plot 7 #####
set origin 0.5,0.2
# positioning
@pos_bottom
# plotting
plot 'soundfield_posx0.00_posy0.00_pw_wo13_wrect.dat' binary matrix with image

#### plot 8 #####
set origin 0.725,0.2
# labels
set label 2 '\scriptsize bandlimited sound field'
# c-axis
load 'greens.pal'
# positioning
@pos_bottom_right
# plotting
plot 'soundfield_posx0.00_posy0.00_pw_wo13_wmax-rE.dat' binary matrix with image

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'

