#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2018      Fiete Winter                                       *
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
set t epslatex size 8.9cm,3.0cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Paired.plt'
set style line 10 lc rgb 'black'
set style line 101
# border
load 'xyborder.cfg'
# grid
load 'grid.cfg'
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 4.0
OUTER_RATIO_L = 0.825
SPACING_VERTICAL = 2.5
OUTER_RATIO_B = 0.87
# x-axis
set xrange [0:3]
set xtics 0.5 offset 0,0.5
set xtics add ('$\ft \infty$' 3)
set xlabel offset 0,1.0
LABEL_X = '\ft $\sfRc \;/\;\mathrm{m}$'
# y-axis
set ylabel offset 4,0
set yrange [1:3]
set ytics 1 offset 1.0,0
# set logscale y
LABEL_Y = '\ft $\sffS_{\sfcirclelocal|\sfcirclec}\;/\;\mathrm{kHz}$'
# axes
set format '\ft %g'

################################################################################

# positioning
@pos_bottom_left
# arrows
set arrow 1 from 2.725, graph -0.05 to 2.75, graph 0.05 nohead ls 101 # Inf break
set arrow 2 from 2.75, graph -0.05 to 2.775, graph 0.05 nohead ls 101 #    "
# plotting
plot 'fS.txt' using 1:($2/1000) w l ls 6 lw 4,\
  '' using 1:($3/1000) w l ls 2 lw 4

call 'pdflatex.gnu' 'fig'
