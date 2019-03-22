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
    ramMin: 6300

baseCommand: [ java, -Xmx3G, -jar, /usr/GenomeAnalysisTK.jar, -T, AnalyzeCovariates ]

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
  - id: bqsr_table_before
    type: File
    inputBinding:
      prefix: -before
      position: 2
  - id: bqsr_table_after
    type: File
    inputBinding:
      prefix: -after
      position: 3
    
outputs:
  - id: bqsr_pdf
    type: File
    outputBinding:
      glob: $(inputs.bqsr_table_after.basename).pdf
  - id: log
    type: stderr

stderr: $(inputs.bqsr_table_after.basename).pdf.log

arguments:
  - position: 4
    prefix: -plots
    valueFrom: $(inputs.bqsr_table_after.basename).pdf

