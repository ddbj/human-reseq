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

baseCommand: [ ln, -s ]

inputs:
  - id: vcf
    type: File
    format: edam:format_3016
    inputBinding:
      position: 1
    doc: input VCF file
  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: --threads
      position: 6
    doc: number of cpu cores to be used

outputs:
  - id: vcf_tbi
    type: File
    outputBinding:
      glob: $(inputs.vcf.basename).tbi

arguments:
  - position: 2
    valueFrom: $(inputs.vcf.basename)
  - position: 3
    valueFrom: "&&"
  - position: 4
    valueFrom: "bcftools"
  - position: 5
    valueFrom: "index"
  - position: 7
    prefix: --tbi
    valueFrom: $(inputs.vcf.basename)
  - position: 8
    valueFrom: "&&"
  - position: 9
    valueFrom: "rm"
  - position: 10
    valueFrom: $(inputs.vcf.basename)


