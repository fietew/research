#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

# convert pdf to png and write README.md
find $1 -iname "fig*.pdf" -type f | while read -r pdffile ; do
    # 
    directory=`dirname $pdffile`
    echo "Processing $directory"

    # Convert pdf to png
    pngfile=${pdffile%.pdf}.png
    echo "Converting fig.pdf to fig.png and creating README.md"
    convert -density 300 "$pdffile" -resize "800x800" -quality 100 "$pngfile"
    pngfilelocal=`basename $pngfile`
    printf "![Fig]($pngfilelocal)\n" > $directory/README.md

    # MATLAB file
    mfile=${pdffile%.pdf}.m
    if [ -f $mfile ]; then
        echo "Found $mfile, adding to README.md"
        firstline=`head -1 $mfile`
        firstline=${firstline#"% "}
        printf "\n$firstline\n" >> $directory/README.md
        mfilelocal=`basename $mfile`
        printf "\nMatlab:\n\`\`\`Matlab\n>> ${mfilelocal%.m}\n\`\`\`\n" >> $directory/README.md
    fi
    
    # LaTeX file
    texfile=${pdffile%.pdf}.tex
    if [ -f $texfile ]; then
        echo "Found $texfile, adding to README.md"
        firstline=`head -1 $texfile`
        firstline=${firstline#"% "}
        printf "\n$firstline\n" >> $directory/README.md
        texfilelocal=`basename $texfile`
        printf "\nBash:\n\`\`\`Bash\n$ pdflatex $texfilelocal \n\`\`\`\n" >> $directory/README.md
    fi

    # Gnuplot file
    gnufile=${pdffile%.pdf}.gnu
    if [ -f $gnufile ]; then
        echo "Found $gnufile, adding to README.md"
        gnufilelocal=`basename $gnufile`
        printf "\nBash:\n\`\`\`Bash\n$ gnuplot $gnufilelocal\n\`\`\`\n" >> $directory/README.md
    fi
done

