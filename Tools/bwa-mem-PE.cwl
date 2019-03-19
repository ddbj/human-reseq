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
    
baseCommand: [ ln, -s ]

inputs:
  - id: reference
    type: File
    format: edam:format_1929
    inputBinding:
      position: 1
    doc: FastA file for reference genome
  - id: reference_amb
    type: File
    inputBinding:
      prefix: -s
      position: 5
    doc: AMB index file for reference genome
  - id: reference_ann
    type: File
    inputBinding:
      prefix: -s
      position: 9
    doc: ANN index file for reference genome
  - id: reference_bwt
    type: File
    inputBinding:
      prefix: -s
      position: 13
    doc: BWT index file for reference genome
  - id: reference_pac
    type: File
    inputBinding:
      prefix: -s
      position: 17
    doc: PAC index file for reference genome
  - id: reference_sa
    type: File
    inputBinding:
      prefix: -s
      position: 21
    doc: SA index file for reference genome
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
      position: 30
    doc: FastQ file from next-generation sequencers
  - id: fq2
    type: File
    format: edam:format_1930
    inputBinding:
      position: 31
    doc: FastQ file from next-generation sequencers
  - id: nthreads
    type: int
    inputBinding:
      prefix: -t
      position: 26
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
  - position: 2
    valueFrom: $(inputs.reference.basename)
  - position: 3
    valueFrom: "&&"
  - position: 4
    valueFrom : "ln"
  - position: 6
    valueFrom: $(inputs.reference.basename).amb
  - position: 7
    valueFrom: "&&"
  - position: 8
    valueFrom : "ln"
  - position: 10
    valueFrom: $(inputs.reference.basename).ann
  - position: 11
    valueFrom: "&&"
  - position: 12
    valueFrom : "ln"
  - position: 14
    valueFrom: $(inputs.reference.basename).bwt
  - position: 15
    valueFrom: "&&"
  - position: 16
    valueFrom : "ln"
  - position: 18
    valueFrom: $(inputs.reference.basename).pac
  - position: 19
    valueFrom: "&&"
  - position: 20
    valueFrom : "ln"
  - position: 22
    valueFrom: $(inputs.reference.basename).sa
  - position: 23
    valueFrom: "&&"
  - position: 24
    valueFrom: "bwa"
  - position: 25
    valueFrom: "mem"
  - position: 27
    prefix: -K
    valueFrom: "10000000"
  - position: 28
    prefix: -R
    valueFrom: "@RG\tID:$(inputs.RG_ID)\tPL:$(inputs.RG_PL)\tPU:$(inputs.RG_PU)\tLB:$(inputs.RG_LB)\tSM:$(inputs.RG_SM)"
  - position: 29
    valueFrom: $(inputs.reference.basename)
  - position: 32
    valueFrom: "&&"
  - position: 33
    valueFrom: "rm"
  - position: 34
    valueFrom: $(inputs.reference.basename)
  - position: 35
    valueFrom: $(inputs.reference.basename).amb
  - position: 36
    valueFrom: $(inputs.reference.basename).ann
  - position: 37
    valueFrom: $(inputs.reference.basename).bwt
  - position: 38
    valueFrom: $(inputs.reference.basename).pac
  - position: 39
    valueFrom: $(inputs.reference.basename).sa
