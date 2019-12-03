#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-fq2bam
label: parabricks-fq2bam
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

#requirements:
#  - class: ShellCommandRequirement
#  - class: ResourceRequirement
#    ramMin: 6300

baseCommand: [ /opt/pkg/parabricks/pbrun, fq2bam ]

inputs:
  - id: reference
    type: File
    format: edam:format_1929
    inputBinding:
      position: 1
      prefix: --ref
    doc: FastA file for reference genome
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  - id: RG_ID
    type: string
    doc: Read group identifier (ID) in RG line
  - id: RG_PL
    type: string
    doc: Platform/technology used to produce the read (PL) in RG line
  - id: RG_PU
    type: string
    doc: Platform Unit (PU) in RG line
  - id: RG_LB
    type: string
    doc: DNA preparation library identifier (LB) in RG line
  - id: RG_SM
    type: string
    doc: Sample (SM) identifier in RG line
  - id: fqs
    type:
      type: array
      items:
        type: array
        items: File
      inputBinding:
        prefix: --in-fq
    format: edam:format_1930
    doc: FastQ file from next-generation sequencers
    inputBinding:
      position: 2

outputs:
  - id: bam
    type: File
    format: edam:format_2572
    outputBinding: 
      glob: markdups.bam
    secondaryFiles:
      - .bai
  - id: log
    type: stderr

stderr: fq2bam.log

arguments:
  - position: 3
    prefix: --out_bam
    valueFrom: markdups.bam

    
#arguments:
#  - position: 1
#    prefix: -K
#    valueFrom: "10000000"
#  - position: 2
#    prefix: -R
#    valueFrom: "@RG\tID:$(inputs.RG_ID)\tPL:$(inputs.RG_PL)\tPU:$(inputs.RG_PU)\tLB:$(inputs.RG_LB)\tSM:$(inputs.RG_SM)"
#
#
