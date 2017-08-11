#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2012      Hagen Wierstorf                                    *
#                         Centre for Vision, Speech and Signal Processing    *
#                         University of Surrey                               *
#                         Guildford, GU2 7XH, UK                             *
# Copyright (c) 2017      Fiete Winter                                       *
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
set t epslatex size 8cm,7.25cm color colortext header "\\newcommand{\\ft}[0]{\\footnotesize}"
set output 'tmp.tex';

unset key # deactivate legend

# border
load 'xyborder.cfg'
set border back
# grid
load 'grid.cfg'
set grid mytics back ls 102
# colors definitions
set style line 1 lc rgb 'black' pt 12  ps 1.5 lt 1 lw 2 # --- black
set style line 2 lc rgb 'black' pt 9 ps 1.5
set style line 3 lc rgb '#d6d7d9' pt 13  ps 1.5
# x-axis
set xrange [-45:45]
set xtics 15 offset 0,0.5
set xlabel offset 0,1.0
# y-axis
set ylabel offset 4,0
set ytics offset 1.0,0
set mytics 2
set format y '\ft $%g$'
# labels
set label 1 at graph 1.0,0.9 right front tc ls 1
# margins
set lmargin 4.0
set rmargin 1.0
# functions
f(x) = (x == 1) ? 1 : NaN

set multiplot layout 2,1
################################################################################

#### plot 1 #####
# x-axis
set format x ''
# y-axis
set yrange [0:12]
set ytics 2,4
set ylabel '\ft std / deg'
# margins
set tmargin 1
set bmargin 1
# labels
set label 1 '\ft 2012'

file = '2012_err_std.txt'
plot for [ii=1:10] file using 1:4+ii ls 3,\
  file using 1:2:3:4 w yerrorbars ls 1,\
  'err_std_sign.txt' using 1:(0*f($2)) w p ls 2

#### plot 2 #####
# x-axis
set format x '\ft $%g$'
set xlabel '\ft $\phi_c$ / deg'
# y-axis
set yrange [0:12]
set ytics 2,4
set ylabel '\ft std / deg'
# margins
set tmargin 0
set bmargin 2
# labels
set label 1 '\ft 2017'
# title
unset title

file = '2017_err_std.txt'
plot for [ii=1:10] file using 1:4+ii ls 3,\
  file using 1:2:3:4 w yerrorbars ls 1,\
  'err_std_sign.txt' using 1:(0*f($2)) w p ls 2

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
