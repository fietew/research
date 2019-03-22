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
# recover positions infos
@pos_tmp
set format cb '$%g$'
# plot
plot filename.'_P.dat' binary matrix with image,\
  filename.'_circle.txt' w l ls 102,\
  filename.'_x0.txt' @array_active,\
  'cont.txt' w l ls 101
