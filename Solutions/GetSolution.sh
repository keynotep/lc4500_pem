#!/bin/bash
# Last update:  05/12/2017
#
# Adds all files in the named Solution folder to the
# named tar gzipped archive.
#
# Usage:
#
#   solutions/GetSolution.sh <SolutionName>
#
cur_dir=`pwd`

#SYNTAX QUESTIONABLE - DEBUG THIS!!!
#if [$1x == x] then
#exit

cd /opt/lc4500pem/data/LC4500
tar -czf ./$1.tar.gz $1 
mv $1.tar.gz ../archive/.

cd $cur_dir

