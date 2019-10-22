#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

# find figure directories
find $1 -iname "fig*" -type d | sort -n | while read -r directory ; do
    # 
    echo "Processing $directory"

    printf "" > $directory/README.md

    # Convert pdf to png
    find $directory -iname "fig*.pdf" -type f | sort -n | while read -r pdffile ; do
        pngfile=${pdffile%.pdf}.png
        pngfilelocal=`basename $pngfile`
        pdffilelocal=`basename $pdffile`        
        echo "Converting $pdffilelocal to $pngfilelocal and creating README.md"
        convert -density 300 "$pdffile" -resize "800x800" -quality 100 "$pngfile"
        printf "![Fig]($pngfilelocal)\n" >> $directory/README.md
    done

    # MATLAB files
    find $directory -iname "fig*.m" -type f | sort -n | while read -r mfile ; do
        mfilelocal=`basename $mfile`
        echo "Found $mfile, adding to README.md"
        firstline=`head -1 $mfile`
        firstline=${firstline#"% "}
        printf "\n$firstline\n" >> $directory/README.md
        printf "\nMatlab:\n\`\`\`Matlab\n>> ${mfilelocal%.m}\n\`\`\`\n" >> $directory/README.md
    done
    
    # LaTeX files
    find $directory -iname "fig*.tex" -type f | sort -n | while read -r texfile ; do
        texfilelocal=`basename $texfile`
        echo "Found $texfile, adding to README.md"
        firstline=`head -1 $texfile`
        firstline=${firstline#"% "}
        printf "\n$firstline\n" >> $directory/README.md
        printf "\nBash:\n\`\`\`Bash\n$ pdflatex $texfilelocal\n\`\`\`\n" >> $directory/README.md
    done

    # Gnuplot files
    find $directory -iname "fig*.gnu" -type f | sort -n | while read -r gnufile ; do
        echo "Found $gnufile, adding to README.md"
        gnufilelocal=`basename $gnufile`
        printf "\nBash:\n\`\`\`Bash\n$ gnuplot $gnufilelocal\n\`\`\`\n" >> $directory/README.md
    done
done

