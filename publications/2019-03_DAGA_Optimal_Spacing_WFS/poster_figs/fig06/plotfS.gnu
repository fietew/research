# plot
plot filename.'_fS.dat' binary matrix u 1:2:($3/1000) with image,\
  filename.'_x0.txt' @array_active,\
  filename.'_circle.txt' w l ls 102
