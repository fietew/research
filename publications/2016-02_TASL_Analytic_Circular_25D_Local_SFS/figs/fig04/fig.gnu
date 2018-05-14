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
set t epslatex size 6cm,5.3cm color colortext
set output 'tmp.tex'

unset key # deactivate legend

# colorbar
load 'colorbar.cfg'

# axes
set size ratio 1
set format '\footnotesize $%g$'

# margins
set bmargin 2.0
set tmargin 0.5

# linestyles
set style line 51 lc rgb '#00ff00' lt 2 lw 4
set style line 53 lc rgb '#00ffff' lt 2 lw 4
set style line 54 lc rgb '#ff0000' lt 2 lw 4

################################################################################

#### plot 1 #####

# x-axis
set xrange [-60:60]
set xtics (-40,40) offset 0,0.5
set xlabel '$m$ / 1' offset 0,1

# y-axis
set yrange [0:3000]
set ytics 500 offset 0.5,0
set ylabel '$f$ / Hz' offset 4.5,0

# colorbar
load 'sequential/Blues.plt'
set cbrange [-60:20]
set cbtics 20 offset -0.5,0
set cbtics add ('\footnotesize $0$\,dB' 0)
unset colorbox

# margins
set lmargin 4.75
set rmargin 0.25

# plotting
plot 'spectrum_D.dat' binary matrix with image

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
set lmargin 0.25
set rmargin 4.75

# plotting
set colorbox @colorbar_east
plot 'spectrum_Ds.dat' binary matrix with image,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig2}|' < tmp.tex > fig2.tex
!epstopdf tmp.eps --outfile='fig2.pdf'
set output 'tmp.tex'

################################################################################

#### plot 3 #####

# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel '$x$ / m' offset 0,1

# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel '$y$ / m' offset 4.5,0

# axis
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

# colorbar
load 'Moreland.plt'
set cbrange [-1:1]
set cbtics 1

# margins
set lmargin 2.0
set rmargin 3.0

# plotting
plot 'sound_field.dat' binary matrix with image,\
  'array.txt' @array_active

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig3}|' < tmp.tex > fig3.tex
!epstopdf tmp.eps --outfile='fig3.pdf'
set output 'tmp.tex'

################################################################################

#### plot 4 #####

# x-axis
set xrange [-60:60]
set xtics (-40,40) offset 0,0.5
set xlabel '$m$ / 1' offset 0,1

# y-axis
set yrange [0:3000]
set ytics 500 offset 0.5,0
set ylabel '$f$ / Hz' offset 4.5,0

# margins
set lmargin 4.75
set rmargin 0.25

# colorbar
load 'sequential/Blues.plt'
set cbrange [-60:20]
set cbtics 20 offset -0.5,0
set cbtics add ('\footnotesize $0$\,dB' 0)
unset colorbox

# plotting
plot 'spectrum_D_bandlimit.dat' binary matrix with image

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
set lmargin 0.25
set rmargin 4.75

# plotting
set colorbox @colorbar_east
plot 'spectrum_Ds_bandlimit.dat' binary matrix with image,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig5}|' < tmp.tex > fig5.tex
!epstopdf tmp.eps --outfile='fig5.pdf'
set output 'tmp.tex'

################################################################################

#### plot 6 #####

# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel '$x$ / m' offset 0,1

# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel '$y$ / m' offset 4.5,0

# axis
set format '\footnotesize $%g$'
set tics scale 0.75 out nomirror

# colorbar
load 'Moreland.plt'
set cbrange [-1:1]
set cbtics 1

# margins
set lmargin 2.0
set rmargin 3.0

# plotting
plot 'sound_field_bandlimit.dat' binary matrix with image,\
  'rM.txt' u 1:2 w l ls 51,\
  'Xal.txt' u 1:2 w l ls 53,\
  'Xal.txt' u 3:4 w l ls 53,\
  'array.txt' @array_active

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig6}|' < tmp.tex > fig6.tex
!epstopdf tmp.eps --outfile='fig6.pdf'
set output 'tmp.tex'
