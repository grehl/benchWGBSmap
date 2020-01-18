

rule methyldackel:
	input:
		file="results/deduplication/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_dedup_samb_select.bam"

	output:
		file="results/methyl_info/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_dedup_samb_select.cytosine_report.txt"

	threads: 10

	log:
		"logs/methyl_info/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}.log"

	params:
		output="results/methyl_info/{mappingtool}/{tool}/{trim_galoreparameterSet}/{species}/{sample}/{sample}_dedup_samb_select"

	conda:
		"../envs/methyldackel.yaml"

	shell:
		"MethylDackel extract --CHG --CHH --cytosine_report -@ {threads} -o {params.output} /scratch/user/ahgyg/genomes/Glycine_max/ref/Williams82_v2.1.43/fasta/Glycine_max.Glycine_max_v2.1.dna.toplevel.fa {input.file}"