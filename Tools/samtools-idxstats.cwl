#!/usr/bin/env cwl-runner

class: CommandLineTool
id: samtools-idxstats-1.6
label: samtools-idxstats-1.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/samtools:1.6--0'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 4000

baseCommand: [ ln, -s ]

inputs:
  - id: in_bam
    type: File
    format: edam:format_2572
    inputBinding:
      position: 1
    doc: input BAM alignment file
  - id: in_bai
    type: File
    inputBinding:
      prefix: -s
      position: 5
    doc: index for input BAM alignment file

outputs:
  - id: idxstats
    type: stdout

stdout: $(inputs.in_bam.basename).idxstats

arguments:
  - position: 2
    valueFrom: $(inputs.in_bam.basename)
  - position: 3
    valueFrom: "&&"
  - position: 4
    valueFrom: "ln"
  - position: 6
    valueFrom: $(inputs.in_bam.basename).bai
  - position: 7
    valueFrom: "&&"
  - position: 8
    valueFrom: "samtools"
  - position: 9
    valueFrom: "idxstats"
  - position: 10
    valueFrom: $(inputs.in_bam.basename)
  - position: 11
    valueFrom: "&&"
  - position: 12
    valueFrom: "rm"
  - position: 13
    valueFrom: $(inputs.in_bam.basename)
  - position: 14
    valueFrom: $(inputs.in_bam.basename).bai

