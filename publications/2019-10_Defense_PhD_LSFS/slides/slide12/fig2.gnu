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
load 'mathematics.cfg'

################################################################################
set terminal epslatex size @intbeamerhalfwidth,7.25cm color colortext standalone header intbeamer.footnotesize
set output 'fig2.tex'

unset key

# palette
load 'qualitative/Paired.plt'  # see gnuplot-colorbrewer
# border
set border 0
# arrows
set arrow 1 from first 0, 0.0 to first 0, graph 1.2 front size graph 0.03,20,60 filled ls 101
set arrow 2 from graph 0.0, first 0 to graph 1.025, first 0 front size graph 0.03,20,60 filled ls 101
set arrow 3 front nohead ls 101
set arrow 4 front nohead ls 101
set arrow 5 front nohead ls 101
set arrow 6 front nohead ls 101
set arrow 7 front nohead ls 101
# y-axis
set yrange [0:1.2]
unset ytics
# x-axis
set samples 2**11
set xtics offset 0,0.5
# labels
set label 1 '$\omega$' at first -0.1, graph 1.1 front right
set label 2 '$k_x$' at graph 1.07, first 0 front center
set label 3 at first 0.3, 0.3 front center
set label 4 at -4,1.5 front left
set label 5 at graph 1.0,graph 0.6 front right
# margins
set lmargin 0.5
set rmargin 2.5
set tmargin 1.0
set bmargin 1.25
# styles
set style line 9 lc rgb 'black' lw 2
# variables
rg = 1.6
fg = 0.6
tg = 1.0/fg
fs = 1.0
ts = 1.0/fs
fr = 0.9
tr = 1.0/fr
SpecYmin = -0.2*fs
SpecYmax = 1.5*fs
SpecXmax = 1.75*fs
xticscale = 0.11
alpha = rad(0)

# functions
tri(x, r) = abs(x) < r ? abs(x) : 10000
triNan(x, r) = abs(x) < r ? abs(x) : NaN
G(x) = tri(x, 10000)
D(x) = tri(x*rg, fg*rg)

################################################################################
set multiplot layout 3,1 columnsfirst

set multiplot next
set multiplot next
set multiplot next

#### plot 1 #####
# x-axis
set xrange [-SpecXmax:SpecXmax]
set xtics (0) scale 0
# y-axis
set yrange [SpecYmin:SpecYmax]
# labels
unset label 5
# plotting
plot D(x) w filledcurves ls 2,\
  D(x) w l ls 9

#### plot 2 #####
# arrows
set arrow 3 from -fs,0 rto 0,graph -xticscale
set arrow 4 from  fs,0 rto 0,graph -xticscale
# x-axis
set xtics (0,\
  '${-\frac{2\pi}{\Delta_x}}$' -fs,\
  '$\frac{2\pi}{\Delta_x}$' fs) scale 0
# labels
set label 5 ''
# plotting
plot D(x) w filledcurves x2 ls 2,\
  for [eta=1:2] for [sign=-1:1:2] D(x - sign*eta*fs) w filledcurves x2 ls 1,\
  for [eta=1:2] for [sign=-1:1:2] max(D(x),D(x - sign*eta*fs)) w filledcurves x2 ls 2 fillstyle pattern 18 noborder,\
  D(x) w l ls 9,\
  for [eta=1:2] for [sign=-1:1:2] D(x - sign*eta*fs) w l ls 9

#### plot 3 #####
# labels
set label 5 ''
# plotting
plot G(x) w filledcurves x2 ls 5,\
  D(x) w filledcurves x2 ls 2,\
  for [eta=1:2] for [sign=-1:1:2] D(x - sign*eta*fs) w filledcurves x2 lc rgb 'grey',\
  for [eta=1:2] for [sign=-1:1:2] max(G(x),D(x - sign*eta*fs)) w filledcurves x2 ls 1,\
  for [eta=1:2] for [sign=-1:1:2] max(D(x),D(x - sign*eta*fs)) w filledcurves ls 2 fillstyle pattern 18,\
  D(x) w l ls 9,\
  for [eta=1:2] for [sign=-1:1:2] D(x - sign*eta*fs) w l ls 9,\
  G(x) w l ls 6 lw 2

# plot D(x) w filledcurves ls 1 lw 5,\
  for [eta=1:2] for [sign=-1:1:2] '+' using 1:(D($1 - sign*eta*fs)):(Hr($1)) lc rgb 'grey' lw 5,\
  for [eta=1:2] for [sign=-1:1:2] Dfilt(x, sign*eta*fs) w filledcurves x2 ls 3 lw 5,\
  D(x) w l ls 2 lw 5,\
  for [eta=1:2] for [sign=-1:1:2] DfiltNan(x, sign*eta*fs) w l ls 4 lw 5,\
  for [eta=1:2] for [sign=-1:1:2] DfiltNanInv(x, sign*eta*fs) w l lc rgb 'black' lw 5,\


################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig2'
