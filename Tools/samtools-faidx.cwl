#!/usr/bin/env cwl-runner

class: CommandLineTool
id: samtools-faidx-1.6
label: samtools-faidx-1.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/samtools:1.6--0'
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.fadir)
        writable: true
    
requirements:
  - class: ShellCommandRequirement

baseCommand: [ samtools, faidx ]

inputs:
  - id: fadir
    type: Directory
    doc: directory containing FastA file and index
  - id: ref
    type: string
    doc: name of reference (e.g., hs37d5)

outputs:
  - id: fai
    type: File
    outputBinding:
      glob: $(inputs.fadir.basename)/$(inputs.ref).fa.fai

arguments:
  - position: 1
    valueFrom: $(inputs.fadir.path)/$(inputs.ref).fa

