filename = sprintf('eta%d_', eta)
plot filename.'error.dat' binary matrix with image,\
  filename.'array.txt' @array_continuous,\
  filename.'x0SPA.txt' w p ls 104,\
  filename.'raysSPA.txt' w l ls 104
