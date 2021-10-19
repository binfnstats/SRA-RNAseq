workflow kallisto {

  File InputSampleFile

  Array[Array[File]] files = read_tsv(InputSampleFile)

  File gencode

 
 scatter(file in files) {
  call quant {
    input:
      gencode= gencode,
      fastq1= file[0],
      fastq2= file[1],
      sample_basename=basename(file[0], ".fq.gz")

  }
 

  }

}


task quant {
  File gencode
  File fastq1
  File fastq2
  String sample_basename

command {
    kallisto quant -o ${sample_basename} -i ${gencode} ${fastq1} ${fastq2}
    tar -zcvf ${sample_basename}.quant.tar.gz ${sample_basename}    
  }
  runtime {
      docker : "kallisto:0.1"
    memory: "2G"
    cpu: "1"
  }
  
  output {
    File TAR = "${sample_basename}.quant.tar.gz"
  }
}
