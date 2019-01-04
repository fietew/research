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

load 'xyborder.cfg'

################################################################################
set t epslatex size 8.7cm,9cm color colortext
set output 'tmp.tex';

load 'qualitative/Set1.plt'
# variables
N = 6  # number of spectra
# axes
set border back
# x-axis
set xrange [0:0.5]
set xtics 0.1 offset 0,0.5
set mxtics 2
set xlabel offset 0,1.5
# y-tics
set ylabel offset 4,0
set ytics 0.2 offset 1.0,0
set mytics 5
# grid
load 'grid.cfg'
set grid xtics ytics mxtics mytics
# margins
set lmargin 4.75
set rmargin 0.25
# labels
load 'labels.cfg'
set label 11 @label_northeast

################################################################################
set multiplot layout 3,1

#### plot 1 #####
# x-axis
set format x ''
# y-axis
set ylabel '$| H_{\mathrm{frac}} |$'
set format y '\footnotesize $%g$'
set yrange [0:1]
# margins
set tmargin 1.5
set bmargin 0.5
# labels
set label 11 'Magnitude Response Lagrange Filter'
# legend
set key left bottom width -2.5 samplen 1.5
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*ii)) title sprintf("\\footnotesize $N$=%d", ii-1) w l ls ii

#### plot 2 #####
# x-axis
set format x ''
# y-axis
set ylabel '\footnotesize $\displaystyle \frac{\mathrm{arg}(H_{\mathrm{frac}})}{\omega} - \left\lfloor \frac N2 \right\rfloor$'
set format y '\footnotesize $%g$'
set yrange [0:0.5]
set ytics 0.1
# margins
set tmargin 1.0
set bmargin 1.0
# labels
set label 11 'Phase Delay, Lagrange Filter'
set label 1 '\footnotesize $N$=0' at 0.05,0.05 left front tc ls 1
set label 2 '\footnotesize $N$=1,3,5' at 0.5,0.45 right front tc ls 6
set label 3 '\footnotesize $N$=2' at 0.35,0.2 right front tc ls 3
set label 4 '\footnotesize $N$=4' at 0.4,0.35 left front tc ls 5
# legend
unset key
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*ii+1)) title sprintf("\\footnotesize $N$=%d", ii-1) w l ls ii

#### plot 3 #####
# x-axis
set format x '\footnotesize $%g$'
set xlabel '\footnotesize $f / f_s$'
# y-axis
set ylabel '\footnotesize $\displaystyle \frac{\mathrm{arg}(H_{\mathrm{frac}})}{\omega} - N$'
set format y '\footnotesize $%g$'
set yrange [0:0.5]
set ytics 0.1
# margins
set tmargin 0.5
set bmargin 1.5
# legend
set key left bottom width -2.5 samplen 1.5
# labels
set label 11 'Phase Delay, Thiran Filter'
unset label 1
unset label 2
unset label 3
unset label 4
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*(N+ii)+1)) title sprintf("\\footnotesize $N$=%d", ii-1) w l ls ii

unset multiplot
################################################################################

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
