workflow trimmomatic_fastqc {

  File inputSampleFiles

  Array[Array[File]] files = read_tsv(inputSampleFiles)

  File TruSeq3

 

  scatter(file in files) {

                call trim {

                  input: fastq1=file[0],

                                fastq2=file[1],

                 adapterfile=TruSeq3,

                                sample_basename=basename(file[0], ".fq.gz")

                }

                call postfastqc {

                  input: fastq1=trim.trim_fastq1,

                                fastq2=trim=.trim_fastq2

                }

 

  }

}

 

task trim {

  File fastq1

  File fastq2

  File adapterfile

  String sample_basename

 

  command {

    trimmomatic PE -phred33 -threads 4 ${fastq1} ${fastq2} ${sample_basename}_R1P_trim.fq.gz ${sample_basename}_R1U_trim.fq.gz ${sample_basename}_R2P_trim.fq.gz ${sample_basename}_R2U_trim.fq.gz ILLUMINACLIP:${adapterfile}:2:30:10 SLIDINGWINDOW:4:20 MINLEN:40
}

  output {

    File trim_fastq1="${sample_basename}_R1P_trim.fq.gz" File trim_fastq2="${sample_basename}_R2P_trim.fq.gz"
    File trim_unpaired_fastq1="${sample_basename}_R1U_trim.fq.gz" File trim_unpaired_fastq2="${sample_basename}_R2U_trim.fq.gz"

  }

  runtime

  {

    docker : "trimmomatic:1.0"

    memory: "4 GB"

    cpu: 4


  }

}

 
task postfastqc {

                File fastq1

                File fastq2

 

  command {

    fastqc -t 4 --outdir $PWD ${fastq1} ${fastq2}

  }

  output {

    Array[File] results = glob("*html")

    Array[File] resultszip = glob("*zip")

  }

  runtime

  {

    docker : "fastqc:1.0"

    memory: "4 GB"

    cpu: 4
    

  }
  }
