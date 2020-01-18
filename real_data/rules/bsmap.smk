


rule bsmap:
	input:
		index= lambda wildcards: config["ref"][wildcards.species]["dirbsmap"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		"results/mapping/bsmap/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam"

	threads: 8

	params:
		output="results/mapping/bsmap/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam"

	log:
		"logs/mapping/bsmap/{tool}/{trim_galoreparameterSet}/{species}/{sample}.log"

	conda:
		"../envs/bsmap.yaml"

	shell:
		"bsmap -r 0 -a {input.read1} -b {input.read2} -d {input.index} -v 0 -p {threads} -o {params.output}"
