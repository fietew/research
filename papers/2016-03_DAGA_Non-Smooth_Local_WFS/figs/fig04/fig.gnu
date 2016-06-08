#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2016      Fiete Winter                                       *
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
set t epslatex size 17.0cm,4cm color colortext
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
set xrange [1:64]
set xtics 16 offset 0,0.5
set xlabel 'Loudspeaker' offset 0,1

# y-axis
set yrange [0:90]
set ytics 15 offset 0.5,0

# c-axis
load 'blues.pal'
set cbrange [-60:0]
set cbtics 10
set cbtics add ('\footnotesize $0$\,dB' 0)
# colorbar
load 'colorbar.cfg'
unset colorbox
# margins
set tmargin 0.75
set bmargin 1.25

################################################################################

set multiplot layout 1,5

################################################################################

#### plot 1 #####

# labels
set label 1 '\footnotesize ESA'
# y-axis
set ylabel '$\sfsphphi[subscript=s]$ / deg' offset 4,0
# margins
set lmargin 2
set rmargin 0
# plotting
plot 'esa-rect.dat' using 2:1:3 binary matrix with image

################################################################################

#### plot 2 #####

# labels
set label 1 '\footnotesize WFS'
# y-axis
unset ylabel
set format y ''
# margins
set lmargin 1.0
set rmargin 1.0
# plotting
plot 'wfs.dat' using 2:1:3 binary matrix with image

################################################################################

#### plot 3 ####

# labels
set label 1 '\footnotesize LWFS $R_c=0$ m'
# plotting
plot 'lwfs_3.50_0.00.dat' using 2:1:3 binary matrix with image

################################################################################

#### plot 4 ####

# labels
set label 1 '\footnotesize LWFS $R_c=1$ m'
# plotting
plot 'lwfs_3.50_1.00.dat' using 2:1:3 binary matrix with image

################################################################################

#### plot 5 ####

# labels
set label 1 '\footnotesize LWFS $R_c=1.75$ m'
# colorbar
set colorbox @colorbar_east
# margins
set lmargin 0
set rmargin 2
# plotting
plot 'lwfs_3.50_1.75.dat' using 2:1:3 binary matrix with image

################################################################################

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
