#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk3-HaplotypeCaller-local-3.7.0
label: gatk3-HaplotypeCaller-local-3.7.0
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

baseCommand: [ java, -Xmx98G, -jar, /usr/GenomeAnalysisTK.jar, -T, HaplotypeCaller ]

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
  - id: outprefix
    type: string
    
outputs:
  - id: vcf
    type: File
    format: edam:format_3016
    outputBinding: 
      glob: $(inputs.outprefix).chrX_XTR.g.vcf.gz
    secondaryFiles:
      - .tbi
  - id: log
    type: stderr

stderr: $(inputs.outprefix).chrX_XTR.g.vcf.gz.log

arguments:
  - position: 4
    prefix: -L
    valueFrom: "X:88456802-92375509"
  - position: 5
    prefix: -ploidy
    valueFrom: "2"
  - position: 6
    prefix: -o
    valueFrom: $(inputs.outprefix).chrX_XTR.g.vcf.gz
  - position: 7
    prefix: --emitRefConfidence
    valueFrom: "GVCF"

