#!/bin/bash

directory=publications/

# GNUPLOT
# replace old palettes with external platters from gnuplot-colorbrewer
grep -rl 'paired.pal' $directory | xargs sed -i 's/paired.pal/qualitative\/Paired.plt/g'
grep -rl 'Set1.pal' $directory | xargs sed -i 's/Set1.pal/qualitative\/Set1.plt/g'
grep -rl 'blues.pal' $directory | xargs sed -i 's/blues.pal/sequential\/Blues.plt/g'
grep -rl 'reds.pal' $directory | xargs sed -i 's/reds.pal/sequential\/Reds.plt/g'
grep -rl 'greens.pal' $directory | xargs sed -i 's/greens.pal/sequential\/Greens.plt/g'
# replace old custom palettes
grep -rl 'moreland.pal' $directory | xargs sed -i 's/moreland.pal/Moreland.plt/g'
grep -rl 'blgrrd.pal' $directory | xargs sed -i 's/blgrrd.pal/BlGrRd.plt/g'
# replace array plot calls
grep -rl "'array.txt'\s@array_active\sw\sp" $directory | xargs sed -i "s/'array.txt'\s@array_active\sw\sp/'array.txt' @array_active/g"

# execute gnuplot files
find  .  -iname "fig*.gnu"  -type f  -execdir bash -c "pwd && echo {} && gnuplot '{}'" \;
