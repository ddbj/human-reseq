#!/usr/bin/env cwl-runner

class: CommandLineTool
id: picard-MarkDuplicates-2.10.6
label: picard-MarkDuplicates-2.10.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/picard:2.10.6--py27_0'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 8000

baseCommand: [ java, -Xmx8G, -jar, /usr/local/share/picard-2.10.6-0/picard.jar, MarkDuplicates ]

inputs:
  - id: bam
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: "INPUT="
      position: 1
    doc: input BAM alignment file (should be sorted)

outputs:
  - id: marked.bam
    type: File
    format: edam:format_2572
    outputBinding:
      glob: output.marked.bam
  - id: marked.bai
    type: File
    outputBinding:
      glob: output.marked.bai
  - id: marked.bam.stats
    type: File
    outputBinding:
      glob: output.marked.bam.stats

arguments:
  - position: 2
    valueFrom: "OUTPUT=output.marked.bam"
  - position: 3
    valueFrom: "METRICS_FILE=output.marked.bam.stats"
  - position: 4
    valueFrom: "TMP_DIR=output.s12.rmdup.temp"
  - position: 5
    valueFrom: "COMPRESSION_LEVEL=9"
  - position: 6
    valueFrom: "CREATE_INDEX=true"
  - position: 7
    valueFrom: "ASSUME_SORTED=true"
  - position: 8
    valueFrom: "REMOVE_DUPLICATES=true"
  - position: 9
    valueFrom: "VALIDATION_STRINGENCY=LENIENT"
