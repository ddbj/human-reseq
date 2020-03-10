#!/usr/bin/env cwl-runner

class: Workflow
id: germline
label: germline
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

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
  fqs:
    type:
      type: array
      items:
        type: record
        fields:
          - name: read1
            type: File
          - name: read2
            type: File
    doc: FastQ file from next-generation sequencers
  dbsnp:
    type: File
    doc: dbSNP data file for base recalibrator
    secondaryFiles:
      - .idx
  mills_indel:
    type: File
    doc: Mills indel data file for base recalibrator
    secondaryFiles:
      - .idx
  onek_indel:
    type: File
    doc: Onek indel data file for base recalibrator
    secondaryFiles:
      - .idx
  outprefix:
    type: string
  num_gpus:
    type: int?

steps:
  germline:
    label: parabricks_germline
    run: ../Tools/parabricks-germline.cwl
    in:
      reference: reference
      fqs: fqs
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
      outprefix: outprefix
      num_gpus: num_gpus
    out: [bam, recal, gvcf, log]
  htslib_bgzip:
    label: htslib_bgzip
    run: ../Tools/htslib-bgzip.cwl
    in:
      in_file: germline/gvcf
    out: [gz_file]
  bcftools_index:
    label: bcftools_index
    run: ../Tools/bcftools-index.cwl
    in:
      vcf: htslib_bgzip/gz_file
      nthreads:
        default: 1
    out: [vcf_tbi]
outputs:
  bam:
    type: File
    format: edam:format_2572
    outputSource: germline/bam
    secondaryFiles:
      - .bai
  recal:
    type: File
    outputSource: germline/recal
  gvcf_gz:
    type: File
    format: edam:format_3016
    outputSource: htslib_bgzip/gz_file
  gvcf_tbi:
    type: File
    format: edam:format_3700
    outputSource: bcftools_index/vcf_tbi
  log:
    type: File
    outputSource: germline/log
