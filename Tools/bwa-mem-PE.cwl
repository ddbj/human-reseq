#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bwa-mem-PE-0.7.12
label: bwa-mem-PE-0.7.12
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/ucsc_cgl/bwa:0.7.12'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    coresMin: 4
    
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
  - id: experimentID
    type: string
    doc: experiment ID for input FastQ file
  - id: sampleID
    type: string
    doc: sample ID for input FastQ file
  - id: centerID
    type: string
    doc: sequencing center ID for input FastQ file
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
    default: 4
    inputBinding:
      prefix: -t
      position: 26
    doc: number of cpu cores to be used

outputs:
  - id: sam
    type: stdout
    format: edam:format_2573
  - id: sam_log
    type: stderr

stdout: $(inputs.experimentID).sam
stderr: $(inputs.experimentID).sam.log
    
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
    valueFrom: "@RG\tID:$(inputs.experimentID)\tPL:ILLUMINA\tPU:$(inputs.experimentID)\tLB:$(inputs.centerID)\tSM:$(inputs.sampleID)"
  - position: 29
    valueFrom: $(inputs.reference.basename)
