#!/usr/bin/env cwl-runner

class: CommandLineTool
id: picard-SortSam-2.10.6
label: picard-SortSam-2.10.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/picard:2.10.6--py27_0'

requirements:
  - class: ShellCommandRequirement

baseCommand: [ java, -jar, /usr/local/share/picard-2.10.6-0/picard.jar, SortSam ]

inputs:
  - id: sam
    type: File
    format: edam:format_2573
    inputBinding:
      prefix: "INPUT="
      position: 1
    doc: input SAM alignment file

outputs:
  - id: bam
    type: File
    format: edam:format_2572
    outputBinding:
      glob: output.bam

arguments:
  - position: 2
    valueFrom: "OUTPUT=output.bam"
  - position: 3
    valueFrom: "TMP_DIR=output.bam.s11.bwa_mem_align.temp"
  - position: 4
    valueFrom: "SORT_ORDER=coordinate"
  - position: 5
    valueFrom: "COMPRESSION_LEVEL=1"
  - position: 6
    valueFrom: "VALIDATION_STRINGENCY=LENIENT"
