#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2015      Fiete Winter                                       *
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
set t epslatex size 8.7cm,8cm color colortext
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_northeast
set label 2 @label_northwest

# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5

# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0

# colorbar
load 'colorbar.cfg'
unset colorbox

# axes
set size ratio -1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

################################################################################

set multiplot layout 2,2

################################################################################

#### plot 1 #####

# labels
set label 1 '\footnotesize $\sfdriving[modifier=cht]_m(\sfsphrref,\sfomega)$'
set label 2 'a)'

# x-axis
set xtics format ''

# y-axis
set ylabel '$y$ / m' offset 4.0,0

# c-axis
load 'moreland.pal'
set cbrange [-1:1]
set cbtics 1

# margins
set lmargin 4.75
set rmargin 0.25
set tmargin 1.0
set bmargin 0.0

# plotting
plot 'pw_phi90.0_rref0.750_phit90.0_rt0.750_Nset50_Nce50_f1000_rep.dat' binary matrix with image,\
  'array.txt' @array_continuous,\
  'rref.txt' u 1:2 w l lc rgb '#00ff00' lt 3 lw 3

################################################################################

#### plot 2 ####

# labels
set label 1 '\footnotesize $\sfdriving[modifier=cht]^\prime_m(0,\omega)$'
set label 2 'b)'

# colorbar
set colorbox @colorbar_east

# margins
set lmargin 0.25
set rmargin 4.75

# plotting
plot 'pw_phi90.0_rref0.000_phit90.0_rt0.750_Nset50_Nce50_f1000_rep.dat' binary matrix with image,\
  'array.txt' @array_continuous,\
  'xc.txt' u 1:2 w p lc rgb '#00ff00' lt 3 lw 3 pt 2 ps 2

################################################################################

#### plot 3 ####

# label
unset label 1
unset label 2

# x-axis
set xlabel '$x$ / m' offset 0,1
set xtics format '\footnotesize $%g$'

# y-axis
set ylabel '$y$ / m' offset 4.0,0

# c-axis
load 'blues.pal'
set cbrange [-60:0]
set cbtics 20
set cbtics add ('\footnotesize $0$\,dB' 0)

# colorbar
unset colorbox

# margins
set lmargin 4.75
set rmargin 0.25
set tmargin 0.0
set bmargin 1.0

# plotting
plot 'pw_phi90.0_rref0.750_phit90.0_rt0.750_Nset50_Nce50_f1000_err.dat' binary matrix with image,\
  'array.txt' @array_continuous

################################################################################

#### plot 4 ####

# colorbar
set colorbox @colorbar_east

# margins
set lmargin 0.25
set rmargin 4.75

# plotting
plot 'pw_phi90.0_rref0.000_phit90.0_rt0.750_Nset50_Nce50_f1000_err.dat' binary matrix with image,\
  'array.txt' @array_continuous

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
