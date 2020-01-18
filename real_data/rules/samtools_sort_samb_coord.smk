




rule samtools_sort_samb_coord:
	input:
		file="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sambamba_dedup.bam"

	output:
		file="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sambamba_dedup_coord.bam"

	log:
		"logs/samtools_sort/dedup/samb/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	threads: 5

	conda:
		"../envs/samtools.yaml"		

	shell:
		"samtools sort -@ {threads} --output-fmt BAM -T tmp {input.file} > {output.file}"
