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
load 'mathematics.cfg'
load 'array.cfg'
load 'localization.cfg'

# latex
set terminal epslatex size @intbeamerwidth,5.5cm color colortext standalone header intbeamer
set output 'fig.tex'

unset key

################################################################################
set multiplot layout 1,2

# palette
load 'qualitative/Paired.plt'
# axes
set format '\ft $%g$'
# border
load 'xyborder.cfg'
# grid
load 'grid.cfg'
# labels
set label 1 at first  4.25, 2.75 tc ls 8 'NFCHOA'
set label 2 at first  1.75, 2.75 tc ls 2 'WFS'
set label 3 at first 10.5, 2.75 tc ls 4 'LWFS'
set label 4 at first   5.3, 1.5 tc ls 8 rotate by -70 '$\overset{M}{\leftarrow}$'
set label 5 at first   12, 1.5 tc ls 4 rotate by -80 '$\overset{M}{\leftarrow}$'
# margins
set tmargin 0.4
set bmargin 2.25
set lmargin 2
set rmargin 0.0
# x-axis
set xrange [1:15]
set xlabel offset 0,1.0 'Aliasingfrequenz $\sffS$ / kHz'
set xtics offset 0,0.5
set xtics add (0.2, 20)
set logscale x
# y-axis
set yrange [1:15]
set ylabel offset 1,0 'Beamformingfrequenz $\sff^B$ / kHz'
set ytics 10 offset 0.5,0
set ytics add (0.2, 20)
set logscale y
# positioning
set size 0.6, 1.0
set origin 0.075, 0.0
# plotting
plot x w l lc rgb 'grey' lw 4 dt 6,\
  'wfs.txt' u ($1/1000):($3/1000) w l ls 2 lw 6,\
  '' u ($2/1000):($4/1000) w l ls 2 lw 6 dt 3,\
  'hoa.txt' u ($1/1000):($3/1000) w l ls 8 lw 4,\
  '' u ($2/1000):($4/1000) w l ls 8 lw 4 dt 3,\
  'lwfs.txt' u ($1/1000):($3/1000) w l ls 4 lw 4,\
  '' u ($2/1000):($4/1000) w l ls 4 lw 4 dt 3

# plot 2 #
# labels
unset label
# border
load 'noborder.cfg'
#margins
set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0
# grid
unset grid
set size ratio -1
set xrange [-1.55:1.55]
unset logscale
set yrange [-1.55:2.65]
# positioning
set size 0.225, 1.0
set origin 0.75, 0.0
# plotting
plot 'pos1.txt' using 1:2 w l lw 4 lc rgb 'black',\
  'pos2.txt' using 1:2 w l lw 4 dt 3 lc rgb 'black',\
  'array.txt' @array_active,\
  set_point_source(0,2.5) @point_source

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
