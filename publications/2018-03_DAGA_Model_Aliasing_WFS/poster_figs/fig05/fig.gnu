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

# reset
set macros
set loadpath '../../../../tools/gnuplot/'

load 'border.cfg'
load 'array.cfg'

################################################################################
set t epslatex size 37cm,15cm color colortext
set output 'tmp.tex'

# legend
unset key
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0.0
SPACING_VERTICAL = 0.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_B = 0.5
# axes
set size ratio -1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-2:2]
set xtics 1.5 offset 0,0
set xlabel offset 0,-2
LABEL_X = '$x$ / m'
# y-axis
set yrange [0:4]
set ytics 1 offset 0.5,0
set ylabel offset -1,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
# style
set style line 101 lc rgb 'black' lw 4
set style line 211 lc rgb '#000000' lt 1 lw 3 pt 7 ps 2  # array_active
# labels
load 'labels.cfg'
set label 1 at graph 0.0, 1.08 left front
set label 2 at graph 1.07, 1.08 center front tc rgb '#808080'
# variables
sx = 0.17
sy = 0.42
oriy1 = 0.525
oriy2 = 0.04
orix1 = 0*sx + 0.05
orix2 = 1*sx + 0.12
orix3 = 2*sx + 0.13
orix4 = 3*sx + 0.14
orix5 = 4*sx + 0.15

################################################################################
set multiplot layout 2,5

set view map
unset surface
set contour base
# set cntrlabel format '%8.3g' font ',7' start 0 interval 1000
# set cntrparam order 4
set cntrparam points 2
set cntrparam linear
set format '%g'
freqs = "700 800 900 1000"
do for [f in freqs] {
  set cntrparam level discrete (f+0.0)
  set table 'cont_f'.f.'.txt'
  splot 'linear_s4.00_N18_RcInf_Rl0.10_fal.dat' u 1:(-$2):3 binary matrix w l
  unset table
}
freqs = "1400 1600 1800 2000"
do for [f in freqs] {
  set cntrparam level discrete (f+0.0)
  set table 'cont_f'.f.'.txt'
  splot 'linear_s4.00_N35_RcInf_Rl0.10_fal.dat' u 1:(-$2):3 binary matrix w l
  unset table
}

#### plot 1 ####
# labels
set label 1 '\footnotesize $\Delta_x \approx 23,5$ cm'
set label 2 '\footnotesize kHz'
set label 3 at graph 0.5, 1.25 center front '$\footnotesize \sff[superscript=sampled](\sfpos)$'
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
# c-axis
set cbrange [0.7:1.1]
set cbtics (0.7,0.8,0.9,1.0)
set format cb '\footnotesize $%g$'
# palette
set palette maxcolors 4
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
# colorbar
set colorbox @colorbar_east
# plotting
plot 'linear_s4.00_N18_RcInf_Rl0.10_fal.dat' u 1:(-$2):($3/1000) binary matrix with image,\
  'ps_wfs_linear_s4.00_N18_f700.00_etaNaN_x0.txt' @array_active

#### plot 2 ####
# labels
set label 1 '\footnotesize $\Delta_x \approx 11,8$ cm'
unset label 3
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# c-axis
set cbrange [1.4:2.2]
set cbtics (1.4,1.6,1.8,2.0)
# plotting
plot 'linear_s4.00_N35_RcInf_Rl0.10_fal.dat' u 1:(-$2):($3/1000) binary matrix with image,\
  'ps_wfs_linear_s4.00_N35_f1400.00_etaNaN_x0.txt' @array_active

#### plot 3 ####
# labels
set label 1 '\footnotesize $f = 0.7$ kHz'
set label 2 ''
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
unset colorbox
# plotting
filename = 'ps_wfs_linear_s4.00_N18_f700.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f700.txt' w l ls 101

#### plot 4 ####
# labels
set label 1 '\footnotesize $f = 1.4$ kHz
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom
# plotting
filename = 'ps_wfs_linear_s4.00_N35_f1400.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f1400.txt' w l ls 101

#### plot 5 ####
# labels
set label 1 '\footnotesize $f = 0.8$ kHz
set label 3 at graph 1.1, 1.25 center front '$\footnotesize \sfpressure[superscript=sampled](\sfpos,\sfomega)$'
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top
# plotting
filename = 'ps_wfs_linear_s4.00_N18_f800.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f800.txt' w l ls 101

#### plot 6 ####
# labels
set label 1 '\footnotesize $f = 1.6$ kHz
unset label 3
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# plotting
filename = 'ps_wfs_linear_s4.00_N35_f1600.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f1600.txt' w l ls 101

#### plot 7 ####
# labels
set label 1 '\footnotesize $f = 0.9$ kHz
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_top
# plotting
filename = 'ps_wfs_linear_s4.00_N18_f900.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f900.txt' w l ls 101

#### plot 8 ####
# labels
set label 1 '\footnotesize $f = 1.8$ kHz
# positioning
set size sx, sy
set origin orix4, oriy2
@pos_bottom
# plotting
filename = 'ps_wfs_linear_s4.00_N35_f1800.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f1800.txt' w l ls 101

#### plot 9 ####
# labels
set label 1 '\footnotesize $f = 1.0$ kHz
unset label 2
# positioning
set size sx, sy
set origin orix5, oriy1
@pos_top_right
# plotting
filename = 'ps_wfs_linear_s4.00_N18_f1000.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f1000.txt' w l ls 101

#### plot 10 ####
# labels
set label 1 '\footnotesize $f = 2.0$ kHz
# positioning
set size sx, sy
set origin orix5, oriy2
@pos_bottom_right
# plotting
filename = 'ps_wfs_linear_s4.00_N35_f2000.00_etaNaN'
plot filename.'_P.dat' binary matrix u 1:(-$2):3 with image,\
  filename.'_x0.txt' @array_active,\
  'cont_f2000.txt' w l ls 101

################################################################################
unset multiplot

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
set output 'tmp.tex'
