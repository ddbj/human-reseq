#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bwa-mem-index-0.7.12
label: bwa-mem-index-0.7.12
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/ucsc_cgl/bwa:0.7.12'
    
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6300

baseCommand: [ bwa, index ]

inputs:
  - id: fa
    type: File
    format: edam:format_1929
    inputBinding:
      position: 2
    doc: FastA file for reference genome

outputs:
  - id: amb
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).amb
  - id: ann
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).ann
  - id: bwt
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).bwt
  - id: pac
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).pac
  - id: sa
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).sa
  - id: log
    type: stderr

stderr: $(inputs.fa.basename).bwa-index.log

arguments:
  - position: 1
    prefix: -p
    valueFrom: $(inputs.fa.basename)

