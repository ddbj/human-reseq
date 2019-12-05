#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-haplotypecaller
label: parabricks-haplotypecaller
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

baseCommand: [ /opt/pkg/parabricks/pbrun, haplotypecaller ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    inputBinding:
      position: 1
      prefix: --ref
    doc: FastA file for reference genome
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  bam:
    type: File
    format: edam:format_2572
    secondaryFiles:
     - .bai
    inputBinding:
      position: 2
      prefix: --in-bam
  outprefix:
    type: string
  num_gpus:
    type: int?
    inputBinding:
      position: 5
      prefix: --num-gpus

outputs:
  vcf:
    type: File
    format: edam:format_3016
    outputBinding:
      glob: $(inputs.outprefix).g.vcf
  log:
    type: stderr

stderr: $(inputs.outprefix).g.vcf.log

arguments:
  - position: 3
    prefix: --out-variants
    valueFrom: $(inputs.outprefix).g.vcf
  - position: 4
    prefix: --gvcf
    valueFrom: null
