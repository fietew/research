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


################################################################################
set t epslatex size 11cm,7cm color colortext
set output 'tmp.tex'

unset key

# variables
offset = 8
f = "200 300 500 750"
methods = "gt wfs lwfs_3.50_0.00 lwfs_3.50_1.00 lwfs_3.50_1.75"
labels = 'GT WFS LWFS\,square LWFS,\,$R_c=1$m LWFS,\,circle'
# labels
load 'labels.cfg'
set label 1 @label_title '$R_l=1.75$m'
# axes
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [0:90]
set xtics 15 offset 0,0.5
set xlabel 'source azimuth $\sfsphphi[subscript=s]$ / deg' offset 0,1
# y-axis
set yrange [-3:30]
set ytics 8 offset 0.5,0
set ylabel 'magnitude deviation / dB' offset 3.5,0
# y2-axis
set y2range [-3:30]
set y2tics ("200" 0, "300" 8, "500" 16, "750" 24) offset -0.5,0
set y2label 'Frequency / Hz' offset -2,0
# grid
load 'grid.cfg'
# legend
set key at graph 0.5, 1.0 bottom center vertical maxrows 2 width -2 samplen 2
# palette
load 'Set1.pal'
# margins
set tmargin 4
set bmargin 2
set lmargin 5
set rmargin 6

################################################################################

# plotting
plot \
  for [idx=1:words(f)] for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,idx).'.txt' using 1:($2+(idx-1)*offset) w l ls jdx notitle,\
  for [jdx=1:words(labels)] 1/0 w l ls jdx t word(labels,jdx)

################################################################################

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
