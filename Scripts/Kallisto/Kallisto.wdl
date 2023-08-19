# Workflow definition named 'kallisto' to run the kallisto quantification process
workflow kallisto {

  # Define the input file that contains the sample list
  File InputSampleFile

  # Read the InputSampleFile and store it in an Array[Array[File]] named 'files'
  Array[Array[File]] files = read_tsv(InputSampleFile)

  # Define the input file that contains the gencode.v31.transcripts.fa indexed file
  File gencode

  # Use scatter to parallelize the quantification process for each sample in 'files'
  scatter(file in files) {
    call quant {
      input:
        # Specify the gencode input file
        gencode= gencode,
        # Specify the first FASTQ file from the 'file' array
        fastq1= file[0],
        # Specify the second FASTQ file from the 'file' array
        fastq2= file[1],
        # Use the basename of the first FASTQ file to generate the sample_basename
        sample_basename=basename(file[0], ".fq.gz")
    }
  }
}

# Define a task named 'quant' to run the kallisto quantification process
task quant {
  # Define the input file for the gencode
  File gencode
  # Define the input file for the first FASTQ file
  File fastq1
  # Define the input file for the second FASTQ file
  File fastq2
  # Define the input string for the sample_basename
  String sample_basename

  # Define the command that will run the kallisto quantification process
  command {
    # Run the kallisto quantification command with the specified inputs
    kallisto quant -o ${sample_basename} -i ${gencode} ${fastq1} ${fastq2}
    # Compress the output directory into a tarball with the sample_basename as the prefix
    tar -zcvf ${sample_basename}.quant.tar.gz ${sample_basename}    
  }
  # Define the runtime settings for the task
  runtime {
    # Specify the Docker image to use for the task
    docker : "kallisto:0.1"
    # Specify the memory requirements for the task
    memory: "2G"
    # Specify the CPU requirements for the task
    cpu: "1"
  }
  
  # Define the output file for the task
  output {
    # Specify the output file as the tarball with the sample_basename as the prefix
    File TAR = "${sample_basename}.quant.tar.gz"
  }
}
