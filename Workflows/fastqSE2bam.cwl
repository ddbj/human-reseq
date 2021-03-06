#!/usr/bin/env cwl-runner

class: Workflow
id: fastqSE2bam
label: fastqSE2bam
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa

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

  fq:
    type: File
    format: edam:format_1930
    doc: FastQ file from next-generation sequencers

  nthreads:
    type: int
    doc: number of cpu cores to be used

  outprefix:
    type: string
    doc: Output prefix name


steps:
  bwa_mem_SE:
    label: bwa_mem_SE
    doc: Mapping onto reference using BWA MEM
    run: ../Tools/bwa-mem-SE.cwl
    in:
      reference: reference
      RG_ID: RG_ID
      RG_PL: RG_PL
      RG_PU: RG_PU
      RG_LB: RG_LB
      RG_SM: RG_SM
      fq: fq
      nthreads: nthreads
      outprefix: outprefix
    out: [sam, log]

  picard_SortSam:
    label: picard_SortSam
    doc: Sort sam file and save as bam file
    run: ../Tools/picard-SortSam.cwl
    in:
      sam: bwa_mem_SE/sam
      outprefix: outprefix
    out: [bam, log]

outputs:
  sam:
    type: File
    format: edam:format_2573
    outputSource: bwa_mem_SE/sam
  sam_log:
    type: File
    outputSource: bwa_mem_SE/log
  bam:
    type: File
    format: edam:format_2572
    outputSource: picard_SortSam/bam
  bam_log:
    type: File
    outputSource: picard_SortSam/log
