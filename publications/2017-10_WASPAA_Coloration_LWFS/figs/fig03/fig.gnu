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

################################################################################
set t epslatex size 16.8cm,6.5cm color colortext header '\newcommand\ft\footnotesize\newcommand\st\scriptsize'
set output 'tmp.tex'

unset key

# color palette
load 'qualitative/Paired.plt'
# labels
load 'labels.cfg'
set label 1 '\footnotesize noise' at 0.8,0.1 front tc ls 2
set label 2 '\footnotesize speech' at 0.8,-0.1 front tc ls 6
set label 3 @label_north
# border
load 'border.cfg'
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.5
SPACING_VERTICAL = 5.5
OUTER_RATIO_L = 0.5
OUTER_RATIO_R = 0.5
OUTER_RATIO_B = 0.8
INNER_RATIO_H = 0.5
# axes
set format '\ft $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [0.5:10.5]
set xtics rotate by 45 right
set xlabel offset 0,3
LABEL_X = 'condition'
# y-axis
set yrange [-1:1]
set ylabel offset 4.0,0
set ytics -1,1 offset 0.5,0.5 rotate by 45
set ytics add ('\ft\shortstack{no \\difference}' -1, '' 0, '\ft\shortstack{very \\different}' 1)
set mytics 5
LABEL_Y = 'perceived coloration'
# grid
load 'grid.cfg'
set grid mytics ytics
# functions
col2xlabel(x) = sprintf('\footnotesize %s', strcol(x))
# variables
Nsub = 20
shift = 0.15

set style increment user
################################################################################
set multiplot layout 1,3

#### plot 1 #####
# labels
set label 3 '\ft listener at $[0,0,0]^{\mathrm T}$ m'
# positioning
@pos_bottom_left
# plotting
plot for [ii=1:Nsub] 'all_set1.txt' u ($0-shift):7+ii ls 1 pt 13,\
     'all_set1.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 12 lw 2 ,\
     for [ii=1:Nsub] 'all_set2.txt' u ($0+shift):7+ii ls 5 pt 7,\
     'all_set2.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 6 lw 2 ,\
     'all_set2.txt' u 0:(NaN):xticlabels(col2xlabel(1)),\

#### plot 2 #####
# labels
set label 3 '\ft listener at $[-0.5,0.75,0]^{\mathrm T}$ m'
# positioning
@pos_bottom
# y-axis
set ytics -1,1
# plotting
plot for [ii=1:Nsub] 'all_set3.txt' u ($0-shift):7+ii ls 1 pt 13,\
     'all_set3.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 12 lw 2 ,\
     for [ii=1:Nsub] 'all_set4.txt' u ($0+shift):7+ii ls 5 pt 7,\
     'all_set4.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 6 lw 2 ,\
     'all_set2.txt' u 0:(NaN):xticlabels(col2xlabel(1)),\

#### plot 3 #####
# labels
unset label 2
set label 3 '\ft listener at $[-0.5,0.75,0]^{\mathrm T}$ m'
# positioning
@pos_bottom_right
# plotting
plot for [ii=1:Nsub] 'all_set5.txt' u 0:7+ii ls 1 pt 13,\
     'all_set5.txt' u 0:3:6:7 w yerrorbars ls 2 pt 12 lw 2,\
     'all_set5.txt' u 0:(NaN):xticlabels(col2xlabel(1)),\

unset multiplot

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
