#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2015      Fiete Winter                                       *
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
load 'BlGrRd.plt'
load 'labels.cfg'

################################################################################
set t epslatex size 13.0cm,5cm color colortext
set output 'tmp.tex';

unset key

# axes
set xrange [0:360]
set xtics 90 offset 0,0.5
set tics scale 0.75 out nomirror

set xlabel '\footnotesize $\sfsphphi_h$ / deg' offset 0,1

set format '\footnotesize $%g$'

# grid
set style line 102 lc rgb '#d6d7d9' lt 0 lw 1
set grid back ls 102

# legend
set key at graph 1.0, 1.15, 2 vertical maxrows 1 width -1 Left reverse samplen 3

# margins
set bmargin 2
set tmargin 2

################################################################################

# filename macro
get_filename_ps(phis,rs,rref,phit,rt, f) = \
  sprintf("ps_phi%1.1f_r%1.3f_rref%1.3f_phit%1.1f_rt%1.3f_Nset50_Nce50_f%.0f.txt", phis, rs, rref, phit, rt, f)

get_filename_pw(phis,rref,phit,rt, f) = \
  sprintf("pw_phi%1.1f_rref%1.3f_phit%1.1f_rt%1.3f_Nset50_Nce50_f%.0f.txt", phis, rref, phit, rt, f)

strToNum(s) = s + 0

# macro to select linestyle
get_linestyle(n) = sprintf('w l ls %d lw 1', (n-1)*7+1)

# temporal frequencies
freqs = "100 200 1000 2000"
f(n) = strToNum(word(freqs,n))
# angles for translatory shift
phits = "0 90"
N = words(phits)
phit(n) = strToNum(word(phits,n))
# distance for translatory shift
rt = 0.75
# reference radii
rrefs = "0.75 0"
rref(n) = strToNum(word(rrefs,n))

rdx(n,m,N) = ((n-1)+(m-1)*N)

################################################################################

set multiplot layout 1,2

### Plot 1

# y-axis on the left
set ylabel '\footnotesize $20 \log \left| P_\epsilon(\sfpos_h,\sfomega) \right| / \mathrm{dB} $' offset 4, 0
set yrange [-5:17.5]
set ytics 5 offset 0.5,0

set lmargin 5
set rmargin 3.5

plot for [idx=1:words(freqs)] \
    for [kdx=1:words(phits)] \
      for [jdx=1:words(rrefs)] \
        get_filename_pw(90, rref(jdx), phit(kdx), rt, f(idx) ) using 1:($2+rdx(jdx,kdx,N)*5) notitle w l ls (idx-1)*7+1 lw 1 axes x1y1

### Plot 2
set border 9 front ls 101

# y-axis on the left
unset ylabel
unset yrange
unset ytics

# y-axis on the right
set y2label '\footnotesize $\mathrm{Arg}\left( P_\epsilon(\sfpos_h,\sfomega) \right) / \mathrm{rad} $' offset -2, 0
set y2range [-0.5*pi:1.75*pi]
set y2tics ('$-\frac{\pi}{2}$' -0.5*pi, '$0$' 0, '$\frac{\pi}{2}$' 0.5*pi, '$\pi$' pi , '$\frac{3}{2}\pi$' 1.5*pi) offset 0.5,0

# some additional labels
set label 1 at screen 0.5, second 0.0 center '\footnotesize $\textcolor{red}{\sfdriving[modifier=cht]_m(\sfsphrref,\sfomega)}$'
set label 2 at screen 0.5, second 0.5*pi center '\footnotesize $\textcolor{red}{\sfdriving[modifier=cht]^\prime_m(0,\omega)}$'
set label 3 at screen 0.5, second pi center '\footnotesize $\textcolor{blue}{\sfdriving[modifier=cht]_m(\sfsphrref,\sfomega)}$'
set label 4 at screen 0.5, second 1.5*pi center '\footnotesize $\textcolor{blue}{\sfdriving[modifier=cht]^\prime_m(0,\omega)}$'

set lmargin 3.5
set rmargin 5

plot for [idx=1:words(freqs)] \
  for [kdx=1:words(phits)] \
    for [jdx=1:words(rrefs)] \
      get_filename_pw(90, rref(jdx), phit(kdx), rt, f(idx) ) using 1:($3+rdx(jdx,kdx,N)*0.5*pi) notitle w l ls (idx-1)*7+1 lw 1 axes x1y2,\
  for [idx=1:words(freqs)] \
    1e20 w l ls (idx-1)*7+1 lw 1 t sprintf("%d Hz", f(idx))

unset multiplot

################################################################################
set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig2}|' < tmp.tex > fig2.tex
!epstopdf tmp.eps --outfile='fig2.pdf'
