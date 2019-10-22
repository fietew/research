#!/usr/bin/gnuplot
#
# FIGURE 3.7: Magnitude of a continuous signal P and the same signal sampled
# with a sampling frequency of f_s . The light blue lines indicate components
# occurring due to the sampling process. F_r describes an ideal reconstruction
# filter for the sampled signal.
#
# AUTHOR:   Hagen Wierstorf
# SOFTWARE: gnuplot 5.0 patchlevel 3

reset
set macros
set loadpath '../../../../tools/gnuplot/'

load 'border.cfg'
load 'standalone.cfg'

################################################################################
set terminal epslatex size 7cm,4.0cm color colortext standalone header intbeamer.footnotesize
set output 'fig2.tex'

unset key

# palette
load 'qualitative/Paired.plt'  # see gnuplot-colorbrewer
# border
set border 0
# labels
set label 1 '$|H(\sfpos,\sfomega)|$' at graph -0.05,0.925 front right
set label 2 '$\sfomega$' at graph 1,-0.1 front right
# margins
set lmargin 8
set rmargin 0.25
set tmargin 0.25
set bmargin 1.7
# variables
dL = 1.75
dR = 1.25
c = 1
i = {0.0,1.0} # imaginary unit
xmin = pi*c/(abs(dL-dR))
xmax = 2*pi*c/(abs(dL-dR))
Hmin = abs(1.0/dL-1.0/dR)
Hmax = (1.0/dL+1.0/dR)
xticscale = 0.025
# functions
H(x) = exp(-i*x*dL/c)/dL + exp(-i*x*dR/c)/dR
# arrows
set arrow from  0, 0.0 to graph 1.0,0 front size graph 0.03,20,60 filled ls 101
set arrow from  0, 0.0 to 0,graph 1.0 front size graph 0.03,20,60 filled ls 101
# x-axis
set xrange [0:5*xmin]
set samples 1000
set xtics ('$\frac{\pi}{|\Delta_{\tau}|}$' xmin,\
           '$\frac{2\pi}{|\Delta_{\tau}|}$' xmax) scale 1.5 offset 0,0.4
# y-axis
set yrange [0:2]
set ytics ('$\frac{1}{d_{\mathrm L}}+\frac{1}{d_{\mathrm R}}$' Hmax,\
           '$\left|\frac{1}{d_{\mathrm L}}-\frac{1}{d_{\mathrm R}}\right|$' Hmin) scale 1.5 offset 0.4,0

################################################################################

# plotting
plot abs(H(x)) w l ls 2 lw 5

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig2'
