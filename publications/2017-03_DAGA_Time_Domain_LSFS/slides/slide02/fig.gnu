#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2013-2018 Fiete Winter                                       *
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
load 'Moreland.plt'
load 'array.cfg'

set style line 11 lc rgb 'black' lt 2 lw 4 ps 0.75

################################################################################
set t epslatex size 10cm,5.5cm color colortext header '\newcommand\ft\footnotesize'
set output 'tmp.tex';

# legend
unset key
# labels
load 'labels.cfg'
set label 1 @label_northeast
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 1.0
SPACING_VERTICAL = 1.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_R = 0.0
OUTER_RATIO_B = 1.0
INNER_RATIO_V = 0.0
INNER_RATIO_H = 1.0
# axes
set size ratio -1
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
# colorbar
load 'colorbar.cfg'
unset colorbox

################################################################################

set multiplot layout 2,4 columnsfirst

################################################################################
#### plot 1 #####
# c-axis
load 'Moreland.plt'
set cbrange [-1:1]
# labels
set label 1 '\ft 1 kHz'
# positioning
@pos_top_left
# plotting
filename = 'P_wfs_f1000'
load 'plot_sfs.cfg'

#### plot 2 #####
# labels
set label 1 ''
# positioning
@pos_bottom_left
# plotting
filename = 'P_gt_f1000'
load 'plot_gt.cfg'

#### plot 3 #####
# labels
set label 1 '\ft 2 kHz'
# positioning
@pos_top
# plotting
filename = 'P_wfs_f2000'
load 'plot_sfs.cfg'

#### plot 4 #####
# labels
set label 1 ''
# positioning
@pos_bottom
# plotting
filename = 'P_gt_f2000'
load 'plot_gt.cfg'

#### plot 5 #####
# labels
set label 1 '\ft 3 kHz'
# positioning
@pos_top
# plotting
filename = 'P_wfs_f3000'
load 'plot_sfs.cfg'

#### plot 6 #####
# labels
set label 1 ''
# positioning
@pos_bottom
# plotting
filename = 'P_gt_f3000'
load 'plot_gt.cfg'

#### plot 7 #####
# c-axis
load 'sequential/Blues.plt'
set cbrange [-60:0]
# labels
set label 1 '\ft broadband'
# positioning
@pos_top_right
# plotting
filename = 'p_wfs'
load 'plot_sfs.cfg'

#### plot 8 #####
# labels
set label 1 ''
# positioning
@pos_bottom_right
# plotting
filename = 'p_gt'
load 'plot_gt.cfg'

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
