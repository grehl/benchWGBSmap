#!/bin/bash

#***
#author: Marc-Christoph Wagner, Claudius Grehl
#date:   09.2018
#task:   benchmark script
#***

#set chosen parameter
errorRate=(0)
conversionRate=(90)
mismatch=(0)
runs=(1 2 3 4)

MAPPERLIST=(bismark)


genomeDir=../data/genomes/glycineMaxV2/
genomeGsnap=glycineMaxV2/Glycine_max.Glycine_max_v2.0.dna.toplevel.gmap.index/
genome=Glycine_max.Glycine_max_v2.0.dna.toplevel


readDir=../data/gly/simulatedCov5BsReads/
outDir=../data/gly/tmp_bra/benchmarkCov5
benchDir=../results/gly/benchmarkCov5

#create tmp folder
#mkdir -p ${benchDir}
#mkdir -p ${outDir}

#result folder
#for mapper in "${MAPPERLIST[@]}"
#do
#    mkdir -p ${benchDir}/${mapper}
#done


echo "Benchmark: bwameth"
#mapper=bwameth
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    bwameth.py --threads 1 \
#        --reference $genomeDir${genome}.fa \
#        ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#        ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#        > ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam &
#done
#wait

echo "Benchmark: bismarkbwt2"
#mapper=bismarkbwt2
#bismark_genome_preparation --bowtie2 ${genomeDir}/
#wait
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    bismark --bowtie2 ${genomeDir} \
#            -1 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#            -2 ${readDir}simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#            --sam \
#            --temp_dir ${outDir}/ \
#            -o ${outDir} &
#done
#wait

echo "Benchmark: bismark"
mapper=bismark
#bismark_genome_preparation --bowtie1 ${genomeDir}/
#wait
for run in "${runs[@]}" 
do
    #start benchmarking
    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
    bismark --bowtie1 ${genomeDir} \
            -n ${mismatch} \
            -1 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
            -2 ${readDir}simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
            --sam \
            --temp_dir ${outDir}/ \
            -o ${outDir} &
done 
wait

echo "Benchmark: bsmap"
#mapper=bsmap
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    bsmap   -a ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#            -b ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#            -d ${genomeDir}/${genome}.fa \
#            -o ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_${run}.sam \
#            -p 1 \
#            -v ${mismatch} &
#done
#wait

echo "Benchmark: bsseeker2"
#mapper=bsseeker2
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    python ../tools/BSseeker2/bs_seeker2-align.py \
#            -1 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#            -2 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#            -g ${genomeDir}/${genome}.fa \
#            -m ${mismatch} \
#            -f sam \
#            --temp_dir=${outDir} \
#            -o ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_${run}.sam &
#done
#wait

echo "Benchmark: gem3"
#mapper=gem3
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv   
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    ../tools/gem3-mapper/bin/gem-mapper  \
#        -1 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#        -2 ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#        -I ${genomeDir}/${genome}.gem \
#        -t 1 \
#        -e ${mismatch} \
#        -o ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_${run}.sam &
#done
#wait

echo "Benchmark: gsnap"
#mapper=gsnap
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    ../tools/gmap-2019-06-10/bin/gsnap \
#        --format=sam \
#        --mode=cmet-stranded \
#        -m ${mismatch} \
#        --no-sam-headers \
#        -D /scratch/user/ahgyg/benchmarkWGBS/data/genomes \
#        -d ${genomeGsnap} \
#        -t 1 \
#        ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#        ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#        > ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_${run}.sam &
#done
#wait

echo "Benchmark: segemehl"
#mapper=segemehl
#for run in "${runs[@]}" 
#do
#    #start benchmarking
#    echo -e "mem\tRSS\telapsed\tcpu.sys\t.user" > ${benchDir}/${mapper}/${run}.csv    
#    /usr/bin/time -f "%K\t%M\t%E\t%S\t%U" -o ${benchDir}/${mapper}/${run}.csv -a \
#    segemehl.x \
#        -i ${genomeDir}/Glycine_max.Glycine_max_v2.0.dna.toplevel.segemehl.ctidx \
#        -j ${genomeDir}/Glycine_max.Glycine_max_v2.0.dna.toplevel.segemehl.gaidx \
#        -d ${genomeDir}/Glycine_max.Glycine_max_v2.0.dna.toplevel.fa \
#        -q ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_1.fastq \
#        -p ${readDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}_2.fastq \
#        -o ${outDir}/simulatedConvRate${conversionRate}ErrRate${errorRate//./}.sam \
#        -F 1 \
#        --threads 1 \
#        -D ${mismatch} &
#done
#wait

echo "Combine all files"
#
MAPPERLIST=(bismark bsmap bsseeker2 gem3 gsnap bwameth bismarkbwt2 segemehl)

echo -e "mem\tRSS\telapsed\tcpu.sys\t.user\trun\tmapper" > ${benchDir}/combinedBenchmarkCov5.csv
for mapper in "${MAPPERLIST[@]}"
do    
    for run in "${runs[@]}" 
    do
        (cat ${benchDir}/${mapper}/${run}.csv | sed -n 2p | tr -d '\n'; echo -e "\t${run}\t${mapper}") >> ${benchDir}/combinedBenchmarkCov5.csv
    done
done