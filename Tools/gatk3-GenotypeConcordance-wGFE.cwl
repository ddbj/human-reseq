#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-GenotypeConcordance-wGFE-3.7.0
label: gatk3-GenotypeConcordance-wGFE-3.7.0
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

baseCommand: [ java, -Xmx98G, -jar, /usr/GenomeAnalysisTK.jar, -T, GenotypeConcordance ]

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
  - id: eval_vcf
    type: File
    format: edam:format_3016
    inputBinding:
      position: 2
      prefix: -eval
    doc: input VCF file (eval)
    secondaryFiles:
      - .tbi
  - id: comp_vcf
    type: File
    format: edam:format_3016
    inputBinding:
      position: 3
      prefix: -comp
    doc: input VCF file (comp)
    secondaryFiles:
      - .tbi
  - id: eval_filter
    type: string
    inputBinding:
      position: 4
      prefix: -gfe
  - id: outprefix
    type: string
    
outputs:
  - id: result
    type: File
    outputBinding: 
      glob: $(inputs.outprefix).GenotypeConcordance
  - id: log
    type: stderr

stderr: $(inputs.outprefix).GenotypeConcordance.log

arguments:
  - position: 5
    prefix: -o
    valueFrom: $(inputs.outprefix).GenotypeConcordance
