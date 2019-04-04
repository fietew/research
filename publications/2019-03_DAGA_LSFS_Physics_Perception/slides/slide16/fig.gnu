#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2018      Fiete Winter                                       *
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
load 'standalone.cfg'

################################################################################
set terminal epslatex size @intbeamerwidth,6.5cm color colortext standalone header intbeamer.footnotesize
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0.0,1.35
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 3,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
# axes
set size ratio -1
set tics scale 0.75 out nomirror
# style
set style line 101 lc rgb 'black' lw 4
set style line 102 lc rgb 'black' lw 4 dt 2
set style line 103 lc rgb 'black' lw 4 pt 2
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.18 center front
set label 2 at graph 0.0, 1.07 left front
set label 3 center front tc rgb '#808080'
# variables
sx = 0.21
sy = 0.5
oriy1 = 0.465
oriy2 = 0.035
orix1 = 0*sx + 0.06
orix2 = 1*sx + 0.07
orix3 = 2*sx + 0.08
orix4 = 3*sx + 0.09
Mvec = '20 34'
fvec = '1500 2500'
# functions
db(x) = 20*log10(x)
flabel = 'sprintf(''$f = %1.1f$ kHz'', f/1000.0)'
Mlabel = 'sprintf(''$M = %d$'', M)'

################################################################################
set multiplot layout 1,5

# contours
set view map
unset surface
set contour base
set format '%g'
do for [ii=1:words(Mvec)] {
  M = word(Mvec, ii)+0
  do for [jj=1:words(fvec)] {
    f = word(fvec,jj)+0
    set cntrparam level incremental f, f, f
    set table sprintf('cont_fS_M%d_f%d.txt', M, f)
    splot sprintf('fS_M%d.dat', M) binary matrix w l
    unset table
    set table sprintf('cont_fM_M%d_f%d.txt', M, f)
    splot sprintf('fM_M%d.dat', M) binary matrix w l
    unset table
  }
}

#### plot 1 ####
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
unset colorbox
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
# variables
M = word(Mvec, 1)+0
f = word(fvec, 1)+0
# labels
set label 1 @flabel
set label 2 @Mlabel
# plotting
load 'plotP.gnu'

#### plot 2 ####
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# variables
M = word(Mvec, 2)+0
# labels
set label 1 ''
set label 2 @Mlabel
# plotting
load 'plotP.gnu'

#### plot 3 ####
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# variables
M = word(Mvec, 1)+0
f = word(fvec, 2)+0
# labels
set label 1 @flabel
set label 2 @Mlabel
# plotting
load 'plotP.gnu

#### plot 4 ####
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom
# variables
M = word(Mvec, 2)+0
# labels
set label 1 ''
set label 2 @Mlabel
# plotting
load 'plotP.gnu

#### plot 5 ####
# variables
M = word(Mvec, 1)+0
# labels
set label 1 '$\sffS(\sfpos)$'
set label 2 @Mlabel
# palette
set palette maxcolors 4
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette positive
# c-axis
set cbrange [1:3]
set cbtics 0.5
# colorbar
set colorbox vert user origin graph 2.10, 0.0 size graph 0.05,1.0
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top
# plotting
plot 'fS_M20.dat' u 1:2:($3/1000) binary matrix with image,\
  'array.txt' @array_active,\
  'xref.txt' w p ls 103

#### plot 6 ####
# variables
M = word(Mvec, 2)+0
# labels
set label 1 ''
set label 2 @Mlabel
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# colorbar
unset colorbox
# plotting
plot 'fS_M34.dat' u 1:2:($3/1000) binary matrix with image,\
  'array.txt' @array_active,\
  'xref.txt' w p ls 103

#### plot 7 ####
# variables
M = word(Mvec, 1)+0
# labels
set label 1 '$\sff[superscript=sbl](\sfpos)$'
set label 2 @Mlabel
set label 3 at graph 1.075, 1.075 'kHz'
# palette
load 'sequential/Purples.plt'  # see gnuplot-colorbrewer
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_top_right
# plotting
plot 'fM_M20.dat' u 1:2:($3/1000) binary matrix with image,\
  'array.txt' @array_active,\
  'xref.txt' w p ls 103

#### plot 8 ####
# variables
M = word(Mvec, 2)+0
# labels
set label 1 ''
set label 2 @Mlabel
set label 3 ''
# positioning
set size sx, sy
set origin orix4, oriy2
@pos_bottom_right
# colorbar
set colorbox @colorbar_east
# plotting
plot 'fM_M34.dat' u 1:2:($3/1000) binary matrix with image,\
  'array.txt' @array_active,\
  'xref.txt' w p ls 103

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
