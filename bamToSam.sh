#!/bin/bash

for file in ../data/mappedCov20BsReads/bsseeker2/mm_3/*.bam
do
    echo $file
    echo ${file/.bam/.sam}
    sbatch --job-name=bamToSam --ntasks-per-node=1 --mem-per-cpu=10000 --time=10:00:00 \
    <<< "#!/bin/bash 
    samtools view -h -o ${file/.bam/.sam} ${file}"
    sleep 1
done