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

load 'localization.cfg'
load 'noborder.cfg'
load 'array.cfg'
load 'standalone.cfg'
load 'colorbar.cfg'

# latex
set terminal epslatex size @intbeamerwidth,6.5cm color colortext standalone header intbeamer
set output 'fig.tex'

unset key
unset tics
unset colorbox

set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

set size ratio -1

set style line 1 lc rgb 'orange' pt 2 ps 0.75 lw 1  # --- grey crosses
set style line 101 lc rgb '#808080' lt 1 lw 1

set xrange [-1.75:1.75]
set yrange [-1.55:2.65]

set cbrange [0:40]
set cbtics 10 nomirror out scale 0.75 offset -0.5

set palette defined (1 '#1F78B4', 2 '#1F78B4' )

set label 12 at 0.3,2.4 left front tc ls 101
set label 13 at 0.25,2.0 left front tc ls 101
set label 15 tc ls 101


print_error(x) = sprintf('\\scs \\shortstack[l]{sys. F.:\\\\$%2.1f^{\\circ}$}', x)
print_p(x) = x < 0.0001 ? sprintf('$<10^{-5}$',x) : sprintf('$%0.5f$',x)

print_RMSE_helper(x,p,alpha) = p < alpha ? sprintf('$\\mathbf{%2.1f}^{\\circ}$',x) : sprintf('$%2.1f^{\\circ}$',x)

print_RMSE(x,p,alpha) = sprintf('\\scs \\shortstack[l]{RMSE:\\\\%s}', print_RMSE_helper(x, p, alpha))
print_test(x) = sprintf('\\shortstack[l]{$p$-value:\\\\%s}', print_p(x) )

r_spread = 0.5

sx = 1.0/4
sy = 1.0/2

orix1 = 0*sx
orix2 = 1*sx
orix3 = 2*sx
orix4 = 3*sx

oriy1 = 1*sy
oriy2 = 0*sy

################################################################################

set multiplot

# set size sx,sy

#### plot 1 #####
set size sx,sy
set origin orix1, oriy1

set label 12 '\scs WFS'
set label 13 ''
set label 14 ''

filename = 'exp2_WFS_L56'
load 'plot.gnu'

#### plot 2 #####
set size sx,sy
set origin orix2, oriy1

set label 12 '\scs NFCHOA'
set label 13 '\scs $M = 300$'

filename = 'exp1_NFCHOA_L56_R300'
load 'plot.gnu'

#### plot 3 #####
set size sx,sy
set origin orix3, oriy1

set label 13 '\scs $M = 27$'

filename = 'exp2_NFCHOA_L56_R027'
load 'plot.gnu'

#### plot 4 #####
set size sx,sy
set origin orix4, oriy1

filename = 'exp1_NFCHOA_L56_R027'
load 'plot.gnu'

#### plot 5 #####
set size sx,sy
set origin orix1, oriy2

set label 13 '\scs $M = 13$'

filename = 'exp1_NFCHOA_L56_R013'
load 'plot.gnu'

#### plot 6 #####
set size sx,sy
set origin orix2, oriy2

set label 13 '\scs $M = 6$'

filename = 'exp1_NFCHOA_L56_R006'
load 'plot.gnu'

#### plot 7 #####
set size sx,sy
set origin orix3, oriy2

set label 12 '\scs LWFS'
set label 13 '\scs $M = 27$'

filename = 'exp2_LWFS-SBL_L56_R027'
load 'plot.gnu'

#### plot 8 #####
set label 13 '\scs $M = 3$'

set size sx,sy
set origin orix4, oriy2

filename = 'exp2_LWFS-SBL_L56_R003'
load 'plot.gnu'

unset colorbox

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
