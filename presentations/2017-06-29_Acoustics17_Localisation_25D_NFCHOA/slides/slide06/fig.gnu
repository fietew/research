#!/usr/bin/gnuplot

#*****************************************************************************
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

load 'border.cfg'
load 'moreland.pal'
load 'array.cfg'

set style line 11 lc rgb 'black' lt 2 lw 4 ps 0.75

################################################################################
set t pngcairo size 400,400 enhanced

# legend
unset key
# margins
set lmargin 0
set rmargin 0
set bmargin 0
set tmargin 0
# borders
set border 0
# axes
unset tics
# x-axis
set xrange [-1.55:1.55]
# y-axis
set yrange [-1.55:1.55]
# c-axis
set cbrange [-60:0]
# colorbar
unset colorbox

################################################################################

#### plot 1 #####
set output 'fig1.png'
# c-axis
load 'blues.pal'
# plotting
filename = 'posx0.00_posy0.00_ref'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \

#### plot 2 #####
set output 'fig2.png'
# c-axis
load 'greens.pal'
# plotting
filename = 'posx0.00_posy0.00_pw_wo13_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \

#### plot 3 #####
set output 'fig3.png'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls3000_wo13_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 4 #####
set output 'fig4.png'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls0056_wo13_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active
