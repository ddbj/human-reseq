#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-SelectVariants-3.7.0
label: gatk3-SelectVariants-3.7.0
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk3:3.7-0'
    
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6300

baseCommand: [ java, -Xmx98G, -jar, /usr/GenomeAnalysisTK.jar, -T, SelectVariants ]

inputs: 
  - id: reference
    type: File
    format: edam:format_1929
    inputBinding:
      position: 1
      prefix: -R
    doc: FastA file for reference genome
    secondaryFiles:
      - .fai
      - ^.dict
  - id: nthreads
    type: int
    inputBinding:
      prefix: -nt
      position: 2
    doc: number of cpu cores to be used
  - id: vcf
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: -V
      position: 3
    doc: input VCF file
    secondaryFiles:
      - .tbi
  - id: regionSpan
    type: string
    inputBinding:
      position: 4
      prefix: -L
  - id: outprefix
    type: string
    
outputs:
  - id: vcf
    type: File
    format: edam:format_3016
    outputBinding: 
      glob: $(inputs.outprefix).g.vcf.gz
    secondaryFiles:
      - .tbi
  - id: log
    type: stderr

stderr: $(inputs.outprefix).g.vcf.gz.log

arguments:
  - position: 5
    prefix: -o
    valueFrom: $(inputs.outprefix).g.vcf.gz

