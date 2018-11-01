plot sprintf('eps_f%d.dat', f) u 1:2:3 binary matrix with image,\
  'array.txt' @array_active,\
  sprintf('cont_f%d.txt', f) w l ls 101,\
  sprintf('Ral_f%d.txt', f) u 1:2:3 with circles ls 102,\
  'xfs.txt' u 1:2:4:($5*0.3) with vectors ls 103,\
  'xfs.txt' u 1:2 w p ls 103
