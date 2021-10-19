 # ✒️SRA-RNAseq


Our Guthub repo include pipelines for running Pre-processing methods such as Trimming, quality control and pseudoalignment using [Trimmomatic](https://github.com/usadellab/Trimmomatic), [fastQC](https://github.com/s-andrews/FastQC) and [Kallisto](https://github.com/pachterlab/kallisto) tools respectively.
All the pipelines are written 
using the [Workflow Description Language (WDL)](https://github.com/openwdl/wdl) and can be executed using 
[Cromwell](https://github.com/broadinstitute/cromwell) and [Docker](https://www.docker.com/). 




## ⚙️Technologies & Tools


![](https://img.shields.io/badge/OS-Linux-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Shell-Bash-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Code-JavaScript-informational?style=flat&logo=<#FF6000>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Tools-Docker-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Tools-Cromwell-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)



## 🔗 Quick Start

 
* Install [JAVA](https://www.java.com/en/download/), and [Cromwell](https://github.com/broadinstitute/cromwell) 
* Build [Docker](https://www.docker.com/) images for [Trimmomatic](https://github.com/usadellab/Trimmomatic), [fastQC](https://github.com/s-andrews/FastQC) and [Kallisto](https://github.com/pachterlab/kallisto) 
* Build an index file from a FASTA formatted file of target sequences using [Kallisto](https://github.com/pachterlab/kallisto). 
* Run the workflow directly by executing the following commands on your terminal:

`java -Dconfig.file=application.conf -jar cromwell-55.jar run Trim-QC.wdl -i Trim-QC.json` 
 
 
 
