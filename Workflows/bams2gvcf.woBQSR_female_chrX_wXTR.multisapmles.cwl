cwlVersion: v1.0
class: Workflow
$namespaces:
  edam: 'http://edamontology.org/'

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genom
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  nthreads:
    type: int
    doc: number of cpu cores to be used

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
            bam_files:
              type: File[]
            outprefix:
              type: string
            chrXY_outprefix:
              type: string

steps:
  bams2gvcfwoBQSR_female_chrXY_wXTR:
    run: bams2gvcf.woBQSR_female_chrX_wXTR.cwl
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
      bam_files:
        valueFrom: $(inputs.inputSamples.bam_files)
      outprefix:
        valueFrom: $(inputs.inputSamples.outprefix)
      chrXY_outprefix:
        valueFrom: $(inputs.inputSamples.chrXY_outprefix)
    scatter:
      - inputSamples
    scatterMethod: dotproduct
    out:
      - rmdup_bam
      - rmdup_metrics
      - rmdup_log
      - samtools_extract_chrXY_unmap_chrXY_fastq
      - bwa_mem_SE_wXTR_sam
      - bwa_mem_SE_wXTR_log
      - picard_SortSam_wXTR_bam
      - picard_SortSam_wXTR_log
      - picard_MarkDuplicates_wXTR_bam
      - picard_MarkDuplicates_wXTR_metrics
      - picard_MarkDuplicates_wXTR_log
      - gatk3_HaplotypeCaller_X_ploidy2_vcf
      - gatk3_HaplotypeCaller_log

outputs:
  rmdup_bam:
    type: File[]
    format: edam:format_2572
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/rmdup_bam
    secondaryFiles:
      - ^.bai

  rmdup_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/rmdup_metrics

  rmdup_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/rmdup_log

  samtools_extract_chrXY_unmap_chrXY_fastq:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/samtools_extract_chrXY_unmap_chrXY_fastq

  bwa_mem_SE_wXTR_sam:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/bwa_mem_SE_wXTR_sam
    
  bwa_mem_SE_wXTR_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/bwa_mem_SE_wXTR_log

  picard_SortSam_wXTR_bam:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/picard_SortSam_wXTR_bam

  picard_SortSam_wXTR_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/picard_SortSam_wXTR_log

  picard_MarkDuplicates_wXTR_bam:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/picard_MarkDuplicates_wXTR_bam
    secondaryFiles:
      - ^.bai

  picard_MarkDuplicates_wXTR_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/picard_MarkDuplicates_wXTR_metrics

  picard_MarkDuplicates_wXTR_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/picard_MarkDuplicates_wXTR_log

  gatk3_HaplotypeCaller_X_ploidy2_vcf:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/gatk3_HaplotypeCaller_X_ploidy2_vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_female_chrXY_wXTR/gatk3_HaplotypeCaller_log
