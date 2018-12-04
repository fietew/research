#!/bin/bash

grep "@.*{.*," publications.bib | grep -o -P "(?<={).*(?=,)" | while read -r line ; do
    echo "Processing $line"
    # https://www.ctan.org/pkg/bibtool
    ./bibtool -r bibtex.rsc -X $line publications.bib -o doc/bibtex/$line.txt
done
