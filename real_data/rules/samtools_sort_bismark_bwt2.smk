


rule samtools_sort_bismark_bwt2:
	input:
		file="results/mapping/bismark_bwt2/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_1_val_1_bismark_bt2_pe.bam"

	output:
		file="results/sortedsam/bismark_bwt2/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_sort_name.bam"

	log:
		"logs/samtools_sort/sortedsam/bismark_bwt2/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	threads: 5

	conda:
		"../envs/samtools.yaml"		

	shell:
		"samtools sort -n -@ {threads} --output-fmt BAM -T tmp {input.file} > {output.file}"