#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   08.2018
#task:   generate simulated bisulfite reads 
#***

#parse input parameter
while getopts "o:t:n:e:c:g:" opt; do
  case $opt in
    o) outDir=$OPTARG   ;;
    t) tmpDir=$OPTARG   ;;
    n) numReads=$OPTARG   ;;
    e) errorRate=$OPTARG   ;;
    c) conversionRate=$OPTARG   ;;
    g) genomeDir=$OPTARG   ;;
    *) echo 'error' >&2
       exit 1
  esac
done

if [ "" == "$outDir" ]; then
  echo "-o [output directory] is required"
  exit
fi

if [ "" == "$tmpDir" ]; then
  echo "-t [directory for temporary data] is required"
  exit
fi

if [ "" == "$numReads" ]; then
  echo "-n [number of Reads that should be generated] is required"
  exit
fi

if [ "" == "$errorRate" ]; then
  echo "-e [errorrate] is required"
  exit
fi

if [ "" == "$conversionRate" ]; then
  echo "-c [conversionrate] is required"
  exit
fi

mkdir -p $outDir

#generate readfile in tmp folder
mkdir -p ${tmpDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}/
(cd ${tmpDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}/ && perl ../../../../tools/sherman_0.1.7/Sherman.pl -l 150 -n ${numReads} -genome_folder ${genomeDir} -pe -I 199 -X 400 --conversion_rate ${conversionRate} --error_rate ${errorRate})

#mv files from tmp to data folder
mv ${tmpDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}/simulated_1.fastq ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq
mv ${tmpDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}/simulated_2.fastq ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq

#remove _Rx from read ID
sed -i 's/_R1$//' ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq
sed -i 's/_R2$//' ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq        