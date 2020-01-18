


rule samtools_select_chr:
	input:
		file="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sambamba_dedup_coord.bam"

	output:
		file="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_dedup_samb_select.bam"

	log:
		"logs/deduplication_select/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	threads: 5

	conda:
		"../envs/samtools.yaml"

	shell:
		"samtools view -@ {threads} -b {input.file} 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 > {output.file}"