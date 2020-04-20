# contour for aliasing frequency
set view map
unset surface
set contour base
set cntrparam points 2
set cntrparam linear
set format '%g'
set cntrparam level discrete (2000)
set table 'cont.txt'
splot filename.'_fS.dat' binary matrix w l
unset table
# plot
set format x ''
set format y '$%g$'
set format cb '$%g$'
plot filename.'_P.dat' binary matrix with image,\
  filename.'_x0.txt' @array_active,\
  filename.'_circle.txt' w l ls 102,\
  'cont.txt' w l ls 101
