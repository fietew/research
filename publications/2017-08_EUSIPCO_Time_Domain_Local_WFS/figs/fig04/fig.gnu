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

load 'xyborder.cfg'

################################################################################
set t epslatex size 7.8cm,9cm color colortext header '\newcommand\ft\footnotesize\newcommand\st\scriptsize'
set output 'tmp.tex';

unset key # deactivate legend

load 'qualitative/Paired.plt'
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 1.0
SPACING_VERTICAL = 1.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_R = 0.0
OUTER_RATIO_T = 0.0
OUTER_RATIO_B = 1.0
INNER_RATIO_V = 0.0
# variables
Npos = 4 # number of spectra
# x-axis
set xrange [0.1:20]
set logscale x 10
set xtics offset 0,0.5
set xlabel offset 0,1
LABEL_X = '\ft $f / \mathrm{kHz}$'
# y-axis
set ylabel  offset 4,0
LABEL_Y = '\ft Magnitude / dB'
set yrange [-10:15]
set ytics 10 offset 0.5,0
set mytics 2
# grid
load 'grid.cfg'
set grid xtics ytics mxtics mytics
# labels
load 'labels.cfg'
set label 1 @label_northwest
# variables
ps_gt = 0
ps_wfs = 1
pw_gt = 2
pw_wfs = 3
ps_lsfs = 4
pw_lsfs = 5

################################################################################

set multiplot layout 4,2 columnsfirst

################################################################################
#### plot 1 #####
# labels
set label 1 '\ft $\sfposc = [0, 0, 0]^{\mathrm T} \mathrm m$'
set label 2 '\st PW - WFS' at 0.15, -5 left front tc ls 8
set label 3 '\st PW - LWFS' at 0.15, 5 left front tc ls 2
# positioning
@pos_top_left
# variables
pos = 1
# plot
load 'plot-pw.gnu'

#### plot 2 #####
# labels
set label 1 '\ft $\sfposc = [-0.5, 0, 0]^{\mathrm T} \mathrm m$'
# positioning
@pos_left
# variables
pos = 2
# plot
load 'plot-pw.gnu'

#### plot 3 #####
# labels
set label 1 '\ft $\sfposc = [0, -0.5, 0]^{\mathrm T} \mathrm m$'
# positioning
@pos_left
# variables
pos = 3
# plot
load 'plot-pw.gnu'

#### plot 4 #####
# labels
set label 1 '\ft $\sfposc = [0, 0.5, 0]^{\mathrm T} \mathrm m$'
# positioning
@pos_bottom_left
# variables
pos = 4
# plot
load 'plot-pw.gnu'

#### plot 5 #####
# labels
unset label 1
set label 2 '\st PS - WFS'
set label 3 '\st PS - LWFS'
# positioning
@pos_top_right
# variables
pos = 1
# plot
load 'plot-ps.gnu'

#### plot 6 #####
# positioning
@pos_right
# variables
pos = 2
# plot
load 'plot-ps.gnu'

#### plot 7 #####
# positioning
@pos_right
# variables
pos = 3
# plot
load 'plot-ps.gnu'

#### plot 8 #####
# positioning
@pos_bottom_right
# variables
pos = 4
# plot
load 'plot-ps.gnu'

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
