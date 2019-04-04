#!/bin/bash

if [ $# -ne 1 ]
  then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

directory=$1

# GNUPLOT
# replace old palettes with external platters from gnuplot-colorbrewer
grep -rl 'qualitative/Paired.plt' $directory | xargs sed -i 's/qualitative/Paired.plt/qualitative\/Paired.plt/g'
grep -rl 'qualitative/Set1.plt' $directory | xargs sed -i 's/qualitative/Set1.plt/qualitative\/Set1.plt/g'
grep -rl 'sequential/Blues.plt' $directory | xargs sed -i 's/sequential/Blues.plt/sequential\/Blues.plt/g'
grep -rl 'sequential/Reds.plt' $directory | xargs sed -i 's/sequential/Reds.plt/sequential\/Reds.plt/g'
grep -rl 'sequential/Greens.plt' $directory | xargs sed -i 's/sequential/Greens.plt/sequential\/Greens.plt/g'
# replace old custom palettes
grep -rl 'Moreland.plt' $directory | xargs sed -i 's/Moreland.plt/Moreland.plt/g'
grep -rl 'BlGrRd.plt' $directory | xargs sed -i 's/BlGrRd.plt/BlGrRd.plt/g'
# replace array plot calls
grep -rl "'array.txt'\s@array_active\sw\sp" $directory | xargs sed -i "s/'array.txt'\s@array_active\sw\sp/'array.txt' @array_active/g"

# execute gnuplot files
find  $directory  -iname "fig*.gnu"  -type f  -execdir bash -c "pwd && echo {} && gnuplot '{}'" \;

