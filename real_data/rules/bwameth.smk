


rule bwameth:
	input:
		index= lambda wildcards: config["ref"][wildcards.species]["dirbwameth"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/mapping/bwameth/{{tool}}/{{trim_galoreparameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}", suff=[".sam"])

	threads: 4

	params:
		output="results/mapping/bwameth/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam"

	log:
		"logs/mapping/bwameth/{tool}/{trim_galoreparameterSet}/{species}/{sample}.log"

	conda:
		"../envs/bwameth.yaml"

	shell:
		"bwameth.py --reference {input.index} -t {threads} {input.read1} {input.read2} > {params.output}"

