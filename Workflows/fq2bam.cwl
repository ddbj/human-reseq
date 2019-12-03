#!/usr/bin/env cwl-runner

class: Workflow
id: fq2bam
label: fq2bam
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
  fqs:
    type:
      type: array
      items:
        type: array
        items: File
    format: edam:format_1930
    doc: FastQ file from next-generation sequencers

steps:
  parabricks-fq2bam:
    label: parabricks-fq2bam
    run: ../Tools/parabricks-fq2bam.cwl
    in:
      reference: reference
      RG_ID: RG_ID
      RG_PL: RG_PL
      RG_PU: RG_PU
      RG_LB: RG_LB
      RG_SM: RG_SM
      fqs: fqs
    out:
      [bam, log]

outputs:
  bam:
    type: File
    format: edam:format_2572
    outputSource: parabricks-fq2bam/bam
  log:
    type: File
    outputSource: parabricks-fq2bam/log

