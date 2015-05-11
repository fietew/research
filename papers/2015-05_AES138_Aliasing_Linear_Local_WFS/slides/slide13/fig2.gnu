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
load 'blues.pal'
load 'labels.cfg'
load 'colorbar.cfg'

################################################################################
set t epslatex size 4cm,4cm color colortext
set output 'tmp.tex'

unset key

# labels
set label 1 @label_north

# axes
set xrange [-40:40]
set yrange [0:2000]
set cbrange [-100:0]

set xtics 40 offset 0,0.5
set ytics 500 offset 0.5,0
set cbtics 20
set tics scale 0.75 out nomirror

set xlabel '$\kx$ / m' offset 0,1
set ylabel '$f$ / Hz' offset 3.5,0
set format '\footnotesize $%g$'
set colorbox @colorbar_east

# margins
set bmargin 0
set tmargin 0
set lmargin 1.5
set rmargin 1.5

################################################################################
set label 1 '\footnotesize $\tilde D^{\mathrm{tr}}_\lsindex(\kx, \omega)$'
plot 'spectrum_D0tr.dat' binary matrix with image,\
  'approx.dat' u 1:2 w l lt 1 lw 2 lc rgb '#ad1400' ,\
  'approx.dat' u 3:4 w l lt 1 lw 2 lc rgb '#ad1400'

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig2}|' < tmp.tex > fig2.tex
!epstopdf tmp.eps --outfile='fig2.pdf'
