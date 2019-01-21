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

baseCommand: [ samtools, view ]

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
  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: --threads
      position: 1
  - id: marked_bam
    type: File
    format: edam:format_2572
    inputBinding:
      position: 3
    doc: input BAM alignment file

outputs:
  - id: chrXY_fastq
    type: stdout
    format: edam:format_1930

stdout: $(inputs.experimentID).chrXY.interleaved.fastq.gz

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


