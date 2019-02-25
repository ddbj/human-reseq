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
    ramMin: 32000

baseCommand: [ java, -Xmx24G, -jar, /usr/local/share/picard-2.10.6-0/picard.jar, MarkDuplicates ]

inputs:
  - id: bam_file
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: "INPUT="
      position: 1
    doc: input BAM alignment file (should be sorted)
  - id: outprefix
    type: string

outputs:
  - id: out_bam
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.outprefix).bam
  - id: out_bai
    type: File
    outputBinding:
      glob: $(inputs.outprefix).bai
  - id: out_metrics
    type: File
    outputBinding:
      glob: $(inputs.outprefix).bam.metrics
  - id: log
    type: stderr

stderr: $(inputs.outprefix).bam.log
    
arguments:
  - position: 2
    valueFrom: "OUTPUT=$(inputs.outprefix).bam"
  - position: 3
    valueFrom: "METRICS_FILE=$(inputs.outprefix).bam.metrics"
  - position: 4
    valueFrom: "TMP_DIR=$(inputs.outprefix).temp"
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
  - position: 10
    valueFrom: "&&"
  - position: 11
    valueFrom: "rm"
  - position: 12
    prefix: -rf
    valueFrom: $(inputs.outprefix).temp
