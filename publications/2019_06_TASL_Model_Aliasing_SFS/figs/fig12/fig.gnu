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
set t epslatex size 18.1cm,3.0cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Dark2.plt'
set style line 10 lc rgb 'black'
# positioning
load 'positions.cfg'
# variables
Nfirst = 5
Nsecond = 10
offset = 40  # shift in dB
# labels
load 'labels.cfg'
set label 1 @label_northwest tc ls 2
set label 2 @label_northeast tc ls 6
set label 3 at graph 0.0, 1.12 left front tc ls 2
set label 4 at graph 1.0, 1.12 right front tc ls 6

################################################################################

set multiplot

################################################################################
#### plot 1 #####
# border
load 'xyborder.cfg'
# labels
do for [ii=1:Nfirst] {
  set label 10+ii sprintf('%d',ii-1) at graph 1.02, first (ii-1)*offset  left front tc ls ii
}
# arrows
do for [ii=1:Nfirst] {
  set arrow 10+ii from 0.2, (ii-1)*offset to 10, (ii-1)*offset nohead back ls ii lw 2 dt 3
}
# x-axis
set xrange [0.2:10]
set logscale x 10
set xlabel offset 1,2.0
LABEL_X = '\ft $f / \mathrm{kHz}$'
set xtics offset 0,0.5
# y-axis
set ylabel  offset 4.5,0
set yrange [-40:(Nfirst-1)*offset+20]
set ytics 20 offset 0.5,0
do for [ii=0:Nfirst-1] {
  set ytics add ('\ft $0$' ii*offset)
  set ytics add ('\ft $\pm 20$' (ii-0.5)*offset)
}
set ytics add ('\ft $-20$' -20)
set ytics add ('\ft $20$' (Nfirst-1)*offset+20)

LABEL_Y = '\ft $\hat\varepsilon(\sfpos,\sfomega)$ / dB'
# grid
load 'grid.cfg'
set grid noytics xtics mxtics
# positioning
SPACING_HORIZONTAL = 5.0
SPACING_VERTICAL = 1.5
OUTER_RATIO_B = 0.8
OUTER_RATIO_L = 0.9
set size 0.4, 1.0
set origin 0.02, 0.0
@pos_bottom_left
# plotting
plot for[ii=1:Nfirst] 'eps.txt' u ($1/1000):(column(ii+1)+(ii-1)*offset) w l ls ii lw 2,\
    for[ii=0:Nfirst-1] 'eps_fS.txt' every ::ii::ii u ($1/1000):($2+ii*offset) with points ls ii+1 pt 6 ps 1.5

#### plot 2 #####
# border
load 'xyborder.cfg'
# labels
do for [ii=1:Nfirst] {
  unset label 10+ii
}
do for [ii=Nfirst+1:Nsecond] {
  set label 10+ii sprintf('%d',ii-1) at graph 1.02, first (ii-1)*offset  left front tc ls ii
}
# arrows
do for [ii=Nfirst+1:Nsecond] {
  set arrow 10+ii from 0.2, (ii-1)*offset to 10, (ii-1)*offset nohead back ls ii lw 2 dt 3
}
do for [ii=1:Nfirst] {
  unset arrow 10+ii
}
# y-axis
set ytics 20 offset 0.5,0
set yrange [-40+(Nfirst)*offset:(Nsecond-1)*offset+20]
# grid
load 'grid.cfg'
set grid xtics mxtics
# positioning
set origin 0.425,  0.0
@pos_bottom
# plotting
plot for[ii=Nfirst+1:Nsecond] 'eps.txt' u ($1/1000):(column(ii+1)+(ii-1)*offset) w l ls ii lw 2,\
    for[ii=Nfirst:Nsecond] 'eps_fS.txt' every ::ii::ii u ($1/1000):($2+ii*offset) with points ls ii+1 pt 6 ps 1.5

#### plot 3 #####
# labels
do for [ii=1:Nsecond] {
  unset label 10+ii
}
# arrows
do for [ii=1:Nsecond] {
  unset arrow 10+ii
}
# x-axis
set xrange [-1.5:1.5]
unset logscale
LABEL_X = ''
# y-axis
set yrange [-1.5:2.55]
unset ytics
LABEL_Y = ''
# positioning
SPACING_HORIZONTAL = 0
SPACING_VERTICAL = 0.35
OUTER_RATIO_B = 0.5
OUTER_RATIO_R = 0.5
set size 0.35, 1.0
set size ratio -1
set origin 0.73, 0.0
@pos_bottom_right
# border
load 'noborder.cfg'
unset xtics
unset ytics
# grid
unset grid
# plotting
load 'array.cfg' # for @array_active
load 'localization.cfg' # @point_source
plot 'array.txt' @array_active,\
  set_point_source(0,2.5) @point_source,\
  for[ii=0:Nsecond-1] 'fS.txt' every ::ii::ii ls ii+1 lw 2 pt 2 ps 1.0,\
  for[ii=0:Nsecond-1] 'fS.txt' every ::ii::ii using 1:2:(sprintf('\\ft %d',ii)) with labels offset graph 0.065,-0.035 tc ls ii+1

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
