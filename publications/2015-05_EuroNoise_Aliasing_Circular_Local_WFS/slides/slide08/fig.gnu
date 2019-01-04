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

################################################################################
set t epslatex size 9cm,4cm color colortext
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_northeast '\footnotesize $R_0 = 1.5$m'
set label 2 @label_northwest
set label 3 @label_multititle \
  '\footnotesize $\accentset{\circ} G_0(\nu, r, \omega)$'

# x-axis
set xrange [-55:55]
set xtics (-40,40) offset 0,0.5
set xlabel '$\nu$ / 1' offset 0, 1

# y-axis
set yrange [0:3000]
set ytics 1000 offset 0.5,0
set ylabel '$f$ / Hz' offset 3.5,0

# colorbar
load 'sequential/Blues.plt'
load 'colorbar.cfg'
set cbrange [-150:0]
set cbtics 50 offset -0.5,0
set cbtics add ('\footnotesize $0$\,dB' 0)
unset colorbox

# axes
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

# margins
set bmargin 0.5
set tmargin 0.5
set lmargin 1.5
set rmargin 2.5

################################################################################
set multiplot layout 1,2

# plot 1
set label 2 '\footnotesize $r = 0.5$m'
plot 'spectrum_G0_r0.5.dat' binary matrix with image

# plot 2
set format y '' # remove labels of tics
unset ylabel # remove label of y-axis
unset label 3
set colorbox @colorbar_east
set label 2 '\footnotesize $r = 1.0$m'
plot 'spectrum_G0_r1.0.dat' binary matrix with image

unset multiplot

################################################################################
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
