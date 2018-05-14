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

load 'border.cfg'
load 'array.cfg'
load 'labels.cfg'
load 'colorbar.cfg'

################################################################################
set t epslatex size 8.5cm,10.5cm color colortext header '\newcommand\ft\footnotesize\newcommand\st\scriptsize'
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_northwest
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 3.0
SPACING_VERTICAL = 1.5
OUTER_RATIO_L = 1.0
OUTER_RATIO_R = 1.0
OUTER_RATIO_T = 0.5
OUTER_RATIO_B = 1
INNER_RATIO_V = 0.25
# axes
set size ratio -1
set format '\ft $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.25
LABEL_X = '\ft $x$ / m'
# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel offset 4.0,0
LABEL_Y = '\ft $y$ / m'
# c-axis
load 'Moreland.plt'
set cbrange [-1:1]
set cbtics 1
# colorbar
load 'colorbar.cfg'
unset colorbox
# linestyle
set style line 1 lc rgb 'black' lw 4

################################################################################

set multiplot layout 3,2

################################################################################
#### plot 1 #####
# labels
set label 1 '\ft \textbf{a)} point source'
# positioning
@pos_top_left
# variables
xeval = '0.00'
yeval = '0.00'
src = 'pw'
# plotting
filename = 'posx0.00_posy0.00_ref'
plot filename.'_Pf2000.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active

#### plot 2 #####
# labels
set label 1 '\ft \textbf{b)} WFS \cite[Eq.~(2.137)]{Schultz2016-PHD}'
# positioning
@pos_top_right
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_wfs'
plot filename.'_Pf2000.dat' binary matrix with image, \
  'posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_npw1024_ls.txt' @array_active

#### plot 3 #####
# labels
set label 1 '\ft \textbf{c)} LWFS 1024 27'
# positioning
@pos_left
# variables
src = 'ps'
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_npw1024'
plot filename.'_Pf2000.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rMf2000.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 4 #####
# labels
set label 1 '\ft \textbf{d)} LWFS 64 27'
set label 2 ''
# positioning
@pos_right
# colorbar
set colorbox @colorbar_east
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_npw0064'
plot filename.'_Pf2000.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rMf2000.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 5 ####
# labels
set label 1 '\ft \textbf{e)} LWFS 1024 27 Off'
# positioning
@pos_bottom_left
# colorbar
unset colorbox
# plotting
filename = 'posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M27_npw1024'
plot filename.'_Pf2000.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rMf2000.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 6 ####
# labels
set label 1 '\ft \textbf{f)} LWFS 1024 11 Off'
# positioning
@pos_bottom_right
# plotting
filename = 'posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M11_npw1024'
plot filename.'_Pf2000.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rMf2000.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
