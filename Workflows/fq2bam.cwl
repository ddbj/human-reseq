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
  fqs:
    type:
      type: array
      items:
        type: record
        fields:
          - name: fq1
            type: File # seems file format cannot be specified
          - name: fq2
            type: File # seems file format cannot be specified
          - name: read_group
            type:
              - type: record
                fields:
                  - name: RG_ID
                    type: string
                    doc: Read group identifier (ID) in RG line
                  - name: RG_PL
                    type: string
                    doc: Platform/technology used to produce the read (PL) in RG line
                  - name: RG_PU
                    type: string
                    doc: Platform Unit (PU) in RG line
                  - name: RG_LB
                    type: string
                    doc: DNA preparation library identifier (LB) in RG line
                  - name: RG_SM
                    type: string
                    doc: Sample (SM) identifier in RG line
    doc: FastQ file from next-generation sequencers

steps:
  parabricks-fq2bam:
    label: parabricks-fq2bam
    run: ../Tools/parabricks-fq2bam.cwl
    in:
      reference: reference
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

