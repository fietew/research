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
set terminal epslatex size 17cm,18cm color colortext
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
set cbtics scale 0

# plane wave
pwscale = 0.25
# circle
r = 0.5
set object 1 circle at 0,0 size r fc rgb '#404040'

# macro for getting filename of localization results
getfilenamePW(phi, bf, nsht, npw) = sprintf("../../matlab/results/plane%3.1f_%s_NSHT%d_continuous_R0.5_NPW%d.txt", phi, bf, nsht, npw)
getfilenamePS(r, phi, bf, db, nsht, npw) = sprintf("../../matlab/results/point%3.1f:%3.1f_%s_NSHT%d_continuous_db%3.1f_R0.5_NPW%d.txt", phi, r, bf, nsht, db, npw)
printMeanError(mu) = sprintf("$\\bar\\mu_\\phi = %2.2f^\\circ$", mu)
printNSHTTitle(nsht) = sprintf("$N_{\\mathrm{NSHT}} = %d$", nsht)

# =========================== PLOTTING =========================================

# === plot results ===
set multiplot layout 4,5

npw = 360
db = -20.0;

bf = 'MB'



set label 1 at graph 0.5, 0.9 center front tc ls 101
set label 3 at 0.0, -r-0.15 center front tc ls 101
set label 2 'Modal Beamformer' at graph 2.5, graph 1.0 center front tc ls 101

# plot row # 1
azimuth = 0
do for [n in "23 10 5 3"]{
  nsht = n + 0;

  set yrange [-180:180]
  stats getfilenamePW(azimuth, 'MB', nsht, npw) u 4 name "data" nooutput

  set yrange [ymin:ymax]
  set label 1 printNSHTTitle(nsht)
  set label 3 printMeanError(data_mean)
  plot getfilenamePW(azimuth, 'MB', nsht, npw) @localization_arrow, \
       set_plane_wave(0.0,0.75,pwscale, 0) @plane_wave
  unset label 2
}
unset label 1

set label 2 'DSB' at graph 0.5, graph 1.0 center front tc ls 101

set yrange [-180:180]
stats getfilenamePW(azimuth, 'DSB', 240, npw) u 4 name "data" nooutput

set yrange [ymin:ymax]
set label 3 printMeanError(data_mean)
plot getfilenamePW(azimuth, 'DSB', 240, npw) @localization_arrow, \
     set_plane_wave(0.0,0.75,pwscale, 0) @plane_wave
unset label 2

# plot row # 2
azimuth = 45
do for [n in "23 10 5 3"]{
  nsht = n + 0;

  set yrange [-180:180]
  stats getfilenamePW(azimuth, 'MB', nsht, npw) u 4 name "data" nooutput

  set yrange [ymin:ymax]
  set label 3 printMeanError(data_mean)
  plot getfilenamePW(azimuth, 'MB', nsht, npw) @localization_arrow, \
       set_plane_wave(0.0,1.0 + pwscale*sin(rad(-azimuth)),pwscale,-azimuth) @plane_wave
  unset label 2
}
unset label 1

set yrange [-180:180]
stats getfilenamePW(azimuth, 'DSB', 240, npw) u 4 name "data" nooutput

set yrange [ymin:ymax]
set label 3 printMeanError(data_mean)
plot getfilenamePW(azimuth, 'DSB', 240, npw) @localization_arrow, \
     set_plane_wave(0.0,1.0 + pwscale*sin(rad(-azimuth)),pwscale,-azimuth) @plane_wave

# plot row # 3

do for [azi in "0 30"]{
  azimuth = azi + 0
  srcx = sin(rad(azimuth))
  srcy = cos(rad(azimuth))
    do for [n in "23 10 5 3"]{
      nsht = n + 0;

      set yrange [-180:180]
      stats getfilenamePS(1.0,azimuth, 'MB', db, nsht, npw) u 4 name "data" nooutput

      set yrange [ymin:ymax]
      set label 3 printMeanError(data_mean)
      plot getfilenamePS(1.0,azimuth, 'MB', db, nsht, npw) @localization_arrow, \
           set_point_source(srcx,srcy) @point_source
      unset label 2
    }
  unset label 1
  unset object 1
  if (azi == "30") {
    set colorbox user origin graph 1.0, graph 0.0 size graph 0.15, graph 0.8
  }
  set label 3 ""
  set key off
  plot 1/0
  set object 1 circle at 0,0 size r fc rgb '#404040'
#    set yrange [-180:180]
#    stats getfilenamePS(1.0,azimuth, 'DSB', db, 240, npw) u 4 name "data"

#    set yrange [ymin:ymax]
#    set label 3 printMeanError(data_mean)
#    plot getfilenamePS(1.0,azimuth, 'DSB', db, 240, npw) @localization_arrow, \
#         set_point_source(srcx,srcy) @point_source
}


unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'
