#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-index-1.6
label: bcftools-index-1.6
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/bcftools:1.6--0'
    
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6300

baseCommand: [ bcftools, index ]

inputs:
  - id: vcf
    type: File
    format: edam:format_3016
    inputBinding:
      position: 3
    doc: input VCF file
  - id: nthreads
    type: int
    inputBinding:
      prefix: --threads
      position: 1
    doc: number of cpu cores to be used

outputs:
  - id: vcf_tbi
    type: File
    outputBinding:
      glob: $(inputs.vcf.basename).tbi

arguments:
  - position: 2
    prefix: -o
    valueFrom: $(inputs.vcf.basename).tbi


