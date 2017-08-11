#!/usr/bin/gnuplot
#
# Plotting a vector field from a data file
#
# AUTHOR: Hagen Wierstorf
# MODIFICATIONS: Fiete Winter

reset

set macros
set loadpath '../../../../tools/gnuplot/'

load 'localization.cfg'
load 'noborder.cfg'

# latex
set terminal epslatex size 17cm,4.5cm color colortext
set output 'tmp.tex'

unset key
unset tics
unset colorbox
set border 0

set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

set size ratio -1

set style line 1 lc rgb 'orange' pt 2 ps 0.75 lw 1  # --- grey crosses

xmax = 0.55
xmin = -0.55
ymax = 1.10
ymin = -0.70

set xrange [xmin:xmax]
set cbrange [0:60]

# plane wave
pwscale = 0.25
# circle
r = 0.5
set object circle at 0,0 size r fc rgb '#404040'

# macro for getting filename of localization results
getfilenamePW(phi, bf, nsht, npw) = sprintf("../../matlab/results/plane%3.1f_%s_NSHT%d_continuous_R0.5_NPW%d.txt", phi, bf, nsht, npw)
getfilenamePS(r, phi, bf, db, nsht, npw) = sprintf("../../matlab/results/point%3.1f:%3.1f_%s_NSHT%d_continuous_db%3.1f_R0.5_NPW%d.txt", phi, r, bf, nsht, db, npw)
printNPWTitle(npw) = sprintf("$N_{\\mathrm{PW}} = %d$", npw)
printMeanError(mu) = sprintf("$\\bar\\mu_\\phi = %2.2f^\\circ$", mu)
printNSHTTitle(nsht) = sprintf("Modal Beamformer $N_{\\mathrm{SHT}} = %d$, $N_{\\mathrm{DOF}} = %d$", nsht, 2*nsht+1)

# =========================== PLOTTING =========================================

# === plot results ===
set multiplot layout 1,5

db = -20.0;  #

bf = 'MB'
nsht = 10
azimuth = 0.0
srcx = cos(rad(-azimuth+90))
srcy = sin(rad(-azimuth+90))

set label 1 at graph 0.5, 1.0 center front tc ls 101
set label 2 printNSHTTitle(nsht) at screen 0.5, graph 1.1 center front tc ls 101
set label 3 at 0.0, -r-0.15 center front tc ls 101

do for [npw in "10 15 18 24 360"] {
    tmp = npw + 0  # quick hack to convert strings to integers

    set yrange [-180:180]
    stats [-90:90] getfilenamePS(1.0, azimuth, 'MB', db, nsht, tmp) u 4 name "data" nooutput

    set yrange [ymin:ymax]
    set label 1 printNPWTitle(tmp)
    set label 3 printMeanError(data_mean)
    plot getfilenamePS(1.0, azimuth, 'MB', db, nsht, tmp) @localization_arrow, \
    set_point_source(srcx,srcy) @point_source

    unset label 2  # not necessary in each iteration
}

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
