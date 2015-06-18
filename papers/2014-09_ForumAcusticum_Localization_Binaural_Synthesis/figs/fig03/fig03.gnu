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
set terminal epslatex size 17cm,5cm color colortext
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

set xrange [-0.65:0.65]
set yrange [-0.85:1.15]
set cbrange [0:40]



# plane wave
pwscale = 0.25
# circle
r = 0.5
set object circle at 0,0 size r fc rgb '#404040'

# macro for getting filename of localization results
getfilenamePW(phi, bf, nsht, npw) = sprintf("../../matlab/results/plane%3.1f_%s_NSHT%d_continuous_R0.5_NPW%d.txt", phi, bf, nsht, npw)
getfilenamePS(r, phi, bf, db, nsht, npw) = sprintf("../../matlab/results/point%3.1f:%3.1f_%s_NSHT%d_continuous_db%3.1f_R0.5_NPW%d.txt", phi, r, bf, nsht, db, npw)

# =========================== PLOTTING =========================================

set multiplot layout 1,4

# === experimental layout ===
arrow_mid = 0.0
arrow_x = 0.6
arrow_y = -r-0.10

set arrow 21 from -r,arrow_y to r,arrow_y heads size 0.05,90,0 front ls 101 lw 2
set label 21 '\small $2R$' at 0.0,arrow_y-0.1 front center tc ls 101
plot getfilenamePW(0, 'MB', 23, 360) w p ls 1, \
     set_plane_wave(0.0,1,pwscale, 0) @plane_wave
unset arrow 21
unset label 21



set arrow 21 from -arrow_mid,arrow_y to arrow_x,arrow_y front ls 101 lw 3
set arrow 31 from -arrow_x,arrow_y to arrow_mid,arrow_y size 0.05,90 front ls 101 lw 3
set arrow 41 from arrow_y,arrow_mid to arrow_y,arrow_x front ls 101 lw 3
set arrow 51 from arrow_y,-arrow_x to arrow_y,arrow_mid size 0.05,90 front ls 101 lw 3

set label 21 '\small $x$' at arrow_x,arrow_y-0.1 front center tc ls 101
set label 31 '\small $0$' at arrow_mid,arrow_y-0.15 front center tc ls 101
set label 41 '\small $y$' at arrow_y-0.1,arrow_x back center tc ls 101
set label 51 '\small $0$' at arrow_y-0.1,arrow_mid back center tc ls 101

plot getfilenamePW(0, 'MB', 23, 360)  w p ls 1, \
     set_plane_wave(0.0,1.0 + pwscale*sin(rad(-45)),pwscale,-45)  @plane_wave
unset arrow 41
unset arrow 51
unset label 41
unset label 51

set arrow 41 from -arrow_y-0.025 ,0.3 to -arrow_y-0.025,0.4 heads size 0.025,90,0 front ls 101
set label 41 '\small $\Delta_y$' at 0.7,0.33 front center tc ls 101
set arrow 31 from -0.3,arrow_y+0.025  to -0.4,arrow_y+0.025 heads size 0.025,90,0 front ls 101
set label 31 '\small $\Delta_x$' at -0.35,arrow_y-0.1 front center tc ls 101
set arrow 21 from 0.0,0.0 to 0.0,1.0 heads size 0.05,90,0 front ls 101
set label 21 '\small $r_s$=1m' at 0.25,0.65 front center tc ls 101
plot getfilenamePW(0, 'MB', 23, 360)  w p ls 1, \
     set_point_source(0.0,1.0) @point_source
unset arrow 41
unset label 41
unset arrow 31
unset label 31

set arrow 21 from 0.0,0.0 to 0.5,0.866 heads size 0.05,90,0 front ls 101
set label 21 at 0.1,0.65
plot getfilenamePW(0, 'MB', 23, 360)  w p ls 1, \
     set_point_source(0.5,0.866) @point_source
unset arrow 21
unset label 21

unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig03/fig03}|' < tmp.tex > fig03.tex
!epstopdf tmp.eps --outfile='fig03.pdf'
