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

load 'border.cfg'
load 'array.cfg'
load 'labels.cfg'
load 'colorbar.cfg'

################################################################################
set t epslatex size 11.0cm,7.0cm color colortext
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_northwest

# axes
# set size ratio -1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

# x-axis
set xrange [0:90]
set xtics 15 offset 0,0.5
set xlabel 'source azimuth $\sfsphphi[subscript=s]$ / deg' offset 0,1

# y-axis
set yrange [0.1:4]
set ytics 1 offset 0.5,0
# set logscale y

# c-axis
load 'sequential/Blues.plt'
set cbrange [-10:10]
set cbtics 5
set cbtics add ('\footnotesize $0$\,dB' 0)

# colorbar
load 'colorbar.cfg'
unset colorbox

# margins
set tmargin 1.5
set bmargin 2.5

# variables
norm = 20*log10(1/(4*3.1414*4.0))

################################################################################

set multiplot layout 1,2

################################################################################

#### plot 1 #####

# labels
set label 1 '\footnotesize 2.5D ESA'
# y-axis
set ylabel 'Frequency / kHz' offset 3,0
# margins
set lmargin 5
set rmargin 1.5
# plotting
plot 'esa-rect.dat' using 1:($2/1000):($3-norm) binary matrix with image

################################################################################

#### plot 2 ####

# labels
set label 1 '\footnotesize 2.5D WFS'
# y-axis
unset ylabel
set format y ''
# colorbar
set colorbox @colorbar_east
# margins
set lmargin 0
set rmargin 6.5
# plotting
plot 'wfs.dat' using 1:($2/1000):($3-norm) binary matrix with image

################################################################################

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
