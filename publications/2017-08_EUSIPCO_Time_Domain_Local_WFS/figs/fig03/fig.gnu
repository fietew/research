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
load 'array.cfg'
load 'labels.cfg'
load 'colorbar.cfg'

################################################################################
set t epslatex size 17.2cm,7.0cm color colortext header '\newcommand\ft\footnotesize\newcommand\st\scriptsize'
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_north
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 1.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_R = 0.75
OUTER_RATIO_B = 1.0
INNER_RATIO_V = 0.0
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
# c-axis
load 'sequential/Blues.plt'
set cbrange [-60:0]
set cbtics 20
# colorbar
load 'colorbar.cfg'
unset colorbox

################################################################################

set multiplot layout 2,5 rowsfirst

################################################################################
#### plot 1 #####
# labels
set label 1 '\ft PW - LWFS, Sec.~\ref{sec:pw}'
# positioning
@pos_top_left
# variables
xeval = '0.00'
yeval = '0.00'
src = 'pw'
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_lwfs-sbl_NLS56_xref0.00_yref0.00'
load 'plot.gnu'

#### plot 2 #####
# labels
set label 1 '\ft PW - WFS \cite[Eq.~(2.177)]{Schultz2016-PHD}'
# positioning
@pos_top
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_wfs_NLS56_xref0.00_yref0.00'
load 'plot.gnu'

#### plot 3 #####
# labels
set label 1 '\ft PS - LWFS, Eq.~\eqref{eq:ps_crossover_noap}'
# positioning
@pos_top
# variables
src = 'ps'
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_lwfs-sbl_NLS56_xref0.00_yref0.00'
load 'plot.gnu'

#### plot 4 #####
# labels
set label 1 '\ft PS - LWFS, Eq.~\eqref{eq:ps_crossover_ap}'
set label 2 ''
# positioning
@pos_top
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_lwfs-sbl_NLS56_ap_xref0.00_yref0.00'
load 'plot.gnu'

#### plot 5 ####
# labels
set label 1 '\ft PS - WFS \cite[Eq.~(2.137)]{Schultz2016-PHD}'
# positioning
@pos_top_right
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_wfs_NLS56_xref0.00_yref0.00'
load 'plot.gnu'

#### plot 6 ####
# labels
unset label 1
# positioning
@pos_bottom_left
# variables
xeval = '-0.75'
yeval = '0.75'
src = 'pw'
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_lwfs-sbl_NLS56_xref-0.75_yref0.75'
load 'plot.gnu'

#### plot 7 ####
# labels
unset label 1
# positioning
@pos_bottom
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_wfs_NLS56_xref0.00_yref0.00'
load 'plot.gnu'

#### plot 8 ####
# labels
unset label 1
# positioning
@pos_bottom
# variables
src = 'ps'
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_lwfs-sbl_NLS56_xref-0.75_yref0.75'
load 'plot.gnu'

#### plot 9 #####
# positioning
@pos_bottom
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_lwfs-sbl_NLS56_ap_xref-0.75_yref0.75'
load 'plot.gnu'

#### plot 10 ####
# positioning
@pos_bottom_right
# plotting
filename = 'x'.xeval.'_y'.yeval.'_'.src.'_wfs_NLS56_xref0.00_yref0.00'
load 'plot.gnu'

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
