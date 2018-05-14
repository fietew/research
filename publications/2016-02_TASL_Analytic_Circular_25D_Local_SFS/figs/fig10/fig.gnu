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

################################################################################
set t epslatex size 6cm,6cm color colortext
set output 'tmp.tex'

unset key # deactivate legend

# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel '$x$ / m' offset 0,1

# c-axis
load 'Moreland.plt'
set cbrange [-1:1]
set cbtics 1

# colorbar
load 'colorbar.cfg'

# axes
set size ratio 1
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

# margins
set bmargin 2.0
set tmargin 0.5

# linestyles
set style line 51 lc rgb '#00ff00' lt 1 lw 4 # solid green
set style line 52 lc rgb '#00ff00' lt 2 lw 4 # dashed green
set style line 53 lc rgb '#00ff00' lt 3 lw 4 pt 2 ps 2 # green cross

set style line 54 lc rgb '#ff0000' lt 1 lw 4 # solid red
set style line 55 lc rgb '#ff0000' lt 2 lw 4 # dashed red

set style line 56 lc rgb '#00ffff' lt 1 lw 4 # solid cyan
set style line 57 lc rgb '#00ffff' lt 2 lw 4 # dashed cyan

set style line 58 lc rgb '#ff00ff' lt 2 lw 4 # dashed magenta

set style line 59 lc rgb '#ffff00' lt 1 lw 4 # solid orange
set style line 60 lc rgb '#ffff00' lt 2 lw 4 # dashed orange

################################################################################

#### plot 1 #####

# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel '$y$ / m' offset 4.0,0

# colorbar
unset colorbox

# margins
set lmargin 4.75
set rmargin 0.25

# plotting
plot 'sound_field_L56_Mprime21_phit45_f2000.dat' binary matrix with image,\
  'array_L56.txt' @array_active,\
  'rM_Mprime21_phit45_f2000.txt' u 1:2 w l ls 52,\
  'Xal_L56_Mprime21_phit45_f2000.txt' u 1:2 w l ls 56,\
  'Xal_L56_Mprime21_phit45_f2000.txt' u 3:4 w l ls 57,\
  'Xal_L56_Mprime21_phit45_f2000.txt' u 5:6 w l ls 57,\
  'Xpw_phit45.txt' u 1:2 w l ls 51,\
  'local_phit45.txt' u 1:2 w p ls 53

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig1}|' < tmp.tex > fig1.tex
!epstopdf tmp.eps --outfile='fig1.pdf'
set output 'tmp.tex'

################################################################################

#### plot 2 #####

# y-axis
set format y '' # remove labels of tics
unset ylabel # remove label of y-axis

# margins
set lmargin 2.5
set rmargin 2.5

# plotting
plot 'sound_field_L56_Mprime21_phit45_f3000.dat' binary matrix with image,\
  'array_L56.txt' @array_active,\
  'rM_Mprime21_phit45_f3000.txt' u 1:2 w l ls 52,\
  'Xal_L56_Mprime21_phit45_f3000.txt' u 1:2 w l ls 56,\
  'Xal_L56_Mprime21_phit45_f3000.txt' u 3:4 w l ls 57,\
  'Xal_L56_Mprime21_phit45_f3000.txt' u 5:6 w l ls 57,\
  'Xpw_phit45.txt' u 1:2 w l ls 51,\
  'local_phit45.txt' u 1:2 w p ls 53

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig2}|' < tmp.tex > fig2.tex
!epstopdf tmp.eps --outfile='fig2.pdf'
set output 'tmp.tex'

################################################################################

#### plot 3 #####

# colorbar
set colorbox @colorbar_east

# margins
set lmargin 0.25
set rmargin 4.75

