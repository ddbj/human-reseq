#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk4-AnalyzeCovariates-4.1.4.1
label: gatk4-AnalyzeCovariates-4.1.4.1
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: broadinstitute/gatk:4.1.4.1
    
baseCommand: [ gatk, AnalyzeCovariates ]

inputs: 
  - id: bqsr_table_before
    type: File
    inputBinding:
      prefix: -before
      position: 1
  - id: bqsr_table_after
    type: File
    inputBinding:
      prefix: -after
      position: 2
    
outputs:
  - id: bqsr_pdf
    type: File
    outputBinding:
      glob: $(inputs.bqsr_table_after.basename).pdf
  - id: log
    type: stderr

stderr: $(inputs.bqsr_table_after.basename).pdf.log

arguments:
  - position: 3
    prefix: -plots
    valueFrom: $(inputs.bqsr_table_after.basename).pdf
