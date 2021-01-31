#!/bin/bash

infile=$1

if [ ! ${infile} ]; then
        echo "Missing input fasta file"
        exit
fi

if [ ! -e ${infile} ]; then
        echo "Not found input fasta file (${infile})"
        exit
fi


sed 's/^>\(\S\+\).*/>\1/' ${infile}
