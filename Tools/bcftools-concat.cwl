#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-concat-1.6
label: bcftools-concat-1.6
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

baseCommand: [ bcftools, concat ]

inputs:
  - id: vcf_files
    type: File[]
    format: edam:format_3016
    inputBinding:
      position: 4
    doc: input VCF file(s)
  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: --threads
      position: 1
    doc: number of cpu cores to be used
  - id: outprefix
    type: string

outputs:
  - id: after_vcf
    type: File
    format: edam:format_3016
    outputBinding:
      glob: $(inputs.outprefix).g.vcf.gz

arguments:
  - position: 2
    valueFrom: "-Oz"
  - position: 3
    prefix: -o 
    valueFrom: $(inputs.outprefix).g.vcf.gz


