





rule add_chr:
	input:
		file="results/methyl_info/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_dedup_samb_select.cytosine_report.txt"

	output:
		file="results/methyl_info/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_dedup.cytosine_report_chr.txt"

	log:
		"logs/methyl_info/bismark_methyl/chr/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	shell:
		"cat {input.file} | sed 's/^/chr/' > {output.file}"