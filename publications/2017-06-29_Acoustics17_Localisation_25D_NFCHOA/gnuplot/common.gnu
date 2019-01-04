#!/usr/bin/gnuplot

# gnuplot script containing configurations for IC-weighted ITD/ILD Plots
#
# Usage: load 'common.gnu'

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

################################################################################
# set t postscript eps size 18cm,30cm noenhanced color font 'Helvetica,10'
# set output 'tmp.eps'

set t epslatex size 11cm,7cm color colortext header "\\newcommand{\\ft}[0]{\\footnotesize}"
set output 'tmp.tex'

# variables
cfHz=''  # Gammatone Center Frequencies
stats 'fc.txt' u 1:(cfHz = cfHz.sprintf('%4.0f ',$1)) nooutput
itd_idx_min = 1
itd_idx_max = 16
ild_idx_min = itd_idx_max+1
ild_idx_max = words(cfHz)
# functions
kilo(x) = (x > 1000) ? sprintf("%.01fk", (int((x+0.0)/100+0.5)+0.0)/10) : x
# borders
load 'xyborder.cfg'
# legend
unset key
# y-axis
set yrange [0:46]
# x-axis (ITD)
set xrange [-0.6:0.6]
# x2-axis (ILD)
set x2range [-30:30]
# colorbar
unset colorbox
set cbrange [0:1]
# general style
set style fill transparent solid 0.75 border
set clip two
# labels
load 'labels.cfg'
set label 1 at graph 1.0, 0.9 right
set label 2 at graph 1.05, 0.0 left rotate by 90
# arrow
set arrow from first 0, graph 0 to first 0, graph 1.0 front nohead ls 101 dt 2 lw 2
# macros
top = \
  "set tmargin 1.5; \
   set bmargin 0; \
   set border 4; \
   unset xtics; \
   unset xlabel; \
   set x2tics -25,10,25 offset 0,-1.75 nomirror in scale 0.75; \
   set x2label '\\ft ILD / dB' offset 0,-1.75; \\
   set format x2 '\\ft $%g$'"

bot = \
  "set tmargin 0; \
   set bmargin 1.5; \
   set border 1; \
   set xtics 0.5 offset 0,0.5 nomirror out scale 0.75; \
   set xlabel '\\ft ITD / ms' offset 0,1; \
   set format x '\\ft $%g$'; \
   unset x2tics; \
   unset x2label;"

lef = \
  "set lmargin 4; \
   set rmargin 0; \
   set ylabel '\\ft center frequency / Hz' offset 6,0; \
   set ytics offset 1,0 nomirror out scale 0.75 \
    ( '\\ft '.kilo(word(cfHz, itd_idx_min)) itd_idx_min\
    , '\\ft '.kilo(word(cfHz, itd_idx_max)) itd_idx_max\
    , '\\ft '.kilo(word(cfHz, ild_idx_max)) ild_idx_max\
    )"

rig = \
  "set lmargin 2; \
   set rmargin 2; \
   unset ytics; \
   unset ylabel"




