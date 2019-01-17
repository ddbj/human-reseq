#!/usr/bin/env cwl-runner

class: CommandLineTool
id: samtools-faidx-1.6
label: samtools-faidx-1.6
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
  - id: fa
    type: File
    format: edam:format_1929
    inputBinding:
      position: 1
    doc: FastA file for reference genome

outputs:
  - id: fai
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).fai

arguments:
  - position: 2
    valueFrom: $(inputs.fa.basename)
  - position: 3
    valueFrom: "&&"
  - position: 4
    valueFrom: "samtools"
  - position: 5
    valueFrom: "faidx"
  - position: 6
    valueFrom: $(inputs.fa.basename)


