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

load 'grid.cfg'

load 'BlGrRd.plt'
load 'xyborder.cfg'

unset key
unset colorbox

set bmargin 3
# set tmargin 1

# decibel function
db(x) = 20*log10(abs(x))

################################################################################
set t epslatex size 18cm,8cm color colortext
set output 'tmp.tex';

TMARGIN = "set tmargin at screen 0.55; set bmargin at screen 0.95"
BMARGIN = "set tmargin at screen 0.08; set bmargin at screen 0.48"
LMARGIN = "set lmargin at screen 0.10; set rmargin at screen 0.50"
RMARGIN = "set lmargin at screen 0.57; set rmargin at screen 0.97"

set logscale x
set ylabel 'Magnitude / dB' offset 1,0
set xlabel 'Frequency / Hz'

set xrange [0.1:20]
set xtics add ('$100$' 0.1,'$400$' 0.4,'$1$k' 1,'$4$k' 4,'$10$k' 10)
set ytics 40

set grid xtics ytics mxtics

set multiplot layout 1,2

# first plot with distances
numbers = "5 10 15 20 25 30 60 90"
N = words(numbers)

@LMARGIN

set yrange [-20:(N)*40]
set label 11 "\\footnotesize $\\localradius=30$cm" at 20,(N)*40+10 right front
do for [ii=1:N] {
  set label ii sprintf("$\\localnumber\' = %s$", word(numbers, ii)) at 0.105,(12+(N-ii)*40) left front tc ls ii
}
plot for [ii=1:N] 'fig04-1-1.txt' u ($1/1000):(db($2)+(N-ii)*40) w l ls 23, \
     for [ii=1:N] 'fig04-1-1.txt' u ($1/1000):(db(column(ii+2))+(N-ii)*40) w l ls ii

# first plot with radius
radius = "5 10 12.5 15 30 45 60 90"
N = words(radius)

@RMARGIN

set yrange [-20:(N)*40]
set ylabel ''
set label 11 "\\footnotesize $\\localnumber\'=90$" at 20,(N)*40+10 right front
do for [ii=1:N] {
  set label ii sprintf("$\\localradius = %s$cm", word(radius, ii)) at 0.105,(12+(N-ii)*40) left front tc ls ii
}
plot for [ii=1:N] 'fig04-1-2.txt' u ($1/1000):(db($2)+(N-ii)*40) w l ls 23, \
     for [ii=1:N] 'fig04-1-2.txt' u ($1/1000):(db(column(ii+2))+(N-ii)*40) w l ls ii

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig04-1}|' < tmp.tex > fig04-1.tex
!epstopdf tmp.eps --outfile='fig04-1.pdf'

################################################################################
# plot with mean ild
set t epslatex size 9cm, 5cm color colortext
set output 'tmp.tex'

# first plot with radius
unset tmargin
unset bmargin
unset rmargin
unset lmargin

unset logscale
set yrange [-25:25]
set xrange [-180:180]
set ylabel 'ILD / dB' offset 1,0
set xlabel 'Apparent Source Azimuth / deg'
unset xtics
set xtics 90
set mxtics 3
set ytics 10

set grid xtics ytics mxtics mytics

unset label
plot 'fig04-2.txt' u ($1/pi*180):(db($2)) w l ls 23, \
     'fig04-2.txt' u ($1/pi*180):(db($3)) w l ls 12, \
     'fig04-2.txt' u ($1/pi*180):(db($4)) w l ls 1, \

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig04-2}|' < tmp.tex > fig04-2.tex
!epstopdf tmp.eps --outfile='fig04-2.pdf'

# vim: set textwidth=200:
