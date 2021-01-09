#!/bin/bash

#ln -s ../raw/SAMPLEA1_R1.fastq CONTROL1_R1.fastq
#ln -s ../raw/SAMPLEA1_R2.fastq CONTROL1_R2.fastq
#ln -s ../raw/SAMPLEA2_R1.fastq CONTROL2_R1.fastq
#ln -s ../raw/SAMPLEA2_R2.fastq CONTROL2_R2.fastq
#ln -s ../raw/SAMPLEB1_R1.fastq TEST1_R1.fastq
#ln -s ../raw/SAMPLEB1_R2.fastq TEST1_R2.fastq
#ln -s ../raw/SAMPLEB2_R1.fastq TEST2_R1.fastq
#ln -s ../raw/SAMPLEB2_R2.fastq TEST2_R2.fastq

find ../raw -name 'SAMPLEA*.fastq' -exec bash -c 'infile=$0; outfile=`basename ${infile} | sed "s/SAMPLEA/CONTROL/"`; ln -s ${infile} ./${outfile};' {} \;
find ../raw -name 'SAMPLEB*.fastq' -exec bash -c 'infile=$0; outfile=`basename ${infile} | sed "s/SAMPLEB/TEST/"`; ln -s ${infile} ./${outfile};' {} \;
