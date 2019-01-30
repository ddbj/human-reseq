#!/usr/bin/env cwl-runner

class: CommandLineTool
id: samtools-extract-chrXY+unmap-1.6
label: samtools-extract-chrXY+unmap-1.6
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

baseCommand: [ samtools, view ]

inputs:
  - id: nthreads
    type: int
    inputBinding:
      prefix: --threads
      position: 1
  - id: in_bam
    type: File
    format: edam:format_2572
    inputBinding:
      position: 3
    doc: input BAM alignment file
  - id: outprefix
    type: string

outputs:
  - id: chrXY_fastq
    type: stdout
    format: edam:format_1930

stdout: $(inputs.outprefix).chrXY.interleaved.fastq.gz

arguments:
  - position: 2
    valueFrom: "-f1"
  - position: 4
    valueFrom: "|"
  - position: 5
    valueFrom: "awk"
  - position: 6
    valueFrom: "{if ( ($3 == \"*\" && $7 == \"*\") || $3 == \"X\" || $3 == \"Y\" || $7 == \"X\" || $7 == \"Y\"){ print \"@\"$1; print $10; print \"+\"; print $11 } }"
  - position: 7
    valueFrom: "|"
  - position: 8
    valueFrom: "gzip"
  - position: 9
    valueFrom: "-c"


