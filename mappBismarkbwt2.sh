

#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   08.2018
#task:   mapping of bs reads to ref genome (bismark) 
#***

# test on cluster:
# sbatch --ntasks-per-node=4 --mem-per-cpu=20000 --time=0:30:00 ./mappBismark.sh -g ../data/genomes/glycineMaxV2/ -t ../data/tmp/mappedMiniTestBsReads/bismark/ -r ../data/simulatedMiniTestBsReads/ -o ../data/mappedMiniTestBsReads/bismark/

#parse input parameter
while getopts "o:t:r:g:e:c:" opt; do
  case $opt in
    r) readDir=$OPTARG   ;;
    o) outDir=$OPTARG   ;;
    t) tmpDir=$OPTARG   ;;
    g) genomeDir=$OPTARG   ;;
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

if [ "" == "$genomeDir" ]; then
  echo "-g [directory for genome] is required"
  exit
fi

if [ "" == "$errorRates" ]; then
  echo "-e [errorrates] are required"
  exit
fi

if [ "" == "$conversionRates" ]; then
  echo "-c [conversionrates] are required"
  exit
fi

#mapping call
for conversionRate in "${conversionRates[@]}"
do
    for errorRate in "${errorRates[@]}"
    do
            mkdir -p ${outDir}/mm_0/
            mkdir -p ${tmpDir}/mm_0/
            sbatch --job-name=bismarkbwt2 --partition standard,special --ntasks-per-node=1 --mem-per-cpu=10000 --time=72:00:00 \
            --error=${tmpDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.err \
            --output=${tmpDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.out \
            <<<"#!/bin/bash
                bismark --bowtie2 ${genomeDir} \
                    -1 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
                    -2 ${readDir}simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
                    --un \
                    --ambiguous \
                    --sam \
                    --temp_dir ${tmpDir}/mm_0/ \
                    -o ${outDir}/mm_0 \

                    mv  ${outDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1_bismark_bt2_PE_report.txt \
                        ${outDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_report.txt

                    mv  ${outDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1_bismark_bt2_pe.sam \
                        ${outDir}/mm_0/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam"
            sleep 0.1
    done
done