#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-BaseRecalibrator-before-3.7.0
label: gatk3-BaseRecalibrator-before-3.7.0
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
  - id: in_bam
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: -s
      position: 37
    doc: input BAM alignment file
  - id: in_bai
    type: File
    inputBinding: 
      prefix: -s
      position: 41
    doc: index for input BAM alignment file
  - id: nthreads
    type: int
    inputBinding:
      prefix: -nct
      position: 55
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
  - id: dbsnp
    type: File
    inputBinding:
      prefix: -s
      position: 13
  - id: dbsnp_idx
    type: File
    inputBinding:
      prefix: -s
      position: 17
  - id: mills_indel
    type: File
    inputBinding:
      prefix: -s
      position: 21
  - id: mills_indel_idx
    type: File
    inputBinding:
      prefix: -s
      position: 25
  - id: onek_indel
    type: File
    inputBinding:
      prefix: -s
      position: 29
  - id: onek_indel_idx
    type: File
    inputBinding:
      prefix: -s
      position: 33
    
outputs:
  - id: bqsr_table_before
    type: File
    outputBinding:
      glob: $(inputs.in_bam.basename).bqsr_before.table
  - id: log
    type: stderr

stderr: $(inputs.in_bam.basename).bqsr_before.table.log

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
    valueFrom: "dbsnp.vcf"
  - position: 15
    valueFrom: "&&"
  - position: 16
    valueFrom: "ln"
  - position: 18
    valueFrom: "dbsnp.vcf.idx"
  - position: 19
    valueFrom: "&&"
  - position: 20
    valueFrom: "ln"
  - position: 22
    valueFrom: "mills_indel.vcf"
  - position: 23
    valueFrom: "&&"
  - position: 24
    valueFrom: "ln"
  - position: 26
    valueFrom: "mills_indel.vcf.idx"
  - position: 27
    valueFrom: "&&"
  - position: 28
    valueFrom: "ln"
  - position: 30
    valueFrom: "onek_indel.vcf"
  - position: 31
    valueFrom: "&&"
  - position: 32
    valueFrom: "ln"
  - position: 34
    valueFrom: "onek_indel.vcf.idx"
  - position: 35
    valueFrom: "&&"
  - position: 36
    valueFrom: "ln"
  - position: 38
    valueFrom: "reads.bam"
  - position: 39
    valueFrom: "&&"
  - position: 40
    valueFrom: "ln"
  - position: 42
    valueFrom: "reads.bam.bai"
  - position: 43
    valueFrom: "&&"
  - position: 44
    valueFrom: "mkdir"
  - position: 45
    prefix: -p
    valueFrom: "temp"
  - position: 46
    valueFrom: "&&"
  - position: 47
    valueFrom: "export"
  - position: 48
    prefix: "JAVA_TOOL_OPTIONS="
    valueFrom: "temp"
  - position: 49
    valueFrom: "&&"
  - position: 50
    valueFrom: "java"
  - position: 51
    valueFrom: "-Xmx98G"
  - position: 52
    valueFrom: "-jar"
  - position: 53
    valueFrom: "/usr/GenomeAnalysisTK.jar"
  - position: 54
    prefix: -T
    valueFrom: "BaseRecalibrator"
  - position: 56
    prefix: -R
    valueFrom: "reference.fa"
  - position: 57
    prefix: -I
    valueFrom: "reads.bam"
  - position: 58
    prefix: -o
    valueFrom: $(inputs.in_bam.basename).bqsr_before.table
  - position: 59
    prefix: -knownSites
    valueFrom: "dbsnp.vcf"
  - position: 60
    prefix: -knownSites
    valueFrom: "mills_indel.vcf"
  - position: 61
    prefix: -knownSites
    valueFrom: "onek_indel.vcf"
  - position: 62
    valueFrom: "&&"
  - position: 63
    valueFrom: "rm"
  - position: 64
    valueFrom: "reference.fa"
  - position: 65
    valueFrom: "reference.fa.fai"
  - position: 66
    valueFrom: "reference.dict"
  - position: 67
    valueFrom: "reads.bam"
  - position: 68
    valueFrom: "reads.bam.bai"
  - position: 69
    valueFrom: "dbsnp.vcf"
  - position: 70
    valueFrom: "dbsnp.vcf.idx"
  - position: 71
    valueFrom: "mills_indel.vcf"
  - position: 72
    valueFrom: "mills_indel.vcf.idx"
  - position: 73
    valueFrom: "onek_indel.vcf"
  - position: 74
    valueFrom: "onek_indel.vcf.idx"
  - position: 75
    valueFrom: "&&"
  - position: 76
    valueFrom: "rm"
  - position: 77
    prefix: -rf
    valueFrom: "temp"


