


rule sambamba:
	input:
		file="results/sortedsam/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sort_name.bam"

	output:
		file="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sambamba_dedup.bam"

	log:
		"logs/deduplication/samb/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	conda:
		"../envs/sambamba.yaml"

	threads: 10

	shell:
		"sambamba markdup -r -t {threads} {input.file} {output.file}"