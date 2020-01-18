



rule gsnap:
	input:
		index1= lambda wildcards: config["ref"][wildcards.species]["dirgsnap1"],
		read1= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1.fq",
		read2= "results/trim/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/mapping/gsnap/{{tool}}/{{trim_galoreparameterSet}}/{{species}}/{{sample}}/{{sample}}{suff}", suff=[".sam"])

	threads: 4

	params:
		output="results/mapping/gsnap/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam",
		index2= lambda wildcards: config["ref"][wildcards.species]["dirgsnap2"]

	log:
		"logs/mapping/gsnap/{tool}/{trim_galoreparameterSet}/{species}/{sample}.log"

	shell:
		"../tools/gmap-2019-06-10/bin/gsnap --format=sam --mode=cmet-stranded -m 0 -t {threads} -D {input.index1} -d {params.index2} {input.read1} {input.read2} > {params.output}" 
