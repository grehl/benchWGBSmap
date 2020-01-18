

rule qualimap_bamqc_dedupl:
	input:
		samp="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sambamba_dedup_coord.bam"

	output:
		"results/quality/qualimap/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/qualimapReport.html"

	conda:
		"../envs/qualimap.yaml"

	threads: 15

	params:
		output="-outdir {mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/"

	log:
		"logs/qualimap/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"
		
	shell:
		"qualimap bamqc -bam {input.samp} --java-mem-size=200G {params.output} -c -ip -sd -nt {threads} -nw 300"
