cwlVersion: v1.0
class: Workflow
requirements:
  - SubworkflowFeatureRequirement: {}
  - StepInputExpressionRequirement: {}

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  nthreads:
    type: int
  inputSamples:
    type:
      type: record[]
      name: samples
      fields:
        - name: RG_ID
          type: string
        - name: RG_PL
          type: string
        - name: RG_PU
          type: string
        - name: RG_LB
          type: string
        - name: RG_SM
          type: string
        - name: fq
          type: File
        - name: outprefix
          type: string

steps:
  fastqSE2bam:
    run: fastqSE2bam.cwl
    in:
      reference: reference
      nthreads: nthreads
      RG_ID:
        valueFrom: inputSamples.RG_ID
      RG_PL:
        valueFrom: inputSamples.RG_PL
      RG_PU:
        valueFrom: inputSamples.RG_PU
      RG_LB:
        valueFrom: inputSamples.RG_LB
      RG_SM:
        valueFrom: inputSamples.RG_SM
      fq:
        valueFrom: inputSamples.fq
      outprefix:
        valueFrom: inputSamples.outprefix
    scatter:
      - RG_ID
      - RG_PL
      - RG_PU
      - RG_LB
      - RG_SM
      - fq
      - outprefix
    scatterMethod: dotproduct
    out:
      - sam
      - sam_log
      - bam
      - bam_log
