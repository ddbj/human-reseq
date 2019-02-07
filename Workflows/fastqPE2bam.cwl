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

  fq1:
    type: File
    format: edam:format_1930
    doc: FastQ file from next-generation sequencers

  fq2:
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
  bwa_mem_PE:
    label: bwa_mem_PE
    doc: Mapping onto reference using BWA MEM
    run: ../Tools/bwa-mem-PE.cwl
    in:
      reference: reference
      reference_amb: reference_amb
      reference_ann: reference_ann
      reference_bwt: reference_bwt
      reference_pac: reference_pac
      reference_sa: reference_sa
      RG_ID: RG_ID
      RG_PL: RG_PL
      RG_PU: RG_PU
      RG_LB: RG_LB
      RG_SM: RG_SM
      fq1: fq1
      fq2: fq2
      nthreads: nthreads
      outprefix: outprefix
    out: [sam, log]

  picard_SortSam:
    label: picard_SortSam
    doc: Sort sam file and save as bam file
    run: ../Tools/picard-SortSam.cwl
    in:
      sam: bwa_mem_PE/sam
      outprefix: outprefix
    out: [bam, log]

outputs:
  sam:
    type: File
    format: edam:format_2573
    outputSource: bwa_mem_PE/sam
  sam_log:
    type: File
    outputSource: bwa_mem_PE/log
  bam:
    type: File
    format: edam:format_2572
    outputSource: picard_SortSam/bam
  bam_log:
    type: File
    outputSource: picard_SortSam/log
