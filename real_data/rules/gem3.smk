


rule gem3:
	input:
		index= lambda wildcards: config["ref"][wildcards.species]["dirgem3"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/mapping/gem3/{{tool}}/{{trim_galoreparameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}", suff=[".sam"])

	threads: 4

	params:
		output="results/mapping/gem3/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam"

	log:
		"logs/mapping/gem3/{tool}/{trim_galoreparameterSet}/{species}/{sample}.log"

	shell:
		"../tools/gem3-mapper/bin/gem-mapper -e 0 -I {input.index} -t {threads} -1 {input.read1} -2 {input.read2} -o {params.output}"
