



rule fastqc_r1:
	input:
		"raw/{sample}_1.fastq"

	output:
		expand("results/quality/fastqc/pretrim/{{species}}/{{sample}}/{{sample}}_1_fastqc.{suf}", suf=["html","zip"])

	threads: 8

	log:
		"logs/fastqc/{species}/{sample}_1.log"

	conda:
		"../envs/fastqc.yaml"

	params:
		outdir="results/quality/fastqc/pretrim/{species}/{sample}"

	shell: "fastqc -t {threads} -o {params.outdir} {input}"


rule fastqc_r2:
	input:
		"raw/{sample}_2.fastq"

	output:
		expand("results/quality/fastqc/pretrim/{{species}}/{{sample}}/{{sample}}_2_fastqc.{suf}", suf=["html","zip"])

	threads: 8

	log:
		"logs/fastqc/{species}/{sample}_2.log"

	conda:
		"../envs/fastqc.yaml"

	params:
		outdir="results/quality/fastqc/pretrim/{species}/{sample}"

	shell: "fastqc -t {threads} -o {params.outdir} {input}"

