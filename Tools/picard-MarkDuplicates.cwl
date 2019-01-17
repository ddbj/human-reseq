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
    ramMin: 48000

baseCommand: [ java, -Xmx48G, -jar, /usr/local/share/picard-2.10.6-0/picard.jar, MarkDuplicates ]

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
      glob: $(inputs.experimentID).marked.bam
  - id: marked.bai
    type: File
    outputBinding:
      glob: $(inputs.experimentID).marked.bai
  - id: marked.bam.stats
    type: File
    outputBinding:
      glob: $(inputs.experimentID).marked.bam.stats

arguments:
  - position: 2
    valueFrom: "OUTPUT=$(inputs.experimentID).marked.bam"
  - position: 3
    valueFrom: "METRICS_FILE=$(inputs.experimentID).marked.bam.stats"
  - position: 4
    valueFrom: "TMP_DIR=$(inputs.experimentID).s12.rmdup.temp"
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
