cwlVersion: v1.0
class: Workflow
requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

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
      type: array
      items:
        - type: record
          fields:
            RG_ID:
              type: string
            RG_PL:
              type: string
            RG_PU:
              type: string
            RG_LB:
              type: string
            RG_SM:
              type: string
            fq:
              type: File
            outprefix:
              type: string

steps:
  fastqSE2bam:
    run: fastqSE2bam.cwl
    in:
      reference: reference
      nthreads: nthreads
      inputSamples: inputSamples
      RG_ID:
        valueFrom: $(inputs.inputSamples.RG_ID)
      RG_PL:
        valueFrom: $(inputs.inputSamples.RG_PL)
      RG_PU:
        valueFrom: $(inputs.inputSamples.RG_PU)
      RG_LB:
        valueFrom: $(inputs.inputSamples.RG_LB)
      RG_SM:
        valueFrom: $(inputs.inputSamples.RG_SM)
      fq:
        valueFrom: $(inputs.inputSamples.fq)
      outprefix:
        valueFrom: $(inputs.inputSamples.outprefix)
    scatter:
      - inputSamples
    scatterMethod: dotproduct
    out:
      - sam
      - sam_log
      - bam
      - bam_log

outputs:
  sam:
    type: File[]
    outputSource: fastqSE2bam/sam
  sam_log:
    type: File[]
    outputSource: fastqSE2bam/sam_log
  bam:
    type: File[]
    outputSource: fastqSE2bam/bam
  bam_log:
    type: File[]
    outputSource: fastqSE2bam/bam_log
