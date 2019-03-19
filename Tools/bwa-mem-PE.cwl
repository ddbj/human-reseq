#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bwa-mem-PE-0.7.12
label: bwa-mem-PE-0.7.12
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'biocontainers/bwa:v0.7.12_cv3'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6300
    
baseCommand: [ bwa, mem ]

inputs:
  - id: reference
    type: File
    format: edam:format_1929
    inputBinding:
      position: 4
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
  - id: fq1
    type: File
    format: edam:format_1930
    inputBinding:
      position: 5
    doc: FastQ file from next-generation sequencers
  - id: fq2
    type: File
    format: edam:format_1930
    inputBinding:
      position: 6
    doc: FastQ file from next-generation sequencers
  - id: nthreads
    type: int
    inputBinding:
      prefix: -t
      position: 3
    doc: number of cpu cores to be used
  - id: outprefix
    type: string

outputs:
  - id: sam
    type: stdout
    format: edam:format_2573
  - id: log
    type: stderr

stdout: $(inputs.outprefix).sam
stderr: $(inputs.outprefix).sam.log
    
arguments:
  - position: 1
    prefix: -K
    valueFrom: "10000000"
  - position: 2
    prefix: -R
    valueFrom: "@RG\tID:$(inputs.RG_ID)\tPL:$(inputs.RG_PL)\tPU:$(inputs.RG_PU)\tLB:$(inputs.RG_LB)\tSM:$(inputs.RG_SM)"


