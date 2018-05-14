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
set t epslatex size 11cm,7cm color colortext
set output 'tmp.tex'

unset key

# variables
offset = 4
f = "200 300 500 750"
methods = "gt wfs esa-rect"
labels = 'Ground\,Truth 2.5D\,WFS 2.5D\,ESA'
# labels
load 'labels.cfg'
set label 1 @label_northwest
# axes
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [0:90]
set xtics 15 offset 0,0.5
set xlabel 'source azimuth $\sfsphphi[subscript=s]$ / deg' offset 0,1
# y-axis
set yrange [-3:15]
set ytics ('\footnotesize -2' -2,\
  '\footnotesize 0' 0,\
  '\footnotesize $\pm$2' 2,\
  '\footnotesize 0' 4,\
  '\footnotesize $\pm$2' 6,\
  '\footnotesize 0' 8,\
  '\footnotesize $\pm$2' 10,\
  '\footnotesize 0' 12,\
  '\footnotesize 2' 14) offset 0.5,0
set ylabel 'magnitude deviation / dB' offset 3.5,0
# y2-axis
set y2range [-3:15]
set y2tics ("200" 0, "300" 4, "500" 8, "750" 12) offset -0.5,0
set y2label 'Frequency / Hz' offset -2,0
# grid
load 'grid.cfg'
# legend
set key at graph 0.0, 1.0 bottom left vertical maxrows 1 width -5 samplen 2
# palette
load 'qualitative/Set1.plt'
# margins
set tmargin 2
set bmargin 3
set lmargin 5
set rmargin 6

################################################################################

# plotting
plot \
  for [idx=1:words(f)] for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,idx).'.txt' using 1:($2+(idx-1)*offset) w l ls jdx notitle,\
  for [jdx=1:words(labels)] 1/0 w l ls jdx t word(labels,jdx)

################################################################################

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
