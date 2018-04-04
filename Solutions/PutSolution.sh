#!/bin/bash
# Last update:  05/12/2017
#
# Extracts all files listed in the tar gzipped archive
# and places them in the solution folder named in the 
# archive.
#
# Usage:
#
#   /opt/lc4500pem/data/bin/PutSolution.sh <Root_TarGZ_Name> 
#
cur_dir=`pwd`

cd /opt/lc4500pem/data/LC4500
tar -xzf ../archive/$1.tar.gz 

cd $cur_dir

