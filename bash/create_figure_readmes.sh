#!/bin/bash

if [ $# -ne 1 ]
  then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

directory=$1

# convert pdf to png and write README.md
find  $directory  -iname "fig.pdf"  -type f \
  -execdir sh -c 'pwd && echo {}' \; \
  -execdir sh -c 'convert -density 300 "$1" -resize ''800x800'' -quality 100 "${1%.pdf}.png"' sh {} \; \
  -execdir sh -c 'echo "![Fig]("${1%.pdf}.png")" > README.md' sh {} \; \

