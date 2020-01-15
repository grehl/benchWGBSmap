#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   08.2018
#task:   mapping of bs reads to ref genome (bsseeker2) 
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
            sbatch --job-name=bsseeker2 --partition standard,special --ntasks-per-node=1 --mem-per-cpu=10000 --time=72:00:00 \
            --error=${tmpDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.err \
            --output=${tmpDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.out \
            <<<"#!/bin/bash
                python ../tools/BSseeker2/bs_seeker2-align.py \
                  -1 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
                  -2 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
                  -g ${genome} \
                  -m ${mismatch} \
                  -f sam \
                  --temp_dir=${tmpDir}/mm_${mismatch}/ \
                  -o ${outDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam"
            sleep 0.1     
        done
    done
done