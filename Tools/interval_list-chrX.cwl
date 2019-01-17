#!/usr/bin/env cwl-runner

class: CommandLineTool
id: interval_list-autosomal-14.04
label: interval_list-autosomal-14.04
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/refgenomics/docker-ubuntu:14.04'

requirements:
  - class: ShellCommandRequirement

baseCommand: [ awk ]

inputs:
  - id: reference
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome
  - id: reference_fai
    type: File
    inputBinding:
      position: 2
    doc: FAI index file for reference genome
  - id: reference_dict
    type: File
    inputBinding:
      position: 5
    doc: DICT index file for reference genome

outputs:
  - id: chrX_interval_list
    type: File
    outputBinding:
      glob: $(inputs.reference.basename).chrX.interval_list

arguments:
  - position: 1
    valueFrom: "{if ($1 == \"X\") print $1\"\t1\t\"$2\"\t+\t\"$1}"
  - position: 3
    valueFrom: "|"
  - position: 4
    valueFrom: "cat"
  - position: 6
    valueFrom: "-"
  - position: 7
    valueFrom: ">"
  - position: 8
    valueFrom: $(inputs.reference.basename).chrX.interval_list
