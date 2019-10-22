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

load 'localization.cfg'
load 'noborder.cfg'
load 'array.cfg'
load 'standalone.cfg'

# latex
set terminal epslatex size 3.9cm,5.5cm color colortext standalone header intbeamer.footnotesize
set output 'fig.tex'

unset key
unset tics
unset colorbox

set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

set size ratio -1

set xrange [-1.51:1.51]
set yrange [-1.55:2.65]
set cbrange [0:1]

set palette defined ( 0 '#1F78B4', 1 '#1F78B4')

set arrow 1 from first 0.35,0 rto first 0,0.75 lw 3 lc rgb 'gray' heads size 0.1,90
set arrow 2 from first 0,-0.1 rto first -0.5,0 lw 3 lc rgb 'gray' heads size 0.1,90
set arrow 3 from first -0.2,0 rto first 0,2.5 lw 3 lc rgb 'gray' heads size 0.1,90

set label 1 at first 0.5, 0.375 '$75\,\mathrm{cm}$'
set label 2 at first -0.5, -0.35 '$50\,\mathrm{cm}$'
set label 3 at first -0.35, 2.0 '$2.5\,\mathrm{m}$' right

################################################################################

plot 'listener.txt' using 1:2 w p pt 2 ps 1 lc rgb 'black',\
  'listener.txt' using 1:2:('$1$') with labels tc rgb 'black' left offset 0.0,-0.6 ,\
  'listener.txt' @localization_arrow,\
  'array.txt' @array_active,\
  set_point_source(0,2.5) @point_source

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
