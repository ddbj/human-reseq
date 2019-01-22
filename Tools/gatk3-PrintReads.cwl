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
    ramMin: 98000

baseCommand: [ ln ]

inputs: 
  - id: experimentID
    type: string
    doc: experiment ID for input FastQ file
  - id: sampleID
    type: string
    doc: sample ID for input FastQ file
  - id: centerID
    type: string
    doc: sequencing center ID for input FastQ file
  - id: marked_bam
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: -s
      position: 13
    doc: input BAM alignment file
  - id: marked_bai
    type: File
    inputBinding: 
      prefix: -s
      position: 17
    doc: index for input BAM alignment file
  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: -nct
      position: 31
    doc: number of cpu cores to be used
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
      prefix: -BQSR
      position: 35
    
outputs:
  - id: marked_bqsr_bam
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.experimentID).marked.bqsr.bam
  - id: marked_bqsr_bai
    type: File
    outputBinding:
      glob: $(inputs.experimentID).marked.bqsr.bai
  - id: marked_bqsr_bam_log
    type: stderr

stderr: $(inputs.experimentID).marked.bqsr.bam.log

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
    valueFrom: "reads.bam"
  - position: 15
    valueFrom: "&&"
  - position: 16
    valueFrom: "ln"
  - position: 18
    valueFrom: "reads.bam.bai"
  - position: 19
    valueFrom: "&&"
  - position: 20
    valueFrom: "mkdir"
  - position: 21
    prefix: -p
    valueFrom: "temp"
  - position: 22
    valueFrom: "&&"
  - position: 23
    valueFrom: "export"
  - position: 24
    prefix: "JAVA_TOOL_OPTIONS="
    valueFrom: "temp"
  - position: 25
    valueFrom: "&&"
  - position: 26
    valueFrom: "java"
  - position: 27
    valueFrom: "-Xmx98G"
  - position: 28
    valueFrom: "-jar"
  - position: 29
    valueFrom: "/usr/GenomeAnalysisTK.jar"
  - position: 30
    prefix: -T
    valueFrom: "PrintReads"
  - position: 32
    prefix: -R
    valueFrom: "reference.fa"
  - position: 33
    prefix: -I
    valueFrom: "reads.bam"
  - position: 34
    prefix: -o
    valueFrom: $(inputs.experimentID).marked.bqsr.bam
  - position: 36
    valueFrom: "&&"
  - position: 37
    valueFrom: "rm"
  - position: 38
    valueFrom: "reference.fa"
  - position: 39
    valueFrom: "reference.fa.fai"
  - position: 40
    valueFrom: "reference.dict"
  - position: 41
    valueFrom: "reads.bam"
  - position: 42
    valueFrom: "reads.bam.bai"
  - position: 43
    valueFrom: "&&"
  - position: 44
    valueFrom: "rm"
  - position: 45
    prefix: -rf
    valueFrom: "temp"


