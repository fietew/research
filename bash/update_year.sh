#!/bin/bash

if [ $# -ne 1 ]
  then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

directory=$1

OLD='Copyright (c) [0-9]\{4\}.\{5\} Fiete Winter'
NEW='Copyright (c) 2013-2019 Fiete Winter'

grep -rli "$OLD" $directory/publications | xargs -i@ sed -i "s/$OLD/$NEW/" @
grep -rli "$OLD" $directory/tools | xargs -i@ sed -i "s/$OLD/$NEW/" @

