

rule bismark_mapping_bwt2:
	input:
		index= lambda wildcards: config["ref"][wildcards.species]["dirbwt2"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/mapping/bismark_bwt2/{{tool}}/{{trim_galoreparameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}", suff=["_1_val_1_bismark_bt2_pe.bam","_1_val_1_bismark_bt2_PE_report.txt"])

	threads: 4

	params:
		output="--output_dir=results/mapping/bismark_bwt2/{tool}/{trim_galoreparameterSet}/{species}/{sample}/"

	log:
		"logs/mapping/bismark_bwt2/{tool}/{trim_galoreparameterSet}/{species}/{sample}.log"

	conda:
		"../envs/bismark.yaml"

	shell:
		"bismark -1 {input.read1} -2 {input.read2} {input.index} --parallel {threads} {params.output}" 