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
load 'standalone.cfg'
load 'xyborder.cfg'

################################################################################
set t epslatex size 8.9cm,8.0cm color colortext standalone header ieeetran10pt.normal
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Paired.plt'
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 6.0
SPACING_VERTICAL = 4.1
OUTER_RATIO_L = 1.0
OUTER_RATIO_B = 0.4
# variables
Nspec = 8
offset = 40  # shift in dB
# x-axis
set xrange [0.1:20]
set logscale x 10
set xtics offset 0,0.5
set xlabel offset 0,1.5
LABEL_X = '\ft $f / \mathrm{kHz}$'
# y-axis
set yrange [-(Nspec-1)*offset-20:20]
set ytics 40 offset 0.5,0
set mytics 2
set ylabel  offset 4,0
LABEL_Y = '\ft normalised Magnitude / dB'
# grid
load 'grid.cfg'
set grid xtics ytics mxtics mytics
# labels
load 'labels.cfg'
set label 1 @label_northwest tc ls 2
set label 2 @label_northeast tc ls 6
set label 3 at graph 0.0, 1.12 left front tc ls 2
set label 4 at graph 1.0, 1.12 right front tc ls 6
do for [ii=1:Nspec] {
  set label 10+ii at graph 0.12, first (-ii+1.35)*offset left front
}
do for [ii=1:Nspec] {
  set label 20+ii at graph 0.05, first (-ii+1.35)*offset left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
}

################################################################################

# labels
set label 1  '\ft $\sfpos = [-0.085,0,0]^\mathrm{T}$~m'
set label 2  '\ft $\sfpos = [-0.585,0.75,0]^\mathrm{T}$~m'
set label 3  '\ft $\sfposc = [0,0,0]^\mathrm{T}$~m'
set label 4  '\ft $\sfposc = [-0.5,0.75,0]^\mathrm{T}$~m'

set label 11 '\ft WFS'
set label 12 '\ft HOA $M=27$, rect.'
set label 13 '\ft LWFS-SBL $N_{\mathrm{pw}}=1024$, $M=27$, max-$\mathbf r_E$'
set label 14 '\ft LWFS-SBL $N_{\mathrm{pw}}=1024$, $M=27$, rect.'
set label 15 '\ft LWFS-SBL $N_{\mathrm{pw}}=1024$, $M=11$, rect.'
set label 16 '\ft LWFS-SBL $N_{\mathrm{pw}}=64$, $M=27$, rect.'
set label 17 '\ft LWFS-VSS $N_{\mathrm{fs}}=1024$, $\sfcylr[subscript=local] = 30$ cm'
set label 18 '\ft LWFS-VSS $N_{\mathrm{fs}}=1024$, $\sfcylr[subscript=local] = 45$ cm'

# positioning
@pos_bottom_left
# plotting
plot for[ii=1:Nspec] 'data.txt' u ($1/1000):(column(2*ii+1)-(ii-1)*offset) w l ls 5 lw 4,\
    for[ii=1:Nspec] 'data.txt' u ($1/1000):(column(2*ii)-(ii-1)*offset) w l ls 2 lw 2

################################################################################
call 'pdflatex.gnu' 'fig'
