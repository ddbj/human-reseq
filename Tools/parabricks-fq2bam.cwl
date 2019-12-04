#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-fq2bam
label: parabricks-fq2bam
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

baseCommand: [ /opt/pkg/parabricks/pbrun, fq2bam ]

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
            type: File # seems file format cannot be specified
            inputBinding:
              position: 0
          - name: read2
            type: File # seems file format cannot be specified
            inputBinding:
              position: 1
          - name: read_group
            type:
              - type: record
                fields:
                  - name: RG_ID
                    type: string
                    doc: Read group identifier (ID) in RG line
                  - name: RG_PL
                    type: string
                    doc: Platform/technology used to produce the read (PL) in RG line
                  - name: RG_PU
                    type: string
                    doc: Platform Unit (PU) in RG line
                  - name: RG_LB
                    type: string
                    doc: DNA preparation library identifier (LB) in RG line
                  - name: RG_SM
                    type: string
                    doc: Sample (SM) identifier in RG line
            inputBinding:
              position: 2
              valueFrom: '@RG\\tID:$(self.RG_ID)\\tPL:$(self.RG_PL)\\tPU:$(self.RG_PU)\\tLB:$(self.RG_LB)\\tSM:$(self.RG_SM)'
      inputBinding:
        position: 2
        prefix: --in-fq
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
      position: 9
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
      glob: $(inputs.outprefix).recal.table
  dup_metrics:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).dup_metrics.txt
  log:
    type: stderr


stderr: $(inputs.outprefix).log

arguments:
  - position: 6
    prefix: --out-bam
    valueFrom: $(inputs.outprefix).mark_dups.bam
  - position: 7
    prefix: --out-recal-file
    valueFrom: $(inputs.outprefix).recal.table
  - position: 8
    prefix: --out-duplicate-metrics
    valueFrom: $(inputs.outprefix).dup_metrics.txt
