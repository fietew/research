#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2015      Fiete Winter                                       *
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
load 'moreland.pal'
load 'array.cfg'

set style line 11 lc rgb 'black' lt 2 lw 4 ps 0.75

################################################################################
set t epslatex size 12cm,4cm color colortext
set output 'tmp.tex';

unset key
set size ratio -1

set xrange [-1.05:1.05]
set yrange [-1.05:1.05]
set cbrange [-1:1]
set cbtics 1 offset 0, -0.5
set tics scale 0.75 out nomirror
set xtics 1 offset 0,0.5
set ytics 1 offset 0.5,0
set xlabel '$x$ / m' offset 0,1
set ylabel '$y$ / m' offset 1.5,0
unset colorbox
set format '$%g$'

set bmargin 0
set tmargin 0

set multiplot layout 1,3
set lmargin 3
set rmargin 0
set label 1 '\footnotesize 1kHz' at 1.05,1.15 right front
plot 'sound_field_wfs_f1000.dat' binary matrix with image,\
     'array.txt' @array_active w p
set border 1
set format y ''
set ytics scale 0
unset ylabel
unset colorbox
set lmargin 1.5
set rmargin 1.5
set label 1 '\footnotesize 3kHz'
plot 'sound_field_wfs_f3000.dat' binary matrix with image,\
     'array.txt' @array_active w p

set lmargin 0
set rmargin 3
set label 1 '\footnotesize 5kHz'
plot 'sound_field_wfs_f5000.dat' binary matrix with image,\
     'array.txt' @array_active w p
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig07}|' < tmp.tex > fig07.tex
!epstopdf tmp.eps --outfile='fig07.pdf'
