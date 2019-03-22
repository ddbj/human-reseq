#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-PrintReads-3.7.0
label: gatk3-PrintReads-3.7.0
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

baseCommand: [ java, -Xmx98G, -jar, /usr/GenomeAnalysisTK.jar, -T, PrintReads ]

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
      prefix: -nct
      position: 2
    doc: number of cpu cores to be used
  - id: in_bam
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: -I
      position: 3
    doc: input BAM alignment file
    secondaryFiles:
      - ^.bai
  - id: bqsr_table_before
    type: File
    inputBinding:
      prefix: -BQSR
      position: 5
  - id: outprefix
    type: string
    
outputs:
  - id: out_bam
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.outprefix).bam
    secondaryFiles:
      - ^.bai
  - id: log
    type: stderr

stderr: $(inputs.outprefix).bam.log

arguments:
  - position: 4
    prefix: -o
    valueFrom: $(inputs.outprefix).bam


