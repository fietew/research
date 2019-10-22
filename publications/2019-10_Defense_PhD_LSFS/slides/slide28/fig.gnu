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

load 'standalone.cfg'

################################################################################
set terminal epslatex size @intbeamerwidth,6.5cm color colortext standalone header intbeamer.footnotesize
set output 'fig.tex'

unset key

# style
load 'qualitative/Paired.plt'
# labels
set label 1 at first 6, graph -0.18 'LWFS mit verschiedener Ordnung $M$' front center tc rgb '#808080'
set label 2 at first 5.5, graph 1.04 'Beamformingartefakte' front center tc rgb '#4A1486'
set label 3 at first 5.5, graph 1.18 'Aliasingartefakte' front center tc ls 2
# arrows
set arrow 1 nohead lc rgb '#808080' lw 3 from first 2.5, graph -0.13 rto first 7, graph 0
set arrow 2 head size 0.05,20,60 filled lc rgb '#4A1486' lw 5 from first 2, graph 1.09 rto first 7, 0
set arrow 3 backhead size 0.05,20,60 filled ls 2 lw 5 from first 2, graph 1.13 rto first 7, 0
# border
load 'border.cfg'
# axes
set format '$%g$'
set tics scale 1 out nomirror
# x-axis
set xrange [-0.25:9.25]
set xtics (\
  'Ref.' 0,\
  'Anker' 1,\
  'WFS' 2,\
  '$27$' 3,\
  '$23$' 4,\
  '$19$' 5,\
  '$15$' 6,\
  '$11$' 7,\
  '$7$' 8,\
  '$3$' 9,\
  ) offset 0,0.25
set xlabel offset 0,2
# y-axis
set yrange [0:1]
set mytics 2
set ylabel 'Klangverfärbung' offset 4,-0.5
set ytics 1 offset 0.1,0.5 rotate by 45
set ytics add ('\shortstack{kein \\Unterschied}' 0, '\shortstack{starker \\Unterschied}' 1)
# margins
set tmargin 2.5
set bmargin 2.5
set lmargin 5.5
set rmargin 0.5
# legend
set key autotitle columnhead
unset key
# grid
load 'grid.cfg'
set grid mytics ytics
# plotting
plot 'data.txt' u 0:3:6:7 w yerrorbars ls 6 pt 7 lw 3

call 'pdflatex.gnu' 'fig'
