#!/usr/bin/env cwl-runner

class: CommandLineTool
id: parabricks-applybqsr
label: parabricks-applybqsr
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

baseCommand: [ /opt/pkg/parabricks/pbrun, applybqsr ]

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
  in_bam:
    type: File
    format: edam:format_2572
#    secondaryFiles:
#     - .bai
    inputBinding:
      position: 2
      prefix: --in-bam
  recal:
    type: File
    inputBinding:
      position: 3
      prefix: --in-recal-file
  outprefix:
    type: string
  num_threads:
    type: int?
    inputBinding:
      position: 5
      prefix: --num-threads
  num_gpus:
    type: int?
    inputBinding:
      position: 6
      prefix: --num-gpus

outputs:
  out_bam:
    type: File
    format: edam:format_2572    
    outputBinding:
      glob: $(inputs.outprefix).bam
  log:
    type: stderr

stderr: $(inputs.outprefix).log

arguments:
  - position: 4
    prefix: --out-bam
    valueFrom: $(inputs.outprefix).bam
