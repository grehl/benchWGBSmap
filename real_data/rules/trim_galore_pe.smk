

rule trim_galore_pe:
	input:
		read1="raw/{sample}_1.fastq",
		read2="raw/{sample}_2.fastq"

	output:
		expand("results/trim/{{tool}}/trim_galore{{parameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}",suff=["_1_val_1.fq","_1.fastq_trimming_report.txt"]),
		expand("results/trim/{{tool}}/trim_galore{{parameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}",suff=["_2_val_2.fq","_2.fastq_trimming_report.txt"])

	threads: 1
	
	params:
		output="--output_dir=results/trim/{tool}/trim_galore{parameterSet}/{species}/{sample}/",
		user= lambda wildcards: config["parameters"][wildcards.tool][wildcards.parameterSet]

	log:
		"logs/{tool}/{parameterSet}/{species}/{sample}/{sample}.log"

	conda:
		"../envs/trim_galore.yaml"

	shell:
		"trim_galore --illumina --paired {params.user} {params.output} {input.read1} {input.read2}"