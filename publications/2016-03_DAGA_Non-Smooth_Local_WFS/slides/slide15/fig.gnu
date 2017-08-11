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
set t epslatex size 11.0cm,7.0cm color colortext
set output 'tmp.tex'

unset key

# variables
f = "200 300 500 750"
methods = "lwfs_3.50_1.75 lwfs_3.00_1.50 lwfs_2.50_1.25 lwfs_2.00_1.00"
labels = '$R_l=1.75$m $R_l=1.5$m $R_l=1.25$m $R_l=1.00$m'
# labels
load 'labels.cfg'
set label 1 @label_northwest
# axes
# set size ratio -1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror
# grid
load 'grid.cfg'
# x-axis
set xrange [3:13]
set xtics 2 offset 0,0.5
# y-axis
set yrange [0:5]
set ytics 1 offset 0.5,0
# legend
set key at graph 1.0, 1.2 bottom center vertical maxrows 1 width 0 samplen 2
# palette
load 'qualitative/Set1.plt'

################################################################################

set multiplot layout 2,2

################################################################################

#### plot 1 #####

# labels
set label 1 '\footnotesize $f=200$Hz'
# x-axis
set format x ''
# y-axis
set ylabel '\footnotesize $(\Delta_{\mathrm{max}} - \Delta_{\mathrm{min}})$/dB' offset 3,0
# margins
set lmargin 3
set rmargin 0.25
set tmargin 2.0
set bmargin 1.0
# plotting
plot \
  for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,1).'_stats.txt' using 1:($4-$2) w l ls jdx notitle,\
  for [jdx=1:words(labels)] 1/0 w l ls jdx t word(labels,jdx)

################################################################################

#### plot 2 ####

# legend
unset key
# labels
set label 1 '\footnotesize $f=300$Hz'
# y-axis
unset ylabel
set format y ''
# margins
set lmargin 0.25
set rmargin 3
# plotting
plot \
  for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,2).'_stats.txt' using 1:($4-$2) w l ls jdx notitle

################################################################################

#### plot 3 ####

# labels
set label 1 '\footnotesize $f=500$Hz'
# x-axi
set xlabel 'listening area / m$^2$' offset 0,1
set format x '\footnotesize $%g$'
# y-axis
set ylabel '\footnotesize $(\Delta_{\mathrm{max}} - \Delta_{\mathrm{min}})$/dB' offset 3,0
set format y '\footnotesize $%g$'
# margins
set lmargin 3
set rmargin 0.25
set tmargin 0.0
set bmargin 3.0
# plotting
plot \
  for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,3).'_stats.txt' using 1:($4-$2) w l ls jdx notitle

################################################################################

#### plot 4 ####

# labels
set label 1 '\footnotesize $f=750$Hz'
# y-axis
unset ylabel
set format y ''
# colorbar
set colorbox @colorbar_east
# margins
set lmargin 0.25
set rmargin 3
# plotting
plot \
  for [jdx=1:words(methods)] \
    ''.word(methods,jdx).'_f'.word(f,4).'_stats.txt' using 1:($4-$2) w l ls jdx notitle

################################################################################

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
