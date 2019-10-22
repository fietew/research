plot sprintf('P_M%d_f%d.dat', M, f) binary matrix with image,\
  'array.txt' @array_active,\
  sprintf('cont_fS_M%d_f%d.txt', M, f) w l ls 101,\
  sprintf('cont_fM_M%d_f%d.txt', M, f) w l ls 102,\
  'xref.txt' w p ls 103
