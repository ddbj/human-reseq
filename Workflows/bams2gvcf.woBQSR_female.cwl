#!/usr/bin/env cwl-runner

class: Workflow
id: bam2gvcf-woBQSR-female
label: bam2gvcf-woBQSR-female
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

requirements:
  SubworkflowFeatureRequirement: {}
  
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
    doc: interval name for reference genome (autosome)
    
  reference_interval_list_autosome:
    type: File
    doc: interval list for reference genome (autosome)

  reference_interval_name_chrX:
    type: string
    doc: interval name for reference genome (chrX)
    
  reference_interval_list_chrX:
    type: File
    doc: interval list for reference genome (chrX)

  reference_interval_name_chrY:
    type: string
    doc: interval name for reference genome (chrY)
    
  reference_interval_list_chrY:
    type: File
    doc: interval list for reference genome (chrY)
    
  bam_files:
    type: File[]
    format: edam:format_2572
    doc: array of input BAM alignment files (each file should be sorted)
  
  nthreads:
    type: int
    doc: number of cpu cores to be used

  outprefix:
    type: string
    doc: Output prefix name


steps:
  bams2gvcf_woBQSR:
    label: bams2gvcf_woBQSR
    doc: Call haplotypes from bam files
    run: ../Workflows/bams2gvcf.woBQSR.cwl
    in:
      bam_files: bam_files
      outprefix: outprefix
      reference: reference
      reference_interval_name_autosome: reference_interval_name_autosome
      reference_interval_list_autosome: reference_interval_list_autosome
      reference_interval_name_chrX: reference_interval_name_chrX
      reference_interval_list_chrX: reference_interval_list_chrX
      reference_interval_name_chrY: reference_interval_name_chrY
      reference_interval_list_chrY: reference_interval_list_chrY
      nthreads: nthreads
    out:
      - rmdup_bam
      - rmdup_metrics
      - rmdup_log
      - picard_collect_multiple_metrics_alignment_summary_metrics
      - picard_collect_multiple_metrics_bait_bias_detail_metrics
      - picard_collect_multiple_metrics_bait_bias_summary_metrics
      - picard_collect_multiple_metrics_base_distribution_by_cycle_metrics
      - picard_collect_multiple_metrics_base_distribution_by_cycle_pdf
      - picard_collect_multiple_metrics_error_summary_metrics
      - picard_collect_multiple_metrics_gc_bias_detail_metrics
      - picard_collect_multiple_metrics_gc_bias_pdf
      - picard_collect_multiple_metrics_gc_bias_summary_metrics
      - picard_collect_multiple_metrics_insert_size_histogram_pdf
      - picard_collect_multiple_metrics_insert_size_metrics
      - picard_collect_multiple_metrics_pre_adapter_detail_metrics
      - picard_collect_multiple_metrics_pre_adapter_summary_metrics
      - picard_collect_multiple_metrics_quality_by_cycle_metrics
      - picard_collect_multiple_metrics_quality_by_cycle_pdf
      - picard_collect_multiple_metrics_quality_distribution_metrics
      - picard_collect_multiple_metrics_quality_distribution_pdf
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
      - gatk3_HaplotypeCaller_vcf_tbi
      - gatk3_HaplotypeCaller_log

    
outputs:
  rmdup_bam:
    type: File
    format: edam:format_2572
    outputSource: bams2gvcf_woBQSR/rmdup_bam

  rmdup_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/rmdup_metrics

  rmdup_log:
    type: File
    outputSource: bams2gvcf_woBQSR/rmdup_log

  picard_collect_multiple_metrics_alignment_summary_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_alignment_summary_metrics
    
  picard_collect_multiple_metrics_bait_bias_detail_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_bait_bias_detail_metrics

  picard_collect_multiple_metrics_bait_bias_summary_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_bait_bias_summary_metrics

  picard_collect_multiple_metrics_base_distribution_by_cycle_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_base_distribution_by_cycle_metrics

  picard_collect_multiple_metrics_base_distribution_by_cycle_pdf:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_base_distribution_by_cycle_pdf

  picard_collect_multiple_metrics_error_summary_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_error_summary_metrics

  picard_collect_multiple_metrics_gc_bias_detail_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_gc_bias_detail_metrics

  picard_collect_multiple_metrics_gc_bias_pdf:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_gc_bias_pdf

  picard_collect_multiple_metrics_gc_bias_summary_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_gc_bias_summary_metrics

  picard_collect_multiple_metrics_insert_size_histogram_pdf:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_insert_size_histogram_pdf

  picard_collect_multiple_metrics_insert_size_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_insert_size_metrics

  picard_collect_multiple_metrics_pre_adapter_detail_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_pre_adapter_detail_metrics

  picard_collect_multiple_metrics_pre_adapter_summary_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_pre_adapter_summary_metrics

  picard_collect_multiple_metrics_quality_by_cycle_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_quality_by_cycle_metrics

  picard_collect_multiple_metrics_quality_by_cycle_pdf:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_quality_by_cycle_pdf

  picard_collect_multiple_metrics_quality_distribution_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_quality_distribution_metrics

  picard_collect_multiple_metrics_quality_distribution_pdf:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_quality_distribution_pdf

  picard_collect_multiple_metrics_log:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_collect_multiple_metrics_log

  samtools_flagstat_flagstat:
    type: File
    outputSource: bams2gvcf_woBQSR/samtools_flagstat_flagstat

  samtools_idxstats_idxstats:
    type: File
    outputSource: bams2gvcf_woBQSR/samtools_idxstats_idxstats

  picard_CollectWgsMetrics_autosome_wgs_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_CollectWgsMetrics_autosome_wgs_metrics

  picard_CollectWgsMetrics_autosome_log:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_CollectWgsMetrics_autosome_log
    
  picard_CollectWgsMetrics_chrX_wgs_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_CollectWgsMetrics_chrX_wgs_metrics

  picard_CollectWgsMetrics_chrX_log:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_CollectWgsMetrics_chrX_log
    
  picard_CollectWgsMetrics_chrY_wgs_metrics:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_CollectWgsMetrics_chrY_wgs_metrics

  picard_CollectWgsMetrics_chrY_log:
    type: File
    outputSource: bams2gvcf_woBQSR/picard_CollectWgsMetrics_chrY_log
    
  gatk3_HaplotypeCaller_vcf:
    type: File
    format: edam:format_3016
    outputSource: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_vcf

  gatk3_HaplotypeCaller_vcf_tbi:
    type: File
    outputSource: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_vcf_tbi

  gatk3_HaplotypeCaller_log:
    type: File
    outputSource: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_log
    
