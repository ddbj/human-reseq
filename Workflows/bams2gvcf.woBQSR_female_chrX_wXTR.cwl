#!/usr/bin/env cwl-runner

class: Workflow
id: bam2gvcf-woBQSR-female-chrX-wXTR
label: bam2gvcf-woBQSR-female-chrX-wXTR
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

requirements:
  MultipleInputFeatureRequirement: {}

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genom
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict

  RG_ID:
    type: string
    doc: Read group identifier (ID) in RG line

  RG_PL:
    type: string
    doc: Platform/technology used to produce the read (PL) in RG line

  RG_PU:
    type: string
    doc: Platform Unit (PU) in RG line

  RG_LB:
    type: string
    doc: DNA preparation library identifier (LB) in RG line

  RG_SM:
    type: string
    doc: Sample (SM) identifier in RG line

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

  chrXY_outprefix:
    type: string
    doc: Output prefix name for chrXY

steps:
  picard_MarkDuplicates:
    label: picard_MarkDuplicates
    doc: Merge BAM files and remove duplicates
    run: ../Tools/picard-MarkDuplicates.cwl
    in:
      bam_files: bam_files
      outprefix: outprefix
    out: [out_bam, out_metrics, log]

  samtools_extract_chrXY_unmap:
    label: samtools_extract_chrXY_unmap
    doc: Extract reads mapped on chrXY or unmapped
    run: ../Tools/samtools-extract-chrXY+unmap.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      nthreads: nthreads
      outprefix: chrXY_outprefix
    out: [chrXY_fastq]

  bwa_mem_SE_wXTR:
    label: bwa_mem_SE
    doc: Map single-end reads
    run: ../Tools/bwa-mem-SE.cwl
    in:
      reference: reference
      RG_ID: RG_ID
      RG_PL: RG_PL
      RG_PU: RG_PU
      RG_LB: RG_LB
      RG_SM: RG_SM
      fq: samtools_extract_chrXY_unmap/chrXY_fastq
      nthreads: nthreads
      outprefix: chrXY_outprefix
    out: [sam, log]

  picard_SortSam_wXTR:
    label: picard_SortSam_wXTR
    doc: Sort sam file and save as bam file
    run: ../Tools/picard-SortSam.cwl
    in:
      sam: bwa_mem_SE_wXTR/sam
      outprefix: chrXY_outprefix
    out: [bam, log]
    
  picard_MarkDuplicates_wXTR:
    label: picard_MarkDuplicates_wXTR
    doc: Merge BAM files and remove duplicates
    run: ../Tools/picard-MarkDuplicates-singleBam.cwl
    in:
      bam_file: picard_SortSam_wXTR/bam
      outprefix: chrXY_outprefix
    out: [out_bam, out_metrics, log]
    
  gatk3_HaplotypeCaller_X_ploidy2:
    label: gatk3_HaplotypeCaller_X_ploidy2
    doc: Haplotype calling using GATK3 for chrX region with ploidy=2
    run: ../Tools/gatk3-HaplotypeCaller-X-ploidy2.cwl
    in:
      in_bam: picard_MarkDuplicates_wXTR/out_bam
      nthreads: nthreads
      reference: reference
      outprefix: chrXY_outprefix
    out: [vcf, log]
    
outputs:
  rmdup_bam:
    type: File
    format: edam:format_2572
    outputSource: picard_MarkDuplicates/out_bam
    secondaryFiles:
      - ^.bai

  rmdup_metrics:
    type: File
    outputSource: picard_MarkDuplicates/out_metrics

  rmdup_log:
    type: File
    outputSource: picard_MarkDuplicates/log

  samtools_extract_chrXY_unmap_chrXY_fastq:
    type: File
    format: edam:format_1930
    outputSource: samtools_extract_chrXY_unmap/chrXY_fastq

  bwa_mem_SE_wXTR_sam:
    type: File
    format: edam:format_2573
    outputSource: bwa_mem_SE_wXTR/sam
    
  bwa_mem_SE_wXTR_log:
    type: File
    outputSource: bwa_mem_SE_wXTR/log

  picard_SortSam_wXTR_bam:
    type: File
    format: edam:format_2572
    outputSource: picard_SortSam_wXTR/bam

  picard_SortSam_wXTR_log:
    type: File
    outputSource: picard_SortSam_wXTR/log

  picard_MarkDuplicates_wXTR_bam:
    type: File
    format: edam:format_2572
    outputSource: picard_MarkDuplicates_wXTR/out_bam
    secondaryFiles:
      - ^.bai

  picard_MarkDuplicates_wXTR_metrics:
    type: File
    outputSource: picard_MarkDuplicates_wXTR/out_metrics

  picard_MarkDuplicates_wXTR_log:
    type: File
    outputSource: picard_MarkDuplicates_wXTR/log

  gatk3_HaplotypeCaller_X_ploidy2_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_HaplotypeCaller_X_ploidy2/vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_log:
    type: File
    outputSource: gatk3_HaplotypeCaller_X_ploidy2/log
    
