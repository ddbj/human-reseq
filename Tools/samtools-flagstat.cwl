#!/usr/bin/env cwl-runner

class: CommandLineTool
id: samtools-flagstat-1.6
label: samtools-flagstat-1.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/samtools:1.6--0'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    coresMin: 4

baseCommand: [ samtools, flagstat ]

inputs:
  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: --threads
      position: 1
  - id: marked.bam
    type: File
    format: edam:format_2572
    inputBinding:
      position: 2
    doc: input BAM alignment file

outputs:
  - id: flagstat
    type: stdout

stdout: output.marked.bam.flagstat

arguments: []
