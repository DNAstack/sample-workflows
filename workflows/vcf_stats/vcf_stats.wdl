version 1.0

workflow calculate_vcf_stats {
	input {
		String vcf_url

		String dnastack_drs_url
		String container_registry
	}

	call download_vcf {
		input:
			vcf_url = vcf_url,
			dnastack_drs_url = dnastack_drs_url,
			container_registry = container_registry
	}

	call bcftools_stats {
		input:
			vcf = download_vcf.vcf,
			container_registry = container_registry
	}

	output {
		File vcf_stats = bcftools_stats.vcf_stats
	}

	meta {
		author: "Heather Ward"
		email: "heather@dnastack.com"
		description: "# VCF stats via DRS ID\n\nThis workflow will download a VCF file using a DRS URL. It will then run bcftools stats on that VCF and output the stats file.\n\nTest inputs may be found in [inputs.json](inputs.json).\n\n\n## Docker images\n\nDocker image definitions may be found in DNAstack's [public image repository](https://github.com/dnastack/bioinformatics-public-docker-images).\n\nRequired docker images have been pushed to the public Google container registry (gcr.io/dnastack-pub-container-store).\n"
	}
}

task download_vcf {
	input {
		String vcf_url

		String dnastack_drs_url
		String container_registry
	}

	command <<<
		set -euo pipefail

		dnastack config set drs.url ~{dnastack_drs_url}

		mkdir output_dir
		dnastack files download \
			--output-dir output_dir \
			~{vcf_url}
	>>>

	output {
		File vcf = glob("output_dir/*.vcf.gz")[0]
	}

	runtime {
		docker: "~{container_registry}/dnastack-client-library:3.0.56a1648737133"
		cpu: 1
		memory: "1 GB"
		disks: "local-disk 10 HDD"
	}
}

task bcftools_stats {
	input {
		File vcf
		String container_registry
	}

	String vcf_basename = basename(vcf, ".vcf.gz")

	command <<<
		set -euo pipefail

		bcftools stats ~{vcf} > ~{vcf_basename}.stats.txt
	>>>

	output {
		File vcf_stats = "~{vcf_basename}.stats.txt"
	}

	runtime {
		docker: "~{container_registry}/bcftools:1.16"
		cpu: 1
		memory: "1 GB"
		disks: "local-disk 10 HDD"
	}
}
