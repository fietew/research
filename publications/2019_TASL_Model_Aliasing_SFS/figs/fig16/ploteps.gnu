plot sprintf('eps_f%d.dat', f) u 1:2:3 binary matrix with image,\
  'array.txt' @array_active,\
  sprintf('cont_f%d.txt', f) w l ls 101,\
  sprintf('RM_f%d.txt', f) w l ls 101 dt 3
