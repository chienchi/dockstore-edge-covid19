version 1.0
task runUShER{
	input {
		File Fasta
		Int mem_gb
	}

	command{
		mkdir -p UShER_output
		/home/edge/edge/scripts/run_remote_UShER.py -f ${Fasta} -o UShER_output/UShER_result.html
		cp -r /home/edge/edge/edge_ui/javascript/hgPhyloPlace UShER_output/js
		zip -r UShER_output.zip UShER_output 
	}

	output {
		File zip_output = "UShER_output.zip"
	}

	runtime {
		docker: "bioedge/edge-covid19:latest"
		memory: mem_gb + "GB"
		cpu: 1
	}
	
	parameter_meta {
		Fasta: "assembled/consensus genome fasta"
	}

	meta {
		author: "Chienchi Lo"
		email: "chienchi@lanl.gov"
		description: "Place input fasta into a larger SARS-CoV-2 tree using remote UShER and UCSC genome browser"
	}
}