#!/bin/bash
# script to get runs matching specific parameter combinations 

# arg 1 is the input list of runs

baseName=$(echo $1 | cut -f1 -d.)
echo "baseName is $baseName"

if [ ! -d "RunsFromHD2" ]
then
#	mkdir RunsFromHD2
	echo hi
fi

if [ ! -d "$baseName" ]
then
#	mkdir RunsFromHD2/${baseName}
	echo hi
fi

RunIndexes=$(cut -f1 -d, $1 | tail +2 )
echo $RunIndexes
