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

################################################################################
set t epslatex size 37cm,27cm color colortext
set output 'tmp.tex'

# legend
unset key
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 0
SPACING_VERTICAL = 0
OUTER_RATIO_L = 0.95
OUTER_RATIO_R = 0
OUTER_RATIO_T = 0.5
OUTER_RATIO_B = 0.5
# some stats
stats 'ps_wfs_linear_s64.00_N129_f1000.00_eta1_xSeta.txt' skip 1 nooutput
colpw = STATS_columns/2
stats 'ps_wfs_linear_s64.00_N129_f1000.00_eta1_xSeta.txt' skip 1 nooutput
colps = STATS_columns/2
# axes
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-3.75:3.75]
set xtics 2 offset 0,0
set xlabel offset 0,-2
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1:2]
set ytics 1 offset 0.5,0
set ylabel offset 1,0
LABEL_Y = '$y$ / m'
# c-axis
set cbrange [-2:2]
set cbtics 1
# palette (combination of RdBu.plt and Greys.plt)
set palette defined (\
          - 2.0     '#FFFFFF',\
          -12.0/7   '#F0F0F0',\
          -10.0/7   '#D9D9D9',\
          - 8.0/7   '#BDBDBD',\
          - 6.0/7   '#969696',\
          - 4.0/7   '#737373',\
          - 2.0/7   '#525252',\
          - 0.000001'#252525',\
            0.0     '#B2182B',\
            2.0/7   '#D6604D',\
            4.0/7   '#F4A582',\
            6.0/7   '#FDDBC7',\
            8.0/7   '#D1E5F0',\
           10.0/7   '#92C5DE',\
           12.0/7   '#4393C3',\
            2.0     '#2166AC')
set palette negative
# colorbar
load 'colorbar.cfg'
unset colorbox
# style
set style line 101 lc rgb '#00AA00' pt 6 ps 3 linewidth 4
set style line 102 lc rgb 'white' pt 6 ps 3 linewidth 4
set style line 103 lc rgb 'red' pt 7 ps 3 linewidth 4
# labels
load 'labels.cfg'
set label 1 at graph 1.0, 0.85 right front
set label 2 at graph 0.0, 1.125 left front
set label 3 at graph 1.0, 0.1 right front tc rgb 'white'
# variables
vlen = 0.2
sx = 0.44
sy = 0.30
oriy1 = 0.65
oriy2 = 0.35
oriy3 = 0.05
orix1 = 0.05
orix2 = 0.52
bound = 0.49999
# function
upper(x) = x< bound ? x :  bound
lower(x) = x>-bound ? x : -bound
trunc(x) = upper(lower(bound*x))
color(x,y) = y < 0 ? trunc(x) + 0.5 : trunc(x) - 1.0

################################################################################
set multiplot layout 3,2

#### plot 1 ####
# axes
set size ratio -1
# labels
set label 1 '$\sfpressure[superscript=sampled](\sfpos,\sfomega)$'
set label 2 '\textbf{(a)}'
set label 3 '$\sfvirtualsource(\sfpos,\sfomega)$'
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
# plotting
filename = 'ps_wfs_linear_s64.00_N129_f1000.00_eta0'
plot filename.'_PS.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_x0S.txt' @array_continuous,\

#### plot 2 ####
# labels
set label 1 '$\sfpressure[superscript=sampled]_0(\sfpos,\sfomega) = \sfpressure(\sfpos,\sfomega)$'
set label 2 '\textbf{(b)}'
unset label 3
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top_right
# plotting
filename = 'ps_wfs_linear_s64.00_N129_f1000.00_eta0'
plot filename.'_PSeta.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_kgt.txt' u ($1-$4*0.5*vlen):($2 < 0 ? $2-$5*0.5*vlen : NaN):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 102,\
  filename.'_x0al.txt' @array_continuous,\
  filename.'_x0on.txt' using 1:2 w p ls 101,\
  filename.'_x0off.txt' using 1:2 w p ls 103,\
  for [i=1:colps] filename.'_xSeta.txt' using 2*i-1:2*i w l ls 101

#### plot 3 ####
# labels
set label 1 '$\sfpressure[superscript=sampled]_{-1}(\sfpos,\sfomega)$'
set label 2 '\textbf{(c)}'
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_left
# colorbar
unset colorbox
# plotting
filename = 'ps_wfs_linear_s64.00_N129_f1000.00_eta-1'
plot filename.'_PSeta.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_kgt.txt' u ($1-$4*0.5*vlen):($2 < 0 ? $2-$5*0.5*vlen : NaN):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 102,\
  filename.'_x0al.txt' @array_continuous,\
  filename.'_x0on.txt' using 1:2 w p ls 101,\
  filename.'_x0off.txt' using 1:2 w p ls 103,\
  for [i=1:colps] filename.'_xSeta.txt' using 2*i-1:2*i w l ls 101

#### plot 4 ####
# labels
set label 1 '$\sfpressure[superscript=sampled]_1(\sfpos,\sfomega)$'
set label 2 '\textbf{(d)}'
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_right
# plotting
filename = 'ps_wfs_linear_s64.00_N129_f1000.00_eta1'
plot filename.'_PSeta.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_kgt.txt' u ($1-$4*0.5*vlen):($2 < 0 ? $2-$5*0.5*vlen : NaN):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 102,\
  filename.'_x0al.txt' @array_continuous,\
  filename.'_x0on.txt' using 1:2 w p ls 101,\
  filename.'_x0off.txt' using 1:2 w p ls 103,\
  for [i=1:colps] filename.'_xSeta.txt' using 2*i-1:2*i w l ls 101

#### plot 5 ####
# labels
set label 1 '$\sfpressure[superscript=sampled]_{-2}(\sfpos,\sfomega)$'
set label 2 '\textbf{(e)}'
# positioning
set size sx, sy
set origin orix1, oriy3
@pos_bottom_left
# plotting
filename = 'ps_wfs_linear_s64.00_N129_f1000.00_eta-2'
plot filename.'_PSeta.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_kgt.txt' u ($1-$4*0.5*vlen):($2 < 0 ? $2-$5*0.5*vlen : NaN):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 102,\
  filename.'_x0al.txt' @array_continuous,\
  filename.'_x0on.txt' using 1:2 w p ls 101,\
  filename.'_x0off.txt' using 1:2 w p ls 103,\
  for [i=1:colps] filename.'_xSeta.txt' using 2*i-1:2*i w l ls 101

#### plot 6 ####
# labels
set label 1 '$\sfpressure[superscript=sampled]_2(\sfpos,\sfomega)$'
set label 2 '\textbf{(f)}'
# positioning
set size sx, sy
set origin orix2, oriy3
# positioning
@pos_bottom_right
# plotting
filename = 'ps_wfs_linear_s64.00_N129_f1000.00_eta2'
plot filename.'_PSeta.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_kgt.txt' u ($1-$4*0.5*vlen):($2 < 0 ? $2-$5*0.5*vlen : NaN):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 102,\
  filename.'_x0al.txt' @array_continuous,\
  filename.'_x0on.txt' using 1:2 w p ls 101,\
  filename.'_x0off.txt' using 1:2 w p ls 103,\
  for [i=1:colps] filename.'_xSeta.txt' using 2*i-1:2*i w l ls 101

################################################################################
unset multiplot

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
set output 'tmp.tex'
