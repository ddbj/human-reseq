#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-fq2bam
label: parabricks-fq2bam
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

baseCommand: [ /opt/pkg/parabricks/pbrun, fq2bam ]

inputs:
  - id: reference
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
  - id: fqs
    type:
      type: array
      items:
        type: record
        fields:
          - name: fq1
            type: File # seems file format cannot be specified
            inputBinding:
              position: 0
          - name: fq2
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
              valueFrom: "@RG\tID:$(self.RG_ID)\tPL:$(self.RG_PL)\tPU:$(self.RG_PU)\tLB:$(self.RG_LB)\tSM:$(self.RG_SM)"
      inputBinding:
        position: 2
        prefix: --in-fq
    doc: FastQ file from next-generation sequencers

outputs:
  - id: bam
    type: File
    format: edam:format_2572
    outputBinding: 
      glob: markdups.bam
    secondaryFiles:
      - .bai
  - id: log
    type: stderr

stderr: fq2bam.log

arguments:
  - position: 3
    prefix: --out_bam
    valueFrom: markdups.bam
