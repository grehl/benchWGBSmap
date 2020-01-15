#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   08.2018
#task:   mapping of bs reads to ref genome (gsnap) 
#***

#set chosen parameter
while getopts "o:t:r:g:e:c:m:" opt; do
  case $opt in
    r) readDir=$OPTARG   ;;
    o) outDir=$OPTARG   ;;
    t) tmpDir=$OPTARG   ;;
    g) genome=$OPTARG   ;;
    e) errorRates+=("$OPTARG");;
    c) conversionRates+=("$OPTARG");;
    m) mismatches+=("$OPTARG");;
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

if [ "" == "$mismatches" ]; then
  echo "-m [mismatches] are required"
  exit
fi

#mapping call
for conversionRate in "${conversionRates[@]}"
do
    for errorRate in "${errorRates[@]}"
    do
        for mismatch in "${mismatches[@]}"
        do
            mkdir -p ${outDir}/mm_${mismatch}/
            mkdir -p ${tmpDir}/mm_${mismatch}/
            
            sbatch --job-name=gsnap --partition standard,special --cpus-per-task=4 --mem-per-cpu=20G --time=48:00:00 \
            --error=${tmpDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.err \
            --output=${tmpDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.out \
            <<<"#!/bin/bash
            ../tools/gmap-2019-06-10/bin/gsnap \
            --format=sam \
            --mode=cmet-stranded \
            -m ${mismatch} \
            --no-sam-headers \
            -t 4 \
            -D /scratch/user/ahgyg/benchmarkWGBS/data/genomes/ \
            -d ${genome} \
            ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
            ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
            > ${outDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam"
            sleep 0.1
        done
    done
done