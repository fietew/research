#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2012      Hagen Wierstorf                                    *
#                         Centre for Vision, Speech and Signal Processing    *
#                         University of Surrey                               *
#                         Guildford, GU2 7XH, UK                             *
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
set terminal epslatex size 3cm,6.5cm color colortext standalone header intbeamer
set output 'fig.tex'

unset key
unset tics
unset colorbox

set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

set size ratio -1

set xrange [-1.55:1.55]
set yrange [-1.55:2.65]

set style line 1 lc rgb 'black' pt 2 ps 1
set style line 2 lc rgb '#1F78B4' lw 4 lt 1

################################################################################

plot 'listener.txt' u 1:2 w p ls 1,\
  'listener.txt' with vectors head size 0.05,20,60 ls 2,\
  'array.txt' @array_active,\
  set_point_source(0,2.5) @point_source

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
