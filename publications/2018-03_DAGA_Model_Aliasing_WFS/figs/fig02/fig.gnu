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

# reset
set macros
set loadpath '../../../../tools/gnuplot/'

load 'border.cfg'
load 'array.cfg'

################################################################################
set t epslatex size 8.7cm,4.5cm color colortext header '\newcommand\ft\footnotesize\newcommand\st\scriptsize'
set output 'tmp.tex'

# legend
unset key
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 5
SPACING_VERTICAL = 3
OUTER_RATIO_L = 0.9
OUTER_RATIO_R = 0.9
OUTER_RATIO_T = 0.5
OUTER_RATIO_B = 0.6
# some stats
stats 'ps_wfs_linear_s64.00_N257_f1000.00_eta0_rays.txt' skip 1 nooutput
colps = STATS_columns/2
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1
LABEL_X = '$x$ / m'
# y-axis
set yrange [1:-2]
set ytics ('\ft $-1$' 1, '\ft $2$' -2, '\ft $1$' -1, 0) offset 0.5,0
# set format y '\footnotesize $%g$'
set ylabel offset 4,0
LABEL_Y = '$y$ / m'
# colorbar
load 'colorbar.cfg'
unset colorbox
# axes
set size ratio -1
set format '$%g$'
set tics scale 0.75 out nomirror
# style
set style line 101 lc rgb '#00AA00' pt 6 ps 1 linewidth 2
set style line 102 lc rgb 'white' pt 6 ps 1 linewidth 1
set style line 103 lc rgb 'yellow' pt 7 ps 1 linewidth 1
set style line 104 lc rgb 'red' pt 6 ps 1 linewidth 2
# labels
load 'labels.cfg'
set label 1 @label_north
# variables
filename = 'ps_wfs_linear_s64.00_N257_f1000.00_eta0'
vlen = 0.12
bound = 0.49999
# functions
upper(x) = x< bound ? x :  bound
lower(x) = x>-bound ? x : -bound
trunc(x) = upper(lower(bound*x))
color(x,y) = y > 0 ? trunc(x) + 0.5 : trunc(x) - 1.0
db(x) = 20*log10(x)

################################################################################
set multiplot layout 1,2

#### plot 1 ####
# labels
set label 1 '\ft $\sfpressure(\sfx,\sfy,\sfomega)$ and $\sfvirtualsource(\sfx,\sfy,\sfomega)$'
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
# c-axis
set cbrange [-2:2]
set cbtics 1
# positioning
@pos_bottom_left
# plotting
plot filename.'_PS.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_Pgt.dat' binary matrix using 1:2:(color($3,$2)) with image,\
  filename.'_kgt.txt' u ($1-$4*0.5*vlen):($2 > 0 ? $2-$5*0.5*vlen : NaN):($4*vlen):($5*vlen) with vectors head size 0.1,20,60 ls 102,\
  filename.'_x0.txt' @array_continuous,\
  filename.'_x0Son.txt' using 1:2 w p ls 101,\
  filename.'_x0Soff.txt' using 1:2 w p ls 103,\
  filename.'_x0SSPA.txt' using 1:2 w p ls 104,\
  filename.'_raysSPA.txt' using 1:2 w l ls 104,\
  for [i=1:colps] filename.'_rays.txt' using 2*i-1:2*i w l ls 101

#### plot 2 ####
# labels
set label 1 '\ft $\hat\varepsilon_{\mathrm{SPA}}(\sfx,\sfy,\sfomega)$'
# palette
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette positive
# c-axis
set cbrange [-40:0]
set cbtics 10 offset -0.75,0
set format cb '\ft $%g$'
# y-axis
set ytics 1
# positioning
@pos_bottom_right
# colorbar
set colorbox @colorbar_east
# plotting
plot filename.'_PSerror.dat' u 1:2:(db($3)) binary matrix with image,\
  filename.'_x0.txt' @array_continuous,\
  filename.'_x0SSPA.txt' using 1:2 w p ls 104,\
  filename.'_raysSPA.txt' using 1:2 w l ls 104,\

################################################################################
unset multiplot

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
set output 'tmp.tex'