# plotting
plot 'sound_field_L32_Mprime14_phit-45_f3000.dat' binary matrix with image,\
  'array_L32.txt' @array_active,\
  'rM_Mprime14_phit-45_f3000.txt' u 1:2 w l ls 52,\
  'Xal_L32_Mprime14_phit-45_f3000.txt' u 1:2 w l ls 56,\
  'Xal_L32_Mprime14_phit-45_f3000.txt' u 3:4 w l ls 57,\
  'Xal_L32_Mprime14_phit-45_f3000.txt' u 5:6 w l ls 57,\
  'Xpw_phit-45.txt' u 1:2 w l ls 51,\
  'local_phit-45.txt' u 1:2 w p ls 53

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig3}|' < tmp.tex > fig3.tex
!epstopdf tmp.eps --outfile='fig3.pdf'
set output 'tmp.tex'

################################################################################

#### plot 4 #####

# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel '$y$ / m' offset 4.0,0
set format y '\footnotesize $%g$'

# colorbar
unset colorbox

# margins
set lmargin 4.75
set rmargin 0.25

# plotting
plot 'sound_field_L56_Mprime21_phit-45_f2000.dat' binary matrix with image,\
  'array_L56.txt' @array_active,\
  'rM_Mprime21_phit-45_f2000.txt' u 1:2 w l ls 52,\
  'Xal_L56_Mprime21_phit-45_f2000.txt' u 1:2 w l ls 56,\
  'Xal_L56_Mprime21_phit-45_f2000.txt' u 3:4 w l ls 57,\
  'Xal_L56_Mprime21_phit-45_f2000.txt' u 5:6 w l ls 57,\
  'Xpw_phit-45.txt' u 1:2 w l ls 51,\
  'local_phit-45.txt' u 1:2 w p ls 53

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig4}|' < tmp.tex > fig4.tex
!epstopdf tmp.eps --outfile='fig4.pdf'
set output 'tmp.tex'

################################################################################

#### plot 5 #####

# y-axis
set format y '' # remove labels of tics
unset ylabel # remove label of y-axis

# margins
set lmargin 2.5
set rmargin 2.5

# plotting
plot 'sound_field_L56_Mprime21_phit-45_f3000.dat' binary matrix with image,\
  'array_L56.txt' @array_active,\
  'rM_Mprime21_phit-45_f3000.txt' u 1:2 w l ls 52,\
  'Xal_L56_Mprime21_phit-45_f3000.txt' u 1:2 w l ls 56,\
  'Xal_L56_Mprime21_phit-45_f3000.txt' u 3:4 w l ls 57,\
  'Xal_L56_Mprime21_phit-45_f3000.txt' u 5:6 w l ls 57,\
  'rAux_L56_Mprime21_phit-45_f3000.txt' u 1:2 w l ls 60,\
  'rAux_L56_Mprime21_phit-45_f3000.txt' u 3:4 w l ls 60,\
  'rAux_L56_Mprime21_phit-45_f3000.txt' u 5:6 w l ls 60,\
  'Xpw_phit-45.txt' u 1:2 w l ls 51,\
  'local_phit-45.txt' u 1:2 w p ls 53

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig5}|' < tmp.tex > fig5.tex
!epstopdf tmp.eps --outfile='fig5.pdf'
set output 'tmp.tex'

################################################################################

#### plot 6 #####

# colorbar
set colorbox @colorbar_east

# margins
set lmargin 0.25
set rmargin 4.75

# plotting
plot 'sound_field_L56_Mprime14_phit-45_f3000.dat' binary matrix with image,\
  'array_L56.txt' @array_active,\
  'rM_Mprime14_phit-45_f3000.txt' u 1:2 w l ls 52,\
  'Xal_L56_Mprime14_phit-45_f3000.txt' u 1:2 w l ls 56,\
  'Xal_L56_Mprime14_phit-45_f3000.txt' u 3:4 w l ls 57,\
  'Xal_L56_Mprime14_phit-45_f3000.txt' u 5:6 w l ls 57,\
  'Xal_L56_Mprime21_phit-45_f3000.txt' u 1:2 w l ls 60,\
  'Xpw_phit-45.txt' u 1:2 w l ls 51,\
  'local_phit-45.txt' u 1:2 w p ls 53

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig6}|' < tmp.tex > fig6.tex
!epstopdf tmp.eps --outfile='fig6.pdf'
set output 'tmp.tex'
