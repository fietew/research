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

################################################################################
set t epslatex size 18.2cm,11cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

unset key

# color palette
load 'sequential/Greys.plt'
# labels
set label 1 at graph 0.0, 1.15 front left '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 2 at graph 0.1, 1.15 front left
set label 3 at graph 0.0, 1.05 front left
set label 5 at graph 0.27, 0.8  front left tc ls 2
set label 6 at graph 0.27, 0.9  front left tc ls 6 '\ft Listener at $[-0.5,0.75,0]^{\mathrm T}$ m'

set label 8 front center tc rgb '#808080'
set label 9 front center tc rgb '#808080'
# arrows
set arrow 1 from graph 0, first 0 to graph 1.0, first 0 nohead lc rgb '#00aa00' lw 3
set arrow 2 nohead lc rgb '#808080' lw 3
set arrow 3 nohead lc rgb '#808080' lw 3
# border
load 'border.cfg'
# axes
set format '\ft $%g$'
set tics scale 0.75 out nomirror
# x-axis
set xtics offset 0,0.25
set xlabel offset 0,3
# y-axis
set yrange [-0.05:1]
set mytics 2
LABEL_Y = 'perceived coloration'
# margins
set tmargin 2.5
set bmargin 2.5
set lmargin 0
set rmargin 0
# legend
set key autotitle columnhead
unset key
# grid
load 'grid.cfg'
set grid mytics ytics
# functions
col2xlabel(x) = sprintf('\ft  %s', strcol(x))
# style
load 'qualitative/Paired.plt'
set style fill transparent solid 1 # border -1
# variables
orix1 = 0.05
orix2 = 0.37
orix3 = 0.69
oriy1 = 0.52
oriy2 = 0.04
shift = 0.1

set style increment user
################################################################################
set multiplot

set size 0.31,0.5

#### Run 1 & 2 #####
LABEL_X = ''
# labels
set label 2 '\ft Noise stimulus'
set label 3 '\ft rect. window, $M=27$ (LWFS-SBL)'
set label 5 '\ft Listener at $[0,0,0]^{\mathrm T}$ m'
set label 8 at first 7, graph -0.2 '\scs LWFS-SBL with varying $N_{\mathrm{pw}}$'
# arrow
set arrow 2 from first 4.5, graph -0.15 to first 9.5, graph -0.15
# positioning
set origin orix1,oriy1
# x-axis
set xrange [1.5:9.5]
set xtics (\
  '\ft WFS' 2,\
  '\ft HOA' 3,\
  '\ft Stereo' 4,\
  '\ft $1024$' 5,\
  '\ft $512$' 6,\
  '\ft $256$' 7,\
  '\ft $128$' 8,\
  '\ft $64$' 9,\
  )
# y-axis
set ylabel offset 4,0 '\ft $\tilde \Delta^{c_1,\mathrm{Ref}}$'
set ytics 1 offset 0.5,-0.1 right
# plotting
plot 'apr/diffvsRef_set1.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     'apr/diffvsRef_set3.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 5 #####
# labels
set label 3 '\ft rect. window, $N_{\mathrm{pw}}=1024$ (LWFS-SBL)'
set label 5 ''
set label 8 at first 6, graph -0.2 '\scs LWFS-SBL with varying $M$'
# arrow
set arrow 2 from first 2.5, graph -0.15 to first 9.5, graph -0.15
# x-axis
set xtics (\
  '\ft WFS' 2,\
  '\ft $27$' 3,\
  '\ft $23$' 4,\
  '\ft $19$' 5,\
  '\ft $15$' 6,\
  '\ft $11$' 7,\
  '\ft $7$' 8,\
  '\ft $3$' 9,\
  )
# y-axis
set ylabel ''
set ytics -1,1
set format y ''
# positioning
set origin orix2,oriy1
# plotting
plot 'apr/diffvsRef_set5.txt' u 0:3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 6 #####
# labels
set label 3 '\ft $N_{\mathrm{pw}}=1024$ (LWFS-SBL)'
set label 8 at first 5, graph -0.25 '\scs LWFS-SBL with varying $M$ and $w_\mu$'
# arrow
set arrow 2 from first 2.5, graph -0.2 to first 9.5, graph -0.2
# positioning
set origin orix3,oriy1
# x-axis
set xrange [1.5:7.5]
set xtics offset 0,-0.05
set xtics (\
  '\ft WFS' 2,\
  '\ft \shortstack{$27$\\rect.}' 3,\
  '\ft \shortstack{$27$\\max-$\mathbf r_E$}' 4,\
  '\ft \shortstack{$23$\\max-$\mathbf r_E$}' 5,\
  '\ft \shortstack{$19$\\rect.}' 6,\
  '\ft \shortstack{$19$\\max-$\mathbf r_E$}' 7\
  )
# plotting
plot 'sep/diffvsRef_set5.txt' u 0:3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 7 & 8 #####
# labels
set label 2
set label 3 '\ft $N_{\mathrm{fs}}=1024$ (LWFS-VSS)'
set label 5 '\ft Listener at $[0,0,0]^{\mathrm T}$ m'
set label 8 at first 5, graph -0.2 '\scs LWFS-VSS with varying radius $\sfcylr[subscript=local]$ / cm'
# arrow
set arrow 2 from first 2.5, graph -0.15 to first 7.5, graph -0.15
# x-axis
set xtics offset 0,0.25
set xtics (\
  '\ft WFS' 2,\
  '\ft $15$' 3,\
  '\ft $22.5$' 4,\
  '\ft $30$' 5,\
  '\ft $37.5$' 6,\
  '\ft $45$' 7\
  )
# y-axis
set ylabel offset 4,0 '\ft $\tilde \Delta^{c_1,\mathrm{Ref}}$'
set ytics 1 offset 0.5,-0.1 right
set format y '\ft $%g$'
# positioning
set origin orix1,oriy2
# plotting
plot 'sep/diffvsRef_set1.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     'sep/diffvsRef_set2.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 3 & 4 #####
# labels
set label 2 '\ft Speech Stimulus'
set label 3 '\ft rect. window, $M=27$ (LWFS-SBL)'
set label 8 at first 7, graph -0.2 '\scs LWFS-SBL with varying $N_{\mathrm{pw}}$'
# arrow
set arrow 2 from first 4.5, graph -0.15 to first 9.5, graph -0.15
# positioning
set origin orix2,oriy2
# y-axis
set ylabel ''
set ytics -1,1
set format y ''
# x-axis
set xrange [1.5:9.5]
set xtics (\
  '\ft WFS' 2,\
  '\ft HOA' 3,\
  '\ft Stereo' 4,\
  '\ft $1024$' 5,\
  '\ft $512$' 6,\
  '\ft $256$' 7,\
  '\ft $128$' 8,\
  '\ft $64$' 9,\
  )
# plotting
plot 'apr/diffvsRef_set2.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     'apr/diffvsRef_set4.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 9 & 10 #####
# labels
set label 2 '\ft Noise stimulus'
set label 3 '\ft $N_{\mathrm{pw}} = N_{\mathrm{fs}} = 1024$ (LWFS-SBL, LWFS-VSS)'
set label 8 at first 4.5, graph -0.32 '\scs \shortstack{LWFS-VSS\\$\sfcylr[subscript=local]$ / cm}'
set label 9 at first 6.5, graph -0.32 '\scs \shortstack{LWFS-SBL\\$M$ and $w_\mu$}'
# arrow
set arrow 2 from first 3.7, graph -0.2 to first 5.3, graph -0.2
set arrow 3 from first 5.5, graph -0.2 to first 7.5, graph -0.2
# x-axis
set xrange [1.5:7.5]
set xtics offset 0,-0.05
set xtics (\
  '\ft WFS' 2,\
  '\ft HOA' 3,\
  '\ft $30$' 4,\
  '\ft $45$' 5,\
  '\ft \shortstack{$27$\\max-$\mathbf r_E$}' 6,\
  '\ft \shortstack{$19$\\rect.}' 7,\
  )
# positioning
set origin orix3,oriy2
# plotting
plot 'sep/diffvsRef_set3.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     'sep/diffvsRef_set4.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3,\

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
