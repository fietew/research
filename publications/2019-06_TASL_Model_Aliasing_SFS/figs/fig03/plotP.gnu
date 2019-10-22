filename = sprintf('eta%d_', eta)
plot filename.'P.dat' binary matrix with image,\
  filename.'array.txt' @array_continuous,\
  filename.'x0rays_active.txt' w p ls 101,\
  filename.'x0rays_inactive.txt' w p ls 103,\
  filename.'x0SPA.txt' w p ls 104,\
  filename.'raysSPA.txt' w l ls 104,\
  for [i=1:colrays] filename.'rays.txt' using 2*i-1:2*i w l ls 101
