#!/bin/bash

# first arg is directory to work on

# neutral runs:
orig=$(pwd)

cd $1

dirs=$(ls)

for i in $dirs
do
    rm ${i}/MutationLog.tx*
    rm ${i}/LociRemoved.tx*
    #rm ${i}/LDneutSitesDiff.tx*
    rm ${i}/Mutations.m*
done

cd $orig
