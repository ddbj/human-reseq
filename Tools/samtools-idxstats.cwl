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

baseCommand: [ ln, -s ]

inputs:
  - id: experimentID
    type: string
    doc: experiment ID for input FastQ file
  - id: sampleID
    type: string
    doc: sample ID for input FastQ file
  - id: centerID
    type: string
    doc: sequencing center ID for input FastQ file
  - id: marked_bam
    type: File
    format: edam:format_2572
    inputBinding:
      position: 1
    doc: input BAM alignment file
  - id: marked_bai
    type: File
    doc: index for input BAM alignment file

outputs:
  - id: idxstats
    type: stdout

stdout: $(inputs.experimentID).marked.bam.idxstats

arguments:
  - position: 2
    valueFrom: $(inputs.marked_bam.basename)
  - position: 3
    valueFrom: "&&"
  - position: 4
    valueFrom: "ln"
  - position: 5
    prefix: -s
    valueFrom: $(inputs.marked_bai.path)
  - position: 6
    valueFrom: $(inputs.marked_bam.basename).bai
  - position: 7
    valueFrom: "&&"
  - position: 8
    valueFrom: "samtools"
  - position: 9
    valueFrom: "idxstats"
  - position: 10
    valueFrom: $(inputs.marked_bam.basename)

