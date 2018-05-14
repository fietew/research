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
set t epslatex size 17.9cm,6.5cm color colortext
set output 'tmp.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_northwest
# x-axis
set xrange [-2.3:2.3]
set xtics 2 offset 0,0.5
# y-axis
set yrange [-2.3:2.3]
set ytics 2 offset 0.5,0
# colorbar
load 'colorbar.cfg'
unset colorbox
# axes
set size ratio -1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

################################################################################

set multiplot layout 2,6

################################################################################

#### plot 1 #####

# labels
set label 1 '\footnotesize Ground Truth'
# x-axis
set xtics format ''
# y-axis
set ylabel '$y$ / m' offset 4.0,0
# c-axis
load 'Moreland.plt'
set cbrange [-1:1]
set cbtics 1
# margins
set lmargin 2.5
set rmargin 0.0
set tmargin 1.0
set bmargin 0.0
# plotting
plot 'gt_real.dat' binary matrix with image

################################################################################

#### plot 2 ####

# labels
set label 1 '\footnotesize ESA'
# y-axis
set ylabel ''
set format y ''
# margins
set lmargin 1.25
set rmargin 1.25
# plotting
plot 'esa-rect_real.dat' binary matrix with image,\
  'array.txt' @array_active

################################################################################

#### plot 3 ####

# labels
set label 1 '\footnotesize WFS'
# plotting
plot 'wfs_real.dat' binary matrix with image,\
  'array.txt' @array_active

################################################################################

#### plot 4 ####

# labels
set label 1 '\footnotesize LWFS $R_c=0$ m'
# plotting
plot 'lwfs_3.50_0.00_real.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'lwfs_3.50_0.00_array.txt' @array_continuous

################################################################################

#### plot 5 ####

# labels
set label 1 '\footnotesize LWFS $R_c=1$ m'
# plotting
plot 'lwfs_3.50_1.00_real.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'lwfs_3.50_1.00_array.txt' @array_continuous

################################################################################

#### plot 6 ####

# labels
set label 1 '\footnotesize LWFS $R_c=1.75$ m'
# colorbar
set colorbox @colorbar_east
# margins
set lmargin 0.0
set rmargin 2.5
# plotting
plot 'lwfs_3.50_1.75_real.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'lwfs_3.50_1.75_array.txt' @array_continuous

################################################################################

#### plot 7 ####

# label
unset label 1
# x-axis
set xlabel '$x$ / m' offset 0,1
set xtics format '\footnotesize $%g$'
# y-axis
set ylabel '$y$ / m' offset 4.0,0
set format y '\footnotesize $%g$'
# c-axis
load 'sequential/Greens.plt'
set cbrange [-40:-25]
set cbtics 5
# set cbtics add ('\footnotesize $0$\,dB' 0)
# colorbar
unset colorbox
# margins
set lmargin 2.5
set rmargin 0.0
set tmargin 0.0
set bmargin 1.0
# plotting
plot 'gt_db.dat' binary matrix with image

################################################################################

#### plot 8 ####

# y-axis
unset ylabel
set format y ''
# margins
set lmargin 1.25
set rmargin 1.25
# plotting
plot 'esa-rect_db.dat' binary matrix with image,\
  'array.txt' @array_active

################################################################################

#### plot 9 ####

# plotting
plot 'wfs_db.dat' binary matrix with image,\
  'array.txt' @array_active

################################################################################

#### plot 10 ####

# plotting
plot 'lwfs_3.50_0.00_db.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'lwfs_3.50_0.00_array.txt' @array_continuous


################################################################################

#### plot 11 ####

# plotting
plot 'lwfs_3.50_1.00_db.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'lwfs_3.50_1.00_array.txt' @array_continuous

################################################################################

#### plot 12 ####

# colorbar
set colorbox @colorbar_east
# margins
set lmargin 0.0
set rmargin 2.5
# plotting
plot 'lwfs_3.50_1.75_db.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'lwfs_3.50_1.75_array.txt' @array_continuous

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
