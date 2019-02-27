#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-GenotypeConcordance-3.7.0
label: gatk3-GenotypeConcordance-3.7.0
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

baseCommand: [ ln ]

inputs: 
  - id: eval_vcf
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: -s
      position: 13
    doc: input VCF file (eval)
  - id: eval_vcf_tbi
    type: File
    inputBinding: 
      prefix: -s
      position: 17
    doc: index for input VCF file (eval)
  - id: comp_vcf
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: -s
      position: 21
    doc: input VCF file (comp)
  - id: comp_vcf_tbi
    type: File
    inputBinding: 
      prefix: -s
      position: 25
    doc: index for input VCF file (eval)
  - id: reference
    type: File
    format: edam:format_1929
    inputBinding:
      position: 1
      prefix: -s
    doc: FastA file for reference genome
  - id: reference_fai
    type: File
    inputBinding:
      position: 5
      prefix: -s
    doc: FAI index file for reference genome
  - id: reference_dict
    type: File
    inputBinding:
      position: 9
      prefix: -s
    doc: DICT index file for reference genome
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
  - position: 2
    valueFrom: "reference.fa"
  - position: 3
    valueFrom: "&&"
  - position: 4
    valueFrom: "ln"
  - position: 6
    valueFrom: "reference.fa.fai"
  - position: 7
    valueFrom: "&&"
  - position: 8
    valueFrom: "ln"
  - position: 10
    valueFrom: "reference.dict"
  - position: 11
    valueFrom: "&&"
  - position: 12
    valueFrom: "ln"
  - position: 14
    valueFrom: "eval.vcf.gz"
  - position: 15
    valueFrom: "&&"
  - position: 16
    valueFrom: "ln"
  - position: 18
    valueFrom: "eval.vcf.gz.tbi"
  - position: 19
    valueFrom: "&&"
  - position: 20
    valueFrom: "ln"
  - position: 22
    valueFrom: "comp.vcf.gz"
  - position: 23
    valueFrom: "&&"
  - position: 24
    valueFrom: "ln"
  - position: 26
    valueFrom: "comp.vcf.gz.tbi"
  - position: 27
    valueFrom: "&&"
  - position: 28
    valueFrom: "mkdir"
  - position: 29
    prefix: -p
    valueFrom: "temp"
  - position: 30
    valueFrom: "&&"
  - position: 31
    valueFrom: "export"
  - position: 32
    prefix: "JAVA_TOOL_OPTIONS="
    valueFrom: "temp"
  - position: 33
    valueFrom: "&&"
  - position: 34
    valueFrom: "java"
  - position: 35
    valueFrom: "-Xmx98G"
  - position: 36
    valueFrom: "-jar"
  - position: 37
    valueFrom: "/usr/GenomeAnalysisTK.jar"
  - position: 38
    prefix: -T
    valueFrom: "GenotypeConcordance"
  - position: 40
    prefix: -R
    valueFrom: "reference.fa"
  - position: 41
    prefix: -eval
    valueFrom: "eval.vcf.gz"
  - position: 42
    prefix: -comp
    valueFrom: "comp.vcf.gz"
  - position: 43
    prefix: -o
    valueFrom: $(inputs.outprefix).GenotypeConcordance
  - position: 44
    valueFrom: "&&"
  - position: 45
    valueFrom: "rm"
  - position: 46
    valueFrom: "reference.fa"
  - position: 47
    valueFrom: "reference.fa.fai"
  - position: 48
    valueFrom: "reference.dict"
  - position: 49
    valueFrom: "eval.vcf.gz"
  - position: 50
    valueFrom: "eval.vcf.gz.tbi"
  - position: 51
    valueFrom: "comp.vcf.gz"
  - position: 52
    valueFrom: "comp.vcf.gz.tbi"
  - position: 53
    valueFrom: "&&"
  - position: 54
    valueFrom: "rm"
  - position: 55
    prefix: -rf
    valueFrom: "temp"


