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
load 'sequential/Blues.plt'
load 'labels.cfg'
load 'colorbar.cfg'

################################################################################
set t epslatex size 8cm,4cm color colortext
set output 'tmp.tex'

unset key

# labels
set label 1 @label_north

# axes
set xrange [-40:40]
set yrange [0:2000]
set cbrange [-200:0]

set xtics 40 offset 0,0.5
set ytics 500 offset 0.5,0
set cbtics 50
set tics scale 0.75 out nomirror

set xlabel '$\kx$ / m' offset 0,1
set ylabel '$f$ / Hz' offset 3.5,0
set format '\footnotesize $%g$'
unset colorbox

# margins
set bmargin 0
set tmargin 0
set lmargin 1.5
set rmargin 1.5

################################################################################
set multiplot layout 1,2

# plot 1
set label 1 '\footnotesize $\tilde D_\lsindex(\kx, \omega)$'
plot 'spectrum_D0.dat' binary matrix with image

# plot 2
set format y '' # remove labels of tics
unset ylabel # remove label of y-axis
set colorbox @colorbar_east
set label 1 '\footnotesize $\tilde G_\lsindex(\kx, y, \omega)$'
plot 'spectrum_G0.dat' binary matrix with image

unset multiplot

################################################################################
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
