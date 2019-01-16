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

baseCommand: [ bwa, mem ]

inputs:
  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: -t
      position: 1
    doc: number of cpu cores to be used
  - id: experimentID
    type: string
    doc: experiment ID for input FastQ file
  - id: sampleID
    type: string
    doc: sample ID for input FastQ file
  - id: centerID
    type: string
    doc: sequencing center ID for input FastQ file
  - id: fadir
    type: Directory
    doc: directory containing FastA file and index
  - id: ref
    type: string
    doc: name of reference (e.g., hs37d5)
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

outputs:
  - id: sam
    type: stdout
    format: edam:format_2573

stdout: output.sam

arguments:
  - position: 2
    prefix: -K
    valueFrom: "10000000"
  - position: 3
    prefix: "-R"
    valueFrom: "@RG\tID:$(inputs.experimentID)\tPL:ILLUMINA\tPU:$(inputs.experimentID)\tLB:$(inputs.centerID)\tSM:$(inputs.sampleID)"
  - position: 4
    valueFrom: $(inputs.fadir.path)/$(inputs.ref).fa
