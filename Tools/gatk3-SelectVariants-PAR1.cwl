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
  - id: vcf
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: -V
      position: 2
    doc: input VCF file
    secondaryFiles:
      - .tbi
  - id: nthreads
    type: int
    inputBinding:
      prefix: -nt
      position: 3
    doc: number of cpu cores to be used
  - id: outprefix
    type: string
    
outputs:
  - id: out_vcf
    type: File
    format: edam:format_3016
    outputBinding: 
      glob: $(inputs.outprefix).chrX_PAR1.g.vcf.gz
    secondaryFiles:
      - .tbi
  - id: log
    type: stderr

stderr: $(inputs.outprefix).chrX_PAR1.g.vcf.gz.log

arguments:
  - position: 4
    prefix: -L
    valueFrom: "X:60001-2699520"
  - position: 5
    prefix: -o
    valueFrom: $(inputs.outprefix).chrX_PAR1.g.vcf.gz


