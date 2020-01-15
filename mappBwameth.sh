#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   08.2018
#task:   mapping of bs reads to ref genome (bwameth) 
#***

#set chosen parameter
while getopts "o:t:r:g:e:c:" opt; do
  case $opt in
    r) readDir=$OPTARG   ;;
    o) outDir=$OPTARG   ;;
    t) tmpDir=$OPTARG   ;;
    g) genome=$OPTARG   ;;
    e) errorRates+=("$OPTARG");;
    c) conversionRates+=("$OPTARG");;
    *) echo 'error' >&2
       exit 1
  esac
done

if [ "" == "$readDir" ]; then
  echo "-r [directory of reads that should be mapped] is required"
  exit
fi

if [ "" == "$outDir" ]; then
  echo "-o [output directory for .sam files] is required"
  exit
fi

if [ "" == "$tmpDir" ]; then
  echo "-t [directory for temporary data] is required"
  exit
fi

if [ "" == "$genome" ]; then
  echo "-g [genome as fasta] is required"
  exit
fi

if [ "" == "$errorRates" ]; then
  echo "-e [errorRates] are required"
  exit
fi

if [ "" == "$conversionRates" ]; then
  echo "-c [conversionRates] are required"
  exit
fi

#mapping call
for conversionRate in "${conversionRates[@]}"
do
    for errorRate in "${errorRates[@]}"
    do
            mkdir -p ${outDir}/mm_0/
            mkdir -p ${tmpDir}/mm_0/
            sbatch --job-name=bwameth --partition standard,special --ntasks-per-node=1 --mem-per-cpu=10000 --time=72:00:00 \
            --error=${tmpDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.err \
            --output=${tmpDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.out \
            <<<"#!/bin/bash
                bwameth.py \
                   --reference ${genome} \
                   ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
                   ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
                   > ${outDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam"
            sleep 0.1     
    done
done


