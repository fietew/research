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

load 'border.cfg'
load 'Moreland.plt'
load 'array.cfg'

set style line 11 lc rgb 'black' lt 2 lw 4 ps 0.75

################################################################################
set t epslatex size 11cm,6cm color colortext header '\newcommand\ft\footnotesize'
set output 'tmp.tex';

# legend
unset key
# labels
load 'labels.cfg'
set label 1 @label_northeast
set label 2 at graph 1.15, 0.5 center rotate by 90
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 0.5
# axes
set format '\ft $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.0
LABEL_X = '\ft $x$ / m'
# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel offset 4.0,0
LABEL_Y = '\ft $y$ / m'
# c-axis
set cbrange [-60:0]
set cbtics offset -0.5,0
set cbtics 10
set cbtics add ('\ft $0$ dB' 0)
# colorbar
load 'colorbar.cfg'
unset colorbox

################################################################################

set multiplot
set size 0.20, 0.40
set size ratio -1

################################################################################
#### plot 1 #####
set origin 0.05,0.5
# labels
set label 1 '\ft no bandwidth limitation'
# positioning
@pos_top_left
# c-axis
load 'sequential/Blues.plt'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls3000_wo150_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 2 #####
set origin 0.275,0.5
# labels
set label 1 '\ft $M=7$, rect.'
# positioning
@pos_top
# c-axis
load 'sequential/Reds.plt'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls3000_wo07_wrect'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 3 #####
set origin 0.5,0.5
# labels
set label 1 '\ft $M=13$, rect.'
# positioning
@pos_top
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls3000_wo13_wrect'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 4 #####
set origin 0.725,0.5
# labels
set label 1 '\ft $M=13$, max-$r_E$'
set label 2 '\scriptsize continuous array'
# positioning
@pos_top_right
# c-axis
load 'sequential/Greens.plt'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls3000_wo13_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 5 #####
set origin 0.05,0.1
# labels
unset label 1
set label 2 ''
# positioning
@pos_bottom_left
# c-axis
load 'sequential/Blues.plt'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls0056_wo150_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 6 #####
set origin 0.275,0.1
# positioning
@pos_bottom
# c-axis
load 'sequential/Reds.plt'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls0056_wo07_wrect'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 7 #####
set origin 0.5,0.1
# positioning
@pos_bottom
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls0056_wo13_wrect'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

#### plot 8 #####
set origin 0.725,0.1
# labels
set label 2 '\scriptsize discrete array'
# positioning
@pos_bottom_right
# c-axis
load 'sequential/Greens.plt'
# plotting
filename = 'posx0.00_posy0.00_nfchoa_nls0056_wo13_wmax-rE'
plot 'soundfield_'.filename.'.dat' binary matrix with image, \
  'array_'.filename.'.txt' @array_active

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
