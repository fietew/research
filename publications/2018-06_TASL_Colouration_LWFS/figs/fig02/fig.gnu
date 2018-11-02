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
load 'standalone.cfg'
load 'border.cfg'
load 'array.cfg'
load 'labels.cfg'
load 'colorbar.cfg'

################################################################################
set t epslatex size 18.1cm,8.25cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

unset key

# labels
set label 1 at graph 0.0, 1.15 front left '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 2 at graph 0.15, 1.15 front left
set label 3 at graph 0.0, 1.05 front left
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 0.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_B = 0.5
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
# variables
sx = 0.17
sy = 0.45
oriy1 = 0.51
oriy2 = 0.05
orix1 = 0.05
orix2 = 0.23
orix3 = 0.41
orix4 = 0.59
orix5 = 0.77

################################################################################

set multiplot layout 2,5

################################################################################
#### plot 1 ####
# labels
set label 2 '\ft point source'
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
# plotting
filename = 'posx0.00_posy0.00_ref'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active

#### plot 2 #####
# labels
set label 2 '\ft WFS'
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_wfs'
plot filename.'.dat' binary matrix with image, \
  'posx0.00_posy0.00_circular_nls0056_dls3.00_nfchoa_M27_rect_ls.txt' @array_active

#### plot 3 #####
# labels
set label 2 '\ft HOA: $M=27$, rect.'
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_nfchoa_M27_rect'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rM.txt' with lines ls 1

#### plot 4 ####
# labels
set label 2 '\ft HOA: $M=13$, rect.'
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_top
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_nfchoa_M13_rect'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rM.txt' with lines ls 1

#### plot 5 #####
# labels
set label 2 '\ft LWFS-SBL: $M=27$,'
set label 3 '\ft rect., $N_{\mathrm{pw}}=1024$'
# positioning
set size sx, sy
set origin orix5, oriy1
@pos_top_right
# variables
xeval = '0.00'
yeval = '0.00'
src = 'pw'
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_rect_npw1024'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rM.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 6 #####
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# plotting
filename = 'posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M27_rect_npw1024'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rM.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 7 #####
# labels
set label 2 '\ft LWFS-SBL: $M=11$,'
set label 3 '\ft rect., $N_{\mathrm{pw}}=1024$'
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom
# plotting
filename = 'posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M11_rect_npw1024'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rM.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 8 ####
# labels
set label 2 '\ft LWFS-SBL: $M=27$,'
set label 3 '\ft rect., $N_{\mathrm{pw}}=64$'
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_rect_npw0064'
plot filename.'.dat' binary matrix with image, \
  filename.'_ls.txt' @array_active, \
  filename.'_rM.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 9 #####
# labels
set label 2 '\ft LWFS-VSS: '
set label 3 '\ft $\sfcylr[subscript=local] = 45$ cm, $N_{\mathrm{fs}}=1024$'
# positioning
set size sx, sy
set origin orix4, oriy2
@pos_bottom
# plotting
filename = 'posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs'
plot filename.'.dat' binary matrix with image, \
  'posx0.00_posy0.00_circular_nls0056_dls3.00_nfchoa_M27_rect_ls.txt' @array_active,\
  filename.'_rM.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

#### plot 10 ####
# labels
set label 2 '\ft LWFS-VSS:'
set label 3 '\ft $\sfcylr[subscript=local] = 45$ cm, $N_{\mathrm{fs}}=1024$'
# positioning
set size sx, sy
set origin orix5, oriy2
@pos_bottom_right
# colorbar
set colorbox @colorbar_east
# plotting
filename = 'posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs'
plot filename.'.dat' binary matrix with image, \
  'posx0.00_posy0.00_circular_nls0056_dls3.00_nfchoa_M27_rect_ls.txt' @array_active,\
  filename.'_rM.txt' with lines ls 1, \
  filename.'_xc.txt' with points ls 1 ps 1.5 pt 2

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
