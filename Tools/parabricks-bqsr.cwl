#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-bqsr
label: parabricks-bqsr
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

baseCommand: [ /opt/pkg/parabricks/pbrun, bqsr ]

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
#    secondaryFiles:
#     - .bai
    inputBinding:
      position: 2
      prefix: --in-bam
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
      position: 7
      prefix: --num-gpus

outputs:
  recal:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).recal.txt
  log:
    type: stderr

stderr: $(inputs.recal_prefix).log

arguments:
  - position: 6
    prefix: --out-recal-file
    valueFrom: $(inputs.outprefix).txt
