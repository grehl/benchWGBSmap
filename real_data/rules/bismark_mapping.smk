



rule bismark_mapping_bwt1:
	input:
		index= lambda wildcards: config["ref"][wildcards.species]["dirbwt1"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/mapping/bismark_bwt1/{{tool}}/{{trim_galoreparameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}", suff=["_1_val_1_bismark_pe.bam","_1_val_1_bismark_PE_report.txt"])

	threads: 4

	params:
		output="results/mapping/bismark_bwt1/{tool}/{trim_galoreparameterSet}/{species}/{sample}/"

	log:
		"logs/mapping/bismark_bwt1/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	conda:
		"../envs/bismark.yaml"

	shell:
		"bismark --bowtie1 --path_to_bowtie /home/ahgyg/miniconda3/envs/benchmarkMapper/bin/ -n 0 -1 {input.read1} -2 {input.read2} {input.index} --parallel {threads} --output_dir={params.output}"