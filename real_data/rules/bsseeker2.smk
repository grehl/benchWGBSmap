


rule bsseeker2:
	input:
		index= lambda wildcards: config["ref"][wildcards.species]["dirbsseeker2"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/mapping/bsseeker2/{{tool}}/{{trim_galoreparameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}", suff=[".sam"])

	threads: 4

	params:
		output="results/mapping/bsseeker2/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam"

	log:
		"logs/mapping/bsseeker2/{tool}/{trim_galoreparameterSet}/{species}/{sample}.log"

	conda:
		"../envs/python2_7.yaml"

	shell:
		"python ../tools/BSseeker2/bs_seeker2-align.py -1 {input.read1} -2 {input.read2} -m 0 -f sam -g {input.index} -o {params.output} --path=/home/ahgyg/miniconda3/envs/snakemake_bismark/bin/ --temp_dir=/scratch/user/ahgyg/benchmarkWGBS/real_data/tmp/"
