#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   08.2018
#task:   mapping of bs reads to ref genome (segemehl) 
#***

#set chosen parameter
while getopts "o:t:r:g:e:c:m:" opt; do
  case $opt in
    r) readDir=$OPTARG   ;;
    o) outDir=$OPTARG   ;;
    t) tmpDir=$OPTARG   ;;
    g) genomeDir=$OPTARG   ;;
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

if [ "" == "$genomeDir" ]; then
  echo "-g [genome directory] is required"
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
            sbatch --job-name=segemehl --partition standard --cpus-per-task=6 --mem-per-cpu=40G --time=14-00:00:00 \
            --error=${tmpDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.err \
            --output=${tmpDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.out \
            <<<"#!/bin/bash
                segemehl.x \
                    -i ${genomeDir}/Arabidopsis_thaliana.TAIR10.dna.toplevel.segemehl.ctidx \
                    -j ${genomeDir}/Arabidopsis_thaliana.TAIR10.dna.toplevel.segemehl.gaidx \
                    -d ${genomeDir}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
                    -q ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
                    -p ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
                    -o ${outDir}/mm_${mismatch}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam \
                    -F 1 \
                    --threads 6 \
                    -D ${mismatch}"
            sleep 0.1  
        done
    done
done

