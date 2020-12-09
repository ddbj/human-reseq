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
    doc: FastA file for reference genome
    secondaryFiles:
      - .fai
      - ^.dict

  reference_interval_name_autosome:
    type: string
    default: autosome
    doc: interval name for reference genome (autosome)
    
  reference_interval_list_autosome:
    type: File
    doc: interval list for reference genome (autosome)

  reference_interval_name_chrX:
    type: string
    default: chrX
    doc: interval name for reference genome (chrX)
    
  reference_interval_list_chrX:
    type: File
    doc: interval list for reference genome (chrX)

  reference_interval_name_chrY:
    type: string
    default: chrY
    doc: interval name for reference genome (chrY)
    
  reference_interval_list_chrY:
    type: File
    doc: interval list for reference genome (chrY)
  nthreads:
    type: int
    doc: number of cpu cores to be used

  inputSamples:
    type:
      type: array
      items:
        - type: record
          fields:
            bam_files:
              type: File[]
            outprefix:
              type: string
            chrXY_outprefix:
              type: string

steps:
  bams2gvcfwoBQSR_male:
    run: bams2gvcf.woBQSR_male.cwl
    in:
      reference: reference
      reference_interval_name_autosome: reference_interval_name_autosome
      reference_interval_list_autosome: reference_interval_list_autosome
      reference_interval_name_chrX: reference_interval_name_chrX
      reference_interval_list_chrX: reference_interval_list_chrX
      reference_interval_name_chrY: reference_interval_name_chrY
      reference_interval_list_chrY: reference_interval_list_chrY
      nthreads: nthreads
      inputSamples: inputSamples
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
      - picard_collect_multiple_metrics_alignment_summary_metrics
      - picard_collect_multiple_metrics_insert_size_metrics
      - picard_collect_multiple_metrics_log
      - samtools_flagstat_flagstat
      - samtools_idxstats_idxstats
      - picard_CollectWgsMetrics_autosome_wgs_metrics
      - picard_CollectWgsMetrics_autosome_log
      - picard_CollectWgsMetrics_chrX_wgs_metrics
      - picard_CollectWgsMetrics_chrX_log
      - picard_CollectWgsMetrics_chrY_wgs_metrics
      - picard_CollectWgsMetrics_chrY_log
      - gatk3_HaplotypeCaller_vcf
      - gatk3_HaplotypeCaller_log
      - gatk3_HaplotypeCaller_XCORE_ploidy1_vcf
      - gatk3_HaplotypeCaller_XCORE_ploidy1_log
      - gatk3_HaplotypeCaller_Y_ploidy1_vcf
      - gatk3_HaplotypeCaller_Y_ploidy1_log
      - gatk3_SelectVariants_PAR1_vcf
      - gatk3_SelectVariants_PAR1_log
      - gatk3_SelectVariants_PAR2_vcf
      - gatk3_SelectVariants_PAR2_log
      - bcftools_concat_vcf
      - bcftools_index_vcf_tbi




outputs:
  rmdup_bam:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/rmdup_bam
    secondaryFiles:
      - ^.bai
  rmdup_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/rmdup_metrics
  rmdup_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/rmdup_log
  picard_collect_multiple_metrics_alignment_summary_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_collect_multiple_metrics_alignment_summary_metrics
    secondaryFiles:
      - ^.bait_bias_detail_metrics
      - ^.bait_bias_summary_metrics
      - ^.base_distribution_by_cycle_metrics
      - ^.base_distribution_by_cycle.pdf
      - ^.error_summary_metrics
      - ^.gc_bias.detail_metrics
      - ^.gc_bias.pdf
      - ^.gc_bias.summary_metrics
      - ^.pre_adapter_detail_metrics
      - ^.pre_adapter_summary_metrics
      - ^.quality_by_cycle_metrics
      - ^.quality_by_cycle.pdf
      - ^.quality_distribution_metrics
      - ^.quality_distribution.pdf
    
  picard_collect_multiple_metrics_insert_size_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_collect_multiple_metrics_insert_size_metrics
    secondaryFiles:
      - ^.insert_size_histogram.pdf

  picard_collect_multiple_metrics_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_collect_multiple_metrics_log

  samtools_flagstat_flagstat:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/samtools_flagstat_flagstat

  samtools_idxstats_idxstats:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/samtools_idxstats_idxstats

  picard_CollectWgsMetrics_autosome_wgs_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_CollectWgsMetrics_autosome_wgs_metrics

  picard_CollectWgsMetrics_autosome_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_CollectWgsMetrics_autosome_log
    
  picard_CollectWgsMetrics_chrX_wgs_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_CollectWgsMetrics_chrX_wgs_metrics

  picard_CollectWgsMetrics_chrX_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_CollectWgsMetrics_chrX_log
    
  picard_CollectWgsMetrics_chrY_wgs_metrics:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_CollectWgsMetrics_chrY_wgs_metrics

  picard_CollectWgsMetrics_chrY_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/picard_CollectWgsMetrics_chrY_log
    
  gatk3_HaplotypeCaller_vcf:
    type: File[]
    format: edam:format_3016
    outputSource: bams2gvcfwoBQSR_male/gatk3_HaplotypeCaller_vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_HaplotypeCaller_log

  gatk3_HaplotypeCaller_XCORE_ploidy1_vcf:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_HaplotypeCaller_XCORE_ploidy1_vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_XCORE_ploidy1_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_HaplotypeCaller_XCORE_ploidy1_log

  gatk3_HaplotypeCaller_Y_ploidy1_vcf:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_HaplotypeCaller_Y_ploidy1_vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_Y_ploidy1_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_HaplotypeCaller_Y_ploidy1_log

  gatk3_SelectVariants_PAR1_vcf:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_SelectVariants_PAR1_vcf
    secondaryFiles:
      - .tbi

  gatk3_SelectVariants_PAR1_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_SelectVariants_PAR1_log

  gatk3_SelectVariants_PAR2_vcf:
    type: File[]
    format: edam:format_3016
    outputSource: bams2gvcfwoBQSR_male/gatk3_SelectVariants_PAR2_vcf
    secondaryFiles:
      - .tbi

  gatk3_SelectVariants_PAR2_log:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/gatk3_SelectVariants_PAR2_log

  bcftools_concat_vcf:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/bcftools_concat_vcf

  bcftools_index_vcf_tbi:
    type: File[]
    outputSource: bams2gvcfwoBQSR_male/bcftools_index_vcf_tbi
