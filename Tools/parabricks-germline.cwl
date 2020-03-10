#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-fq2bam
label: parabricks-fq2bam
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

baseCommand: [ /opt/pkg/parabricks/pbrun, germline ]

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
  fqs:
    type:
      type: array
      items:
        type: record
        fields:
          - name: read1
            type: File
            inputBinding:
              position: 1
          - name: read2
            type: File
            inputBinding:
              position: 2
      inputBinding:
        prefix: --in-fq
    inputBinding:
      position: 2
    doc: FastQ file from next-generation sequencers
  dbsnp:
    type: File
    doc: dbSNP data file for base recalibrator
    secondaryFiles:
      - .idx
    inputBinding:
      position: 3
      prefix: --knownSites
  mills_indel:
    type: File
    doc: Mills indel data file for base recalibrator
    secondaryFiles:
      - .idx
    inputBinding:
      position: 4
      prefix: --knownSites
  onek_indel:
    type: File
    doc: Onek indel data file for base recalibrator
    secondaryFiles:
      - .idx
    inputBinding:
      position: 5
      prefix: --knownSites
  outprefix:
    type: string
  num_gpus:
    type: int?
    inputBinding:
      position: 10
      prefix: --num-gpus

outputs:
  bam:
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.outprefix).mark_dups.bam
    secondaryFiles:
      - .bai
  recal:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).bqsr.recal.table
  gvcf:
    type: File
    format: edam:format_3016
    outputBinding:
      glob: $(inputs.outprefix).g.vcf
  log:
    type: stderr

stderr: $(inputs.outprefix).log

arguments:
  - position: 6
    prefix: --out-bam
    valueFrom: $(inputs.outprefix).mark_dups.bam
  - position: 7
    prefix: --out-variants
    valueFrom: $(inputs.outprefix).g.vcf
  - position: 7
    prefix: --out-recal-file
    valueFrom: $(inputs.outprefix).recal.table
  - position: 9
    valueFrom: --gvcf
