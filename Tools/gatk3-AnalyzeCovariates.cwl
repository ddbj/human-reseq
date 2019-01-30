#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-AnalyzeCovariates-3.7.0
label: gatk3-AnalyzeCovariates-3.7.0
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk3:3.7-0'
    
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 63000

baseCommand: [ ln ]

inputs: 
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
  - id: bqsr_table_before
    type: File
    inputBinding:
      prefix: -before
      position: 24
  - id: bqsr_table_after
    type: File
    inputBinding:
      prefix: -after
      position: 25
    
outputs:
  - id: bqsr_pdf
    type: File
    outputBinding:
      glob: $(inputs.bqsr_table_after.basename).pdf
  - id: log
    type: stderr

stderr: $(inputs.bqsr_table_after.basename).pdf.log

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
    valueFrom: "mkdir"
  - position: 13
    prefix: -p
    valueFrom: "temp"
  - position: 14
    valueFrom: "&&"
  - position: 15
    valueFrom: "export"
  - position: 16
    prefix: "JAVA_TOOL_OPTIONS="
    valueFrom: "temp"
  - position: 17
    valueFrom: "&&"
  - position: 18
    valueFrom: "java"
  - position: 19
    valueFrom: "-Xmx3G"
  - position: 20
    valueFrom: "-jar"
  - position: 21
    valueFrom: "/usr/GenomeAnalysisTK.jar"
  - position: 22
    prefix: -T
    valueFrom: "AnalyzeCovariates"
  - position: 23
    prefix: -R
    valueFrom: "reference.fa"
  - position: 26
    prefix: -plots
    valueFrom: $(inputs.bqsr_table_after.basename).pdf
  - position: 27
    valueFrom: "&&"
  - position: 28
    valueFrom: "rm"
  - position: 29
    valueFrom: "reference.fa"
  - position: 30
    valueFrom: "reference.fa.fai"
  - position: 31
    valueFrom: "reference.dict"
  - position: 32
    valueFrom: "&&"
  - position: 33
    valueFrom: "rm"
  - position: 34
    prefix: -rf
    valueFrom: "temp"


