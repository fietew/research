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
load 'array.cfg'

set style line 11 lc rgb 'black' lt 2 lw 4 ps 0.75

################################################################################
set t epslatex size 11cm,4cm color colortext header '\newcommand\ft\footnotesize'
set output 'tmp.tex';

# legend
unset key
# labels
load 'labels.cfg'
set label 1 @label_northeast
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 0.5
# axes
set format '\ft $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.0
LABEL_X = '\ft $x$ / m'
# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel offset 4.0,0
LABEL_Y = '\ft $y$ / m'
# c-axis
set cbrange [-60:0]
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
unset colorbox

################################################################################

set multiplot
set size 0.225, 0.95
set size ratio -1

################################################################################
#### plot 1 #####
set origin 0.025,0.1
# labels
set label 1 '\ft no bandlimitation'
# c-axis
load 'sequential/Blues.plt'
# positioning
@pos_bottom_left
# plotting
plot 'soundfield_posx0.00_posy0.00_ref.dat' binary matrix with image, \
     'positions.txt' every ::::0 u 1:2 w p lc rgb "black" pt 9 ps 1.5, \
     'positions.txt' every ::::0 u 1:($2-0.3):('\\ft 1') w labels tc rgb "black"

#### plot 2 #####
set origin 0.275,0.1
# labels
set label 1 '\ft $M=13$, rect.'
# c-axis
load 'sequential/Reds.plt'
# positioning
@pos_bottom
# plotting
plot 'soundfield_posx0.00_posy0.00_pw_wo13_wrect.dat' binary matrix with image, \
     'positions.txt' every ::::0 u 1:2 w p lc rgb "black" pt 9 ps 1.5, \
     'positions.txt' every ::::0 u 1:($2-0.3):('\\ft 1') w labels tc rgb "black"


#### plot 3 #####
set origin 0.525,0.1
# labels
set label 1 '\ft $M=13$, max-$r_E$'
# c-axis
load 'sequential/Greens.plt'
# positioning
@pos_bottom
# plotting
plot 'soundfield_posx0.00_posy0.00_pw_wo13_wmax-rE.dat' binary matrix with image, \
     'positions.txt' every ::::0 u 1:2 w p lc rgb "black" pt 9 ps 1.5, \
     'positions.txt' every ::::0 u 1:($2-0.3):('\\ft 1') w labels tc rgb "black"


#### plot 4 #####
set origin 0.775,0.1
# labels
set label 1 '\ft $M=27$, max-$r_E$'
# positioning
@pos_bottom_right
# plotting
plot 'soundfield_posx0.00_posy0.00_pw_wo27_wmax-rE.dat' binary matrix with image, \
     'positions.txt' u 1:2 w p lc rgb "black" pt 9 ps 1.5, \
     'positions.txt' every ::::0 u 1:($2-0.3):('\\ft 1') w labels tc rgb "black", \
     'positions.txt' u 1:($2+0.3):('\\ft 2') w labels tc rgb "black"


################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
