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
set xrange [-60:60]
set xtics (-40,40) offset 0,0.5
set xlabel '$m$ / 1' offset 0,1

# colorbar
load 'colorbar.cfg'
load 'sequential/Blues.plt'
set cbrange [-60:20]
set cbtics 20 offset -0.5,0
set cbtics add ('\footnotesize $0$\,dB' 0)
unset colorbox

# axes
set size ratio 1
set format '\footnotesize $%g$'

# margins
set bmargin 2.0
set tmargin 0.5

# linestyles
set style line 51 lc rgb '#00ff00' lt 2 lw 4
set style line 54 lc rgb '#ff0000' lt 2 lw 4

################################################################################

#### plot 1 #####

# y-axis
set yrange [0:3000]
set ytics 500 offset 0.5,0
set ylabel '$f$ / Hz' offset 4.5,0

# margins
set lmargin 4.75
set rmargin 0.25

# plotting
plot 'spectrum_D_Mprime27_phit0.0_rt0.750.dat' binary matrix with image,\
  'spectrum_limits_Mprime27_phit0.0_rt0.750.txt' u 2:1 w l ls 51 ,\
  'spectrum_limits_Mprime27_phit0.0_rt0.750.txt' u 3:1 w l ls 51 ,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

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
plot 'spectrum_D_Mprime27_phit45.0_rt0.750.dat' binary matrix with image,\
  'spectrum_limits_Mprime27_phit45.0_rt0.750.txt' u 2:1 w l ls 51 ,\
  'spectrum_limits_Mprime27_phit45.0_rt0.750.txt' u 3:1 w l ls 51 ,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

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
plot 'spectrum_D_Mprime18_phit0.0_rt0.750.dat' binary matrix with image,\
  'spectrum_limits_Mprime18_phit0.0_rt0.750.txt' u 2:1 w l ls 51 ,\
  'spectrum_limits_Mprime18_phit0.0_rt0.750.txt' u 3:1 w l ls 51 ,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig3}|' < tmp.tex > fig3.tex
!epstopdf tmp.eps --outfile='fig3.pdf'
set output 'tmp.tex'

################################################################################

#### plot 4 #####

# y-axis
set yrange [0:3000]
set ytics format '\footnotesize $%g$'
set ylabel '$f$ / Hz' offset 4.5,0

# margins
set lmargin 4.75
set rmargin 0.25

# colorbar
unset colorbox

# plotting
plot 'spectrum_D_Mprime27_phit0.0_rt0.250.dat' binary matrix with image,\
  'spectrum_limits_Mprime27_phit0.0_rt0.250.txt' u 2:1 w l ls 51 ,\
  'spectrum_limits_Mprime27_phit0.0_rt0.250.txt' u 3:1 w l ls 51 ,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

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
plot 'spectrum_D_Mprime27_phit90.0_rt0.750.dat' binary matrix with image,\
  'spectrum_limits_Mprime27_phit90.0_rt0.750.txt' u 2:1 w l ls 51 ,\
  'spectrum_limits_Mprime27_phit90.0_rt0.750.txt' u 3:1 w l ls 51 ,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

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
plot 'spectrum_D_Mprime9_phit0.0_rt0.750.dat' binary matrix with image,\
  'spectrum_limits_Mprime9_phit0.0_rt0.750.txt' u 2:1 w l ls 51 ,\
  'spectrum_limits_Mprime9_phit0.0_rt0.750.txt' u 3:1 w l ls 51 ,\
  'spectrum_G0_limits.txt' u 2:1 w l ls 54 ,\
  'spectrum_G0_limits.txt' u 3:1 w l ls 54 ,\

# output
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig6}|' < tmp.tex > fig6.tex
!epstopdf tmp.eps --outfile='fig6.pdf'
set output 'tmp.tex'
