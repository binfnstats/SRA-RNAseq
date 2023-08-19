# Workflow definition named 'trimmomatic_fastqc' to run the Trimmomatic and FastQC process
workflow trimmomatic_fastqc {

  # Define the input file that contains the sample list
  File inputSampleFile

  # Read the inputSampleFile and store it in an Array[Array[File]] named 'files'
  Array[Array[File]] files = read_tsv(inputSampleFile)

  # Define the input file that contains the TruSeq3 adapter sequences
  File TruSeq3

  # Use scatter to parallelize the trimming and quality control process for each sample in 'files'
  scatter(file in files) {

    # Call the 'trim' task with the specified inputs
    call trim {
      input:
        fastq1 = file[0],
        fastq2 = file[1],
        adapterfile = TruSeq3,
        sample_basename = basename(file[0], ".fq.gz")
    }

    # Call the 'postfastqc' task with the trimmed FASTQ files as input
    call postfastqc {
      input:
        fastq1 = trim.trim_fastq1,
        fastq2 = trim.trim_fastq2
    }
  }
}

# Define a task named 'trim' to run the Trimmomatic process
task trim {
  # Define the input files and parameters for the task
  File fastq1
  File fastq2
  File adapterfile
  String sample_basename

  # Define the command that will run the Trimmomatic process
  command {
    trimmomatic PE -phred33 -threads 4 ${fastq1} ${fastq2} ${sample_basename}_R1P_trim.fq.gz ${sample_basename}_R1U_trim.fq.gz ${sample_basename}_R2P_trim.fq.gz ${sample_basename}_R2U_trim.fq.gz ILLUMINACLIP:${adapterfile}:2:30:10 SLIDINGWINDOW:4:20 MINLEN:40
  }

  # Define the output files for the task
  output {
    File trim_fastq1 = "${sample_basename}_R1P_trim.fq.gz"
    File trim_fastq2 = "${sample_basename}_R2P_trim.fq.gz"
    File trim_unpaired_fastq1 = "${sample_basename}_R1U_trim.fq.gz"
    File trim_unpaired_fastq2 = "${sample_basename}_R2U_trim.fq.gz"
  }

  # Define the runtime settings for the task
  runtime {
    docker : "trimmomatic:1.0"
    memory: "4 GB"
    cpu: 4
  }
}

# Define a task named 'postfastqc' to run the FastQC process on the trimmed FASTQ files
task postfastqc {
  # Define the input files for the task
  File fastq1
  File fastq2

  # Define the command that will run the FastQC process
  command {
    fastqc -t 4 --outdir $PWD ${fastq1} ${fastq2}
  }

  # Define the output files for the task
  output {
    Array[File] results = glob("*html")
    Array[File] resultszip = glob("*zip")
  }

  # Define the runtime settings for the task
  runtime {
    docker : "fastqc:1.0"
    memory: "4 GB"
    cpu: 4
  }
}
