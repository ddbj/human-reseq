#!/usr/bin/env cwl-runner

class: Workflow
id: fastqPE2bam
label: fastqPE2bam
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome

  reference_amb:
    type: File
    doc: AMB index file for reference genome

  reference_ann:
    type: File
    doc: ANN index file for reference genome

  reference_bwt:
    type: File
    doc: BWT index file for reference genome

  reference_pac:
    type: File
    doc: PAC index file for reference genome

  reference_sa:
    type: File
    doc: SA index file for reference genome

  bam_files:
    type: File[]
    format: edam:format_2572
    doc: array of input BAM alignment files (each file should be sorted)
  
  nthreads:
    type: int
    doc: number of cpu cores to be used

  outprefix:
    type: string
    doc: Output prefix name


steps:
  picard_MarkDuplicates:
    label: picard_MarkDuplicates
    doc: Merge BAM files and remove duplicates
    run: ../Tools/picard-MarkDuplicates.cwl
    in:
      bam_files: bam_files
      outprefix: outprefix
    out: [out_bam, out_bai, out_metrics, log]

outputs:
  rmdup_bam:
    type: File
    format: edam:format_2572
    outputSource: picard_MarkDuplicates/out_bam

  rmdup_bai:
    type: File
    outputSource: picard_MarkDuplicates/out_bai

  rmdup_metrics:
    type: File
    outputSource: picard_MarkDuplicates/out_metrics

  rmdup_log:
    type: File
    outputSource: picard_MarkDuplicates/log
