#!/usr/bin/env cwl-runner

class: CommandLineTool
id: picard-CreateSequenceDictionary-2.10.6
label: picard-CreateSequenceDictionary-2.10.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/picard:2.10.6--py27_0'

requirements:
  - class: ShellCommandRequirement

baseCommand: [ java, -jar, /usr/local/share/picard-2.10.6-0/picard.jar, CreateSequenceDictionary ]

inputs:
  - id: fa
    type: File
    format: edam:format_1929
    inputBinding:
      prefix: "R="
      position: 1
    doc: FastA file for reference genome

outputs:
  - id: dict
    type: File
    outputBinding:
      glob: $(inputs.fa.basename).dict

arguments:
  - position: 2
    valueFrom: "O=$(inputs.fa.basename).dict"
