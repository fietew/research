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
load 'array.cfg'



################################################################################
set t epslatex size 34cm, 12cm color colortext
set output 'tmp.tex';

unset key

# linestyles
set style line 11 lc rgb 'black' lt 2 lw 4 ps 3
set style line 12 lc rgb 'black' lt 1 lw 3 pt 7 ps 3
# labels
load 'labels.cfg'
set label 1 @label_northeast
set label 2 @label_title
# axes
set size ratio -1
set format '$%g$'
set tics scale 4 out nomirror
# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,-1
set xlabel '$x$ / m' offset 0,-2
# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset -1,0
set ylabel '$y$ / m' offset -2,0
# colorbar
load 'colorbar.cfg'
load 'Moreland.plt'  # colormap
set cbrange [-1:1]  # mininum and maximum value of colorbar
set cbtics 1
unset colorbox
# margins
set bmargin 3
set tmargin 3

################################################################################
set multiplot layout 1,3

# plot 1
set lmargin 3
set rmargin 0
set label 1 'focused source'
plot 'sound_field_wfs_fs.dat' binary matrix with image,\
     'array.txt' ls 12

# plot 2
set format y '' # remove labels of tics
unset ylabel # remove label of y-axis
set lmargin 1.5
set rmargin 1.5
set label 1 'local WFS'
plot 'sound_field_lwfs_ls.dat' binary matrix with image,\
     'array.txt' ls 12, \
     'virtual_array.txt' ls 11

# plot 3
set lmargin 0
set rmargin 3
set colorbox @colorbar_east
set label 1 'WFS'
unset label  2
plot 'sound_field_wfs_ls.dat' binary matrix with image,\
     'array.txt' ls 12
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
