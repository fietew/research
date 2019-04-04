#!/bin/bash

if [ $# -ne 2 ]
  then
    echo "Incorrect number of arguments ($# provided, 2 exspected)"
    exit 1
fi

bibfile=$1
directory=$2

grep "@.*{.*," publications.bib | grep -o -P "(?<={).*(?=,)" | while read -r line ; do
    echo "Processing $line"
    # https://www.ctan.org/pkg/bibtool
    bibtool -r bibtex.rsc -X $line$ $bibfile -o $directory/$line.txt
done
