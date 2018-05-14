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

load 'xyborder.cfg'

################################################################################
set t epslatex size 16cm,20cm  color colortext
set output 'tmp.tex';

unset key # deactivate legend

load 'BlGrRd.plt'
# variables
N = 6  # number of spectra
offset = 5 # offset of line in dB
# x-axis
set xrange [0:20]
set xtics 2 offset 0,0
set xlabel offset 0,-1
# y-axis
set format y '\footnotesize $%g$'
set yrange [-offset*0.5:(N-0.5)*offset]
set ytics -offset,offset,N*offset
set ylabel 'Magnitude / dB' offset 0,0
# grid
load 'grid.cfg'
set grid xtics ytics
# margins
set lmargin 6.00
set rmargin 0.5
# labels
load 'labels.cfg'
set label 11 @label_northeast
do for [ii=1:N] {
  set label ii at 2,(ii-0.75)*offset left front tc ls 2*ii
}
set label 1 '\footnotesize Upsampling ($R=2$) + Lagrange ($N=3$)'
set label 2 '\footnotesize Upsampling ($R=2$) + Thiran ($N=3$)'
set label 3 '\footnotesize Lagrange ($N=3$)'
set label 4 '\footnotesize Thiran ($N=3$)'
set label 5 '\footnotesize Zero-Order Hold'
set label 6 '\footnotesize Lagrange ($N=0$)'
# functions
db(x) = 20*log10(x)

################################################################################
set multiplot layout 2,1

#### plot 1 #####
# x-axis
set format x ''
# margins
set tmargin 2.5
set bmargin 2.5
# labels
set label 11 '\footnotesize $\sfposref=[0,0,0]^\mathrm T$m'
# plot
plot for [ii=1:N] 'data.txt' u ($1/1000):(db($2)+(ii-1)*offset) w l ls 23, \
     for [ii=1:N] 'data.txt' u ($1/1000):(db(column(2*ii+2))+(ii-1)*offset) w l ls 2*ii, \

#### plot 2 #####
set format x '\footnotesize $%g$'
set xlabel ' Frequency / kHz'
# margins
set tmargin 0.0
set bmargin 5.0
# labels
set label 11 '\footnotesize $\sfposref=[-0.5,0,0]^\mathrm T$m'
# plot
plot for [ii=1:N] 'data.txt' u ($1/1000):(db($3)+(ii-1)*offset+1) w l ls 23, \
     for [ii=1:N] 'data.txt' u ($1/1000):(db(column(2*ii+3))+(ii-1)*offset+1) w l ls 2*ii

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
