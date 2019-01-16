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

baseCommand: [ samtools, idxstats ]

inputs:
  - id: inputDir
    type: Directory
    doc: directory containing input BAM alignment file

outputs:
  - id: idxstats
    type: stdout

stdout: output.marked.bam.idxstats

arguments:
  - position: 1
    valueFrom: $(inputs.inputDir.path)/output.marked.bam
