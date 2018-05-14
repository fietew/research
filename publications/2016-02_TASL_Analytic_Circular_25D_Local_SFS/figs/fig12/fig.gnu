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
set t epslatex size 8.7cm,4.5cm color colortext
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_northwest

# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel '$x_c$ / m' offset 0,1

# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel '$y_c$ / m' offset 4.0,0

# c-axis
load 'sequential/Greens.plt'
set cbrange [0:1.0]
set cbtics 0.5
set cbtics add ('\footnotesize $0$\,m' 0)

# colorbar
load 'colorbar.cfg'
unset colorbox

# axes
set size ratio -1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

# margins
set tmargin 0.75
set bmargin 1.0

################################################################################

set multiplot layout 1,2

################################################################################

#### plot 1 #####

# labels
set label 1 '\footnotesize $f=3000$ Hz'

# margins
set lmargin 4.75
set rmargin 0.25

# plotting
plot 'rM_f3000.dat' binary matrix with image,\
  'array.txt' @array_active

################################################################################

#### plot 2 ####

# labels
set label 1 '\footnotesize $f=5000$ Hz'

# colorbar
set colorbox @colorbar_east

# margins
set lmargin 0.25
set rmargin 4.75

# plotting
plot 'rM_f5000.dat' binary matrix with image,\
  'array.txt' @array_active

################################################################################

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
