# dockstore-edge-covid19

A repo for the `Dockstore.yml` which is used by the [Dockstore](https://www.dockstore.org) to register
this tool/workflow and describe how to call edge-covid19 for the community.

## Running Manually

```
$ git clone https://github.com/chienchi/dockstore-edge-covid19.git 
$ cd dockstore-edge-covid19
$ docker run -it --rm -v `pwd`:/repo bioedge/edge-covid19 bash

# within the docker container
perl /home/edge/edge/runPipeline -c /repo/configs/config.illumina.txt -o /repo/testing -cpu 3 -p /repo/test/SARS-COVID-test-swift-v2.1.fastq /repo/test/SARS-COVID-test-swift-v2.2.fastq

```

You'll then see a output directory, `/repo/testing`, that's the project output files. You can also see the `testing` result directory out of the container. A report HTML file `testing/HTML_Report/report.html` can be opened and visualized in host environment.

## Running Through the Dockstore CLI

This tool can be found at the [Dockstore](https://dockstore.org), login with your GitHub account and follow the directions to setup the CLI.  It lets you run a Docker container with a CWL/WDL descriptor locally, using Docker and the CWL/WDL command line utility.  This is great for testing.
 
### With WDL
#### Make a Parameters JSON

This is the parameterization of the edge-covid19 workflow, a copy is present in this repo called `test/test.wdl.json`:

```
{
  "edgecovid19Workflow.EDGEconfig": "configs/config.illumina.trim_swift_primer.txt",
  "edgecovid19Workflow.projName":"edgecovid19_test",
  "edgecovid19Workflow.Read_1":"test/SARS-COVID-test-swift-v2.1.fastq",
  "edgecovid19Workflow.Read_2":"test/SARS-COVID-test-swift-v2.2.fastq",
  "edgecovid19Workflow.mem_gb": 8,
  "edgecovid19Workflow.cpu": 3
}

```
#### Run with the CLI

Run it using the `dockstore` CLI:

```
Usage:
# fetch WDL
$> dockstore tool wdl --entry quay.io/collaboratory/dockstore-edge-covid19 > Dockstore.wdl
# make a runtime JSON template and edit it (or use the content of test.wdl.json above)
$> dockstore tool convert wdl2json --wdl Dockstore.wdl > Dockstore.json
# run it locally with the Dockstore CLI
$> dockstore tool launch --entry quay.io/collaboratory/dockstore-edge-covid19 --json Dockstore.json
```


## Point of contact

maintainer: Chienchi Lo <chienchi@lanl.gov>