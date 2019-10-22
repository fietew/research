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
set terminal epslatex size @intbeamerwidth,7.0cm color colortext standalone header intbeamer.footnotesize
set output 'fig.tex'

unset key

# palette
load 'qualitative/Paired.plt'  # see gnuplot-colorbrewer
# border
set border 0
# arrows
set arrow 1 from first 0, 0.0 to first 0, graph 1.0 front size graph 0.03,20,60 filled ls 101
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
set label 1 at first -0.1, graph 0.95 front right
set label 2 at graph 1.05, first 0 front center
set label 3 at first 0.3, 0.3 front center
set label 4 at -4,1.5 front left
set label 5 at graph 1.0,graph 0.6 front right
# margins
set lmargin 0.5
set rmargin 2.5
set tmargin 0.25
set bmargin 1.25
# variables
fg = 0.625
tg = 1.0/fg
fs = 1.0
ts = 1.0/fs
fr = 0.9
tr = 1.0/fr
TimeYmin = -0.2/fg
TimeYmax = 1.2/fg
TimeXmin = -tg - 0.5
TimeXmax = 2*tg + 0.5
SpecYmin = -0.2/fg
SpecYmax = 1.2/fg
SpecXmax = 1.9*fs
xticscale = 0.11
# functions
rect(x) = abs(x) < 0.5 ? 1 : 0
rectNaN(x) = abs(x) <= 0.5 ? 1 : NaN
rectNaNInv(x) = abs(x) >= 0.5 ? 1 : NaN
tri(x) = abs(x) <= 1 ? 1-abs(x) : NaN
sinc(x) = x == 0 ? 1 : sin(pi*x)/(pi*x)
a(x) = (sinc(fg*x))**2
A(x) = tg*tri(x*tg)
hr(x) = 2*fr*ts*sinc(2*fr*x)
Hr(x) = ts*rect(tr*x/2)
HrNaN(x) = ts*rectNaN(tr*x/2)
HrNaNInv(x) = ts*rectNaNInv(tr*x/2)
arecons(x, nb, nt) = hr(x-nt*ts)*a(nt*ts) + ( nb == nt ? 0 : arecons(x, nb, nt-1))

################################################################################
set multiplot layout 3,2 columnsfirst

#### plot 1 #####
# arrows
set arrow 3 from tg,0 rto 0,graph -xticscale
set arrow 4 from -tg,0 rto 0,graph -xticscale
set arrow 5 from 2*tg,0 rto 0,graph -xticscale
set arrow 7 from 0,0 rto 0,graph -xticscale
# y-axis
set yrange [TimeYmin:TimeYmax]
# x-axis
set xrange [TimeXmin:TimeXmax]
set xtics (0,\
  '${-\frac{1}{f_\text{g}}}$' -tg,\
  '$\frac{1}{f_\text{g}}$' tg,\
  '$\frac{2}{f_\text{g}}$' 2*tg) scale 0
# labels
set label 1 '$x(t)$'
set label 2 '$t$'
set label 5 'kontinuierliches Signal'
# plotting
plot a(x) w l ls 2 lw 5

#### plot 2 #####
# arrows
set arrow 3 from ts,0 rto 0,graph -xticscale
set arrow 4 from -ts,0 rto 0,graph -xticscale
set arrow 5 from 2*ts,0 rto 0,graph -xticscale
set arrow 6 from 3*ts,0 rto 0,graph -xticscale
# x-axis
set xtics (0,\
  '$-T_\text{s}$' -ts,\
  '$T_\text{s}$' ts,\
  '$2 T_\text{s}$' 2*ts,\
  '$3 T_\text{s}$' 3*ts) scale 0
# labels
set label 1 ''
set label 5 'diskretisiertes Signal'
# plotting
plot a(x) w l lc rgb 'gray' lw 5,\
  for [n=-5:5] "<echo 'NaN'" using (n*ts):(a(n*ts)) w impulses ls 2 lw 5,\
  for [n=-5:5] "<echo 'NaN'" using (n*ts):(a(n*ts)) w points ls 2 pt 9

#### plot 3 #####
# labels
set label 5 'rekonstruiertes Signal'
# plotting
plot a(x) w l lc rgb 'gray' lw 5,\
  for [n=-5:5] "<echo 'NaN'" using (n*ts):(a(n*ts)) w points ls 1 pt 7,\
  arecons(x, -20, 20) w l ls 2 lw 5


#### plot 4 #####
# arrows
set arrow 3 from -fg,0 rto 0,graph -xticscale
set arrow 4 from  fg,0 rto 0,graph -xticscale
set arrow 5 from NaN,NaN to NaN, NaN
set arrow 6 from NaN,NaN to NaN, NaN
# x-axis
set xrange [-SpecXmax:SpecXmax]
set xtics (0,\
           '$-\omega_\text{g}$' -fg,\
           '$\omega_\text{g}$' fg) scale 0
# y-axis
set yrange [SpecYmin:SpecYmax]
# labels
set label 1 '$|X(\omega)|$'
set label 2 '$\omega$'
unset label 5
# plotting
plot A(x) w l ls 2 lw 5

#### plot 5 #####
# arrows
set arrow 3 from -fs,0 rto 0,graph -xticscale
set arrow 4 from -fs/2.0,0 rto 0,graph -xticscale
set arrow 5 from  fs/2.0,0 rto 0,graph -xticscale
set arrow 6 from  fs,0 rto 0,graph -xticscale
# x-axis
set xtics ('${-\omega_\text{s}}$' -fs,\
           '${-\frac{\omega_\text{s}}{2}}$' -fs/2,\
           '$\frac{\omega_\text{s}}{2}$' fs/2,\
           '$\omega_\text{s}$' fs) scale 0
# labels
set label 1 ''
set label 5 ''
# plotting
plot for [eta=1:2] for [sign=-1:1:2] fs*A(x - sign*eta*fs) w l ls 1 lw 5,\
  fs*A(x) w l ls 2 lw 5

#### plot 6 #####
# arrows
set arrow 3 from -fr,0 rto 0,graph -xticscale
set arrow 4 from  fr,0 rto 0,graph -xticscale
set arrow 5 from NaN,NaN to NaN, NaN
set arrow 6 from NaN,NaN to NaN, NaN
# x-axis
set xtics ('${-\omega_\text{r}}$' -fr,\
           '$\omega_\text{r}$' fr) scale 0
# labels
set label 5 ''
# plotting
plot for [eta=1:2] for [sign=-1:1:2] fs*A(x - sign*eta*fs)*HrNaN(x) w l ls 1 lw 5,\
  for [eta=1:2] for [sign=-1:1:2] fs*A(x - sign*eta*fs)*HrNaNInv(x) w l lc rgb 'grey' lw 5,\
  fs*A(x) w l ls 2 lw 5,\
  Hr(x) w l ls 5 lw 5

################################################################################
unset multiplot

call 'pdflatex.gnu' 'fig'
