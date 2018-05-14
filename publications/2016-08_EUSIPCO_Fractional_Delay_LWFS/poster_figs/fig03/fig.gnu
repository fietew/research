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

################################################################################
set t epslatex size 34cm,26cm color colortext
set output 'tmp.tex';

# variables
N = 6  # number of spectra
tau_str = '$\tau_{\mathrm ph}/$ samples'
A_str = '$| H_{\mathrm{frac}} |$'
f_str = '$f / f_s$'
# border
load 'border.cfg'
# x-axis
set xrange [0.0:0.5]
set xtics 0.1 offset 0,0
set xlabel offset 0,-1
# y-tics
set ylabel offset -1,0
set ytics 0.2 offset 0,0
# grid
load 'grid.cfg'
# styles
load 'qualitative/Set1.plt'
# margins
set lmargin 12
set rmargin 0
# labels
load 'labels.cfg'
set label 11 @label_north

################################################################################
set multiplot layout 3,2 columnsfirst

#### plot 1 #####
# margins
set tmargin 3
set bmargin 1
# x-axis
set format x ''
# y-axis
set ylabel A_str
set format y '\footnotesize $%g$'
set yrange [-0.05:1.05]
# legend
set key at first 0.0125, 0.0 left bottom width 4 spacing 2 samplen 10
# labels
set label 11 '\small Lagrange Filter for $d_{\mathrm{frac}} = 0.5$'
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*ii)) title sprintf("\\footnotesize $N=%d$", ii-1) w l ls ii

#### plot 2 #####
# margins
set tmargin 2
set bmargin 2
# legend
unset key
# labels
set label 11 '\small Thiran Filter for $d_{\mathrm{frac}} = 0.5$'
set label 2 '\footnotesize $N=1,2,3,4,5,6$' at 0.5,0.9 right front tc ls 6
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*(N+ii))) title sprintf("\\footnotesize $N=%d$", ii-1) w l ls ii

#### plot 3 #####
# margins
set tmargin 1
set bmargin 3
# x-axis
set format x '\footnotesize $%g$'
set xlabel f_str
# legend
set key at first 0.0125, 0.1 left bottom width 4 spacing 2 samplen 10
# labels
set label 11 '\small Upsampling ($R=2$) + Lagrange ($N=1$)'
unset label 1
unset label 2
unset label 3
unset label 4
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*(2*N+ii))) title sprintf('\footnotesize $d_{\mathrm{frac}}=%01.02f$', (ii-1)*0.05) w l ls ii

#### plot 4 #####
# margins
set tmargin 3
set bmargin 1
# x-axis
set format x ''
set xlabel ''
# y-axis
set ylabel tau_str
set format y '\footnotesize $%g$'
set yrange [-0.025:0.525]
set ytics 0.1
# labels
set label 11 '\small Lagrange Filter for $d_{\mathrm{frac}} = 0.5$'
set label 1 '\footnotesize $N=0$' at 0.05,0.05 left front tc ls 1
set label 2 '\footnotesize $N=1,3,5$' at 0.5,0.45 right front tc ls 6
set label 3 '\footnotesize $N=2$' at 0.35,0.2 right front tc ls 3
set label 4 '\footnotesize $N=4$' at 0.4,0.35 left front tc ls 5
# legend
unset key
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*ii+1)) title sprintf("\\footnotesize $N=%d$", ii-1) w l ls ii

#### plot 5 #####
# margins
set tmargin 2
set bmargin 2
# labels
set label 11 '\small Thiran Filter for $d_{\mathrm{frac}} = 0.5$'
unset label 1
unset label 2
unset label 3
unset label 4
# legend
set key at first 0.0125, 0.0 left bottom width 4 spacing 2 samplen 10
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*(N+ii)+1)) title sprintf("\\footnotesize $N=%d$", ii-1) w l ls ii

#### plot 6 #####
# margins
set tmargin 1
set bmargin 3
# x-axis
set format x '\footnotesize $%g$'
set xlabel f_str
# labels
set label 11 '\small Upsampling ($R=2$) + Lagrange ($N=1$)'
# legend
set key at first 0.0125, 0.45 left top width 4 spacing 2 samplen 10 maxrows 3
# plot
plot for [ii=1:N] 'data.txt' u 1:(column(2*(2*N+ii)+1)) title sprintf('\footnotesize $d_{\mathrm{frac}}=%01.02f$', (ii-1)*0.05) w l ls ii

unset multiplot
################################################################################

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
