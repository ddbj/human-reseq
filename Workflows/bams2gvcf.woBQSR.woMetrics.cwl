#!/usr/bin/env cwl-runner

class: Workflow
id: bam2gvcf-woBQSR-woMetrics
label: bam2gvcf-woBQSR-woMetrics
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome
    secondaryFiles:
      - .fai
      - ^.dict

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
    out: [out_bam, out_metrics, log]

  gatk3_HaplotypeCaller:
    label: gatk3_HaplotypeCaller
    doc: Haplotype calling using GATK3
    run: ../Tools/gatk3-HaplotypeCaller.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      nthreads: nthreads
      reference: reference
      outprefix: outprefix
    out: [vcf, log]
    
outputs:
  rmdup_log:
    type: File
    outputSource: picard_MarkDuplicates/log

  gatk3_HaplotypeCaller_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_HaplotypeCaller/vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_log:
    type: File
    outputSource: gatk3_HaplotypeCaller/log
    
