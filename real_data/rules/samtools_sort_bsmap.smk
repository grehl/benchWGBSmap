



rule samtools_sort_bsmap:
	input:
		file="results/mapping/bsmap/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.sam"

	output:
		file="results/sortedsam/bsmap/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sort_name.bam"

	log:
		"logs/samtools_sort/sortedsam/bsmap/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	threads: 5

	conda:
		"../envs/samtools.yaml"

	shell:
		"samtools view -@ {threads} -S -b {input.file} | samtools sort -n -@ {threads} --output-fmt BAM -T tmp > {output.file}"