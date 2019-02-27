#!/usr/bin/env cwl-runner

class: CommandLineTool
id: htslib-bgzip-1.9--h47928c2_5
label: htslib-bgzip-1.9--h47928c2_5
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/htslib:1.9--h47928c2_5'
    
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6300

baseCommand: [ bgzip ]

inputs:
  - id: in_file
    type: File
    inputBinding:
      prefix: -c
      position: 1
    doc: input file

outputs:
  - id: gz_file
    type: stdout

stdout: $(inputs.in_file.basename).gz
    
arguments: []

