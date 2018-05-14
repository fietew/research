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


################################################################################
set t epslatex size 8.6cm,10cm color colortext
set output 'tmp.tex'

unset key

# variables
offset = 8
f = "200 300 500 750"
methods = "lwfs_3.50_1.75 lwfs_3.50_1.00 lwfs_3.50_0.00 esa-rect wfs"
labels = 'LWFS\,$R_c=1.75$~m LWFS\,$R_c=1$~m LWFS\,$R_c=0$~m ESA WFS'
# axes
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [0:90]
set xtics 15 offset 0,0.5
set xlabel 'source azimuth $\sfsphphi[subscript=s]$ / deg' offset 0,1
# y-axis
set yrange [-4:30]
set ytics (\
    '\footnotesize $-4$' -4,\
    '\footnotesize $0$' 0,\
    '\footnotesize $\pm4$' 4,\
    '\footnotesize $0$' 8,\
    '\footnotesize $\pm4$' 12,\
    '\footnotesize $0$' 16,\
    '\footnotesize $\pm4$' 20,\
    '\footnotesize $0$' 24,\
    '\footnotesize $+4$' 28)
set ytics offset 0.5,0
set ylabel 'magnitude deviation / dB' offset 3.5,0
# y2-axis
set y2range [-3:30]
set y2tics ('\footnotesize 200' 0,\
 '\footnotesize 300' 8,\
 '\footnotesize 500' 16,\
 '\footnotesize 750' 24)
set y2tics offset -0.5,0
set y2label 'Frequency / Hz' offset -4,0
# grid
load 'grid.cfg'
# legend
set key at graph 1.0, 1.0 bottom right vertical maxcolumns 2 maxrows 3 width -10 samplen 3
# palette
load 'qualitative/Set1.plt'
# margins
set tmargin 3
set bmargin 2.0
set lmargin 5
set rmargin 5

################################################################################

# plotting
plot \
  for [idx=1:words(f)] for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,idx).'.txt' using 1:($2+(idx-1)*offset) w l ls (words(methods)-jdx+1) notitle,\
  for [jdx=1:words(labels)] 1/0 w l ls (words(methods)-jdx+1) t word(labels,jdx)

################################################################################

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
