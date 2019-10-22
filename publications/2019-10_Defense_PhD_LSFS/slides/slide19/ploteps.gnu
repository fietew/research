plot sprintf('eps_M%d_%s.dat', M, window) u 1:2:3 binary matrix with image,\
  'array.txt' @array_active,\
  sprintf('cont_fS_M%d.txt', M) w l ls 101,\
  sprintf('cont_fM_M%d.txt', M) w l ls 102
