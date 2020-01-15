

rule fastqc_r1_trim:
	input:
		"results/trim/{tool}/trim_galore{parameterSet}/{species}/{sample}/{sample}_1_val_1.fq"

	output:
		expand("results/quality/fastqc/aftertrim/{{tool}}/trim_galore{{parameterSet}}/{{species}}/{{sample}}/{{sample}}_1_val_1_fastqc.{suf}", suf=["html","zip"])
	
	threads: 2

	log:
		"logs/fastqc/{tool}/trim_galore{parameterSet}/{species}/{sample}/{sample}.log"

	conda:
		"../envs/fastqc.yaml"

	params:
		outdir="results/quality/fastqc/aftertrim/{tool}/trim_galore{parameterSet}/{species}/{sample}/"

	shell: "fastqc -t {threads} -o {params.outdir} {input}"


rule fastqc_r2_trim:
	input:
		"results/trim/{tool}/trim_galore{parameterSet}/{species}/{sample}/{sample}_2_val_2.fq"

	output:
		expand("results/quality/fastqc/aftertrim/{{tool}}/trim_galore{{parameterSet}}/{{species}}/{{sample}}/{{sample}}_2_val_2_fastqc.{suf}", suf=["html","zip"])

	threads: 2

	log:
		"logs/fastqc/{tool}/trim_galore{parameterSet}/{species}/{sample}/{sample}.log"

	conda:
		"../envs/fastqc.yaml"

	params:
		outdir="results/quality/fastqc/aftertrim/{tool}/trim_galore{parameterSet}/{species}/{sample}"

	shell: "fastqc -t {threads} -o {params.outdir} {input}"

