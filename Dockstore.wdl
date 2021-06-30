version 1.0
task runEDGEcovid19 {
	input {
		File EDGEconfig
		String projName
		File Read_1
		File? Read_2
		Int mem_gb
		Int cpu
	}

	command{
		sed -ie 's/projname=.*/projname=${projName}/' ${EDGEconfig} 
		if [ -f "${Read_2}" ]; then
			perl /home/edge/edge/runPipeline -c ${EDGEconfig} -o $PWD/${projName} -cpu ${cpu} -noColorLog -p ${Read_1} ${Read_2}
		else
			perl /home/edge/edge/runPipeline -c ${EDGEconfig} -o $PWD/${projName} -cpu ${cpu} -noColorLog -u ${Read_1} 
		fi
		zip -r ${projName}_output.zip ${projName} 
	}

	output {
		File project_zip_output = "${projName}_output.zip"
		File consensus_fasta = "${projName}/ReadsBasedAnalysis/readsMappingToRef/NC_045512.2_consensus.fasta"
		File pangolin_result = "${projName}/ReadsBasedAnalysis/readsMappingToRef/NC_045512.2_consensus_lineage.txt"
		File aligned_bam_file = "${projName}/ReadsBasedAnalysis/readsMappingToRef/NC_045512.2.sort.bam"
	}

	runtime {
		docker: "quay.io/chienchi/dockstore-edge-covid19:latest"
		memory: mem_gb + "GB"
		cpu: cpu
	}

	meta {
		author: "Chienchi Lo"
		email: "chienchi@lanl.gov"
		description: "## EDGE COVID-19 \n EDGE COVID-19 is a tailored bioinformatics platform based on the more flexible and fully open-source <a href='https://edgebioinformatics.org' target='_new'>EDGE Bioinformatics</a> software (<a href='https://doi.org/10.1093/nar/gkw1027' target='_new'>Li et al. 2017</a>). This mini-version consists of a user-friendly GUI that drives standardized workflows for genome reference-based 'assembly' and preliminary analysis of Illumina or Nanopore data for SARS-CoV-2 genome sequencing projects. <b>The result is a final SARS-CoV-2 genome ready for submission to GISAID and/or GenBank.</b>"
	}
}

workflow edgecovid19Workflow {
	input {
		File EDGEconfig
		File Read_1
		File? Read_2
		String projName = 'edgecovid19'
		Int mem_gb = 8
		Int cpu = 3
	}
	
	call runEDGEcovid19 { input: EDGEconfig=EDGEconfig, Read_1=Read_1, Read_2=Read_2, projName=projName, mem_gb=mem_gb, cpu=cpu }
	
	parameter_meta{
		EDGEconfig: "the project configuration file which defined the workflow modules and parameters."
		Read_1: "single end reads or  forward reads from paired-end data"
		Read_2: "reverse reads from paired-end data"
		projName: "project name. Only alphabets, numbers and underscore are allowed"
		
		zip_output: "all project output directories/files zip output"
		consensus_fasta: "final assembled consensus fasta file"
		pangolin_result: "pangolin lineage assignment result text file"
		aligned_bam_file: "reads aligned to Wuhan Refseq genome result bam file"
	}
	
	output {
		File zip_output = runEDGEcovid19.project_zip_output
		File consensus_fasta = runEDGEcovid19.consensus_fasta
		File pangolin_result = runEDGEcovid19.pangolin_result
		File aligned_bam_file = runEDGEcovid19.aligned_bam_file
	}
}
