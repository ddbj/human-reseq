#!/usr/bin/env cwl-runner

class: Workflow
id: bam2gvcf-wBQSR
label: bam2gvcf-wBQSR
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome

  reference_fai:
    type: File
    doc: FAI index file for reference genome

  reference_dict:
    type: File
    doc: DICT index file for reference genome

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

  dbsnp:
    type: File
    doc: dbSNP data file for base recalibrator

  dbsnp_idx:
    type: File
    doc: Index for dbSNP data file

  mills_indel:
    type: File
    doc: Mills indel data file for base recalibrator

  mills_indel_idx:
    type: File
    doc: Index for Mills indel data file

  onek_indel:
    type: File
    doc: Onek indel data file for base recalibrator

  onek_indel_idx:
    type: File
    doc: Index for Onek indel data file
    
    
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
  picard_MarkDuplicates:
    label: picard_MarkDuplicates
    doc: Merge BAM files and remove duplicates
    run: ../Tools/picard-MarkDuplicates.cwl
    in:
      bam_files: bam_files
      outprefix: outprefix
    out: [out_bam, out_bai, out_metrics, log]

  gatk3_BaseRecalibrator_before:
    label: gatk3_BaseRecalibrator_before
    doc: Calculate base recalibrator table (before)
    run: ../Tools/gatk3-BaseRecalibrator-before.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      in_bai: picard_MarkDuplicates/out_bai
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      dbsnp: dbsnp
      dbsnp_idx: dbsnp_idx
      mills_indel: mills_indel
      mills_indel_idx: mills_indel_idx
      onek_indel: onek_indel
      onek_indel_idx: onek_indel_idx
    out: [bqsr_table_before, log]

  gatk3_BaseRecalibrator_after:
    label: gatk3_BaseRecalibrator_after
    doc: Calculate base recalibrator table (after)
    run: ../Tools/gatk3-BaseRecalibrator-after.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      in_bai: picard_MarkDuplicates/out_bai
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      dbsnp: dbsnp
      dbsnp_idx: dbsnp_idx
      mills_indel: mills_indel
      mills_indel_idx: mills_indel_idx
      onek_indel: onek_indel
      onek_indel_idx: onek_indel_idx
      bqsr_table_before: gatk3_BaseRecalibrator_before/bqsr_table_before
    out: [bqsr_table_after, log]

  gatk3_AnalyzeCovariates:
    label: gatk3_AnalyzeCovariates
    doc: Draw plots of BQSR tables
    run: ../Tools/gatk3-AnalyzeCovariates.cwl
    in:
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      bqsr_table_before: gatk3_BaseRecalibrator_before/bqsr_table_before
      bqsr_table_after: gatk3_BaseRecalibrator_after/bqsr_table_after
    out: [bqsr_pdf, log]
      
  gatk3_PrintReads:
    label: gatk3_PrintReads
    doc: Output bam file while modifying base quality
    run: ../Tools/gatk3-PrintReads.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      in_bai: picard_MarkDuplicates/out_bai
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      bqsr_table_before: gatk3_BaseRecalibrator_before/bqsr_table_before
      outprefix: outprefix
    out: [out_bam, out_bai, log]
    
  picard_CollectMultipleMetrics:
    label: picard_CollectMultipleMetrics
    doc: Collect multiple metrics using picard
    run: ../Tools/picard-CollectMultipleMetrics.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      reference: reference
    out:
      - alignment_summary_metrics
      - bait_bias_detail_metrics
      - bait_bias_summary_metrics
      - base_distribution_by_cycle_metrics
      - base_distribution_by_cycle_pdf
      - error_summary_metrics
      - gc_bias_detail_metrics
      - gc_bias_pdf
      - gc_bias_summary_metrics
      - insert_size_histogram_pdf
      - insert_size_metrics
      - pre_adapter_detail_metrics
      - pre_adapter_summary_metrics
      - quality_by_cycle_metrics
      - quality_by_cycle_pdf
      - quality_distribution_metrics
      - quality_distribution_pdf
      - log

  samtools_flagstat:
    label: samtools_flagstat
    doc: Calculate flagstat using samtools
    run: ../Tools/samtools-flagstat.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      nthreads: nthreads
    out: [flagstat]

  samtools_idxstats:
    label: samtools_idxstats
    doc: Calculate idxstats using samtools
    run: ../Tools/samtools-idxstats.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      in_bai: gatk3_PrintReads/out_bai
    out: [idxstats]

  picard_CollectWgsMetrics_autosome:
    label: picard_CollectWgsMetrics
    doc: Collect WGS metrics using picard
    run: ../Tools/picard-CollectWgsMetrics.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      reference: reference
      reference_interval_name: reference_interval_name_autosome
      reference_interval_list: reference_interval_list_autosome
    out: [wgs_metrics, log]

  picard_CollectWgsMetrics_chrX:
    label: picard_CollectWgsMetrics
    doc: Collect WGS metrics using picard
    run: ../Tools/picard-CollectWgsMetrics.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      reference: reference
      reference_interval_name: reference_interval_name_chrX
      reference_interval_list: reference_interval_list_chrX
    out: [wgs_metrics, log]
    
  picard_CollectWgsMetrics_chrY:
    label: picard_CollectWgsMetrics
    doc: Collect WGS metrics using picard
    run: ../Tools/picard-CollectWgsMetrics.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      reference: reference
      reference_interval_name: reference_interval_name_chrY
      reference_interval_list: reference_interval_list_chrY
    out: [wgs_metrics, log]

      
  gatk3_HaplotypeCaller:
    label: gatk3_HaplotypeCaller
    doc: Haplotype calling using GATK3
    run: ../Tools/gatk3-HaplotypeCaller.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      in_bai: gatk3_PrintReads/out_bai
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      outprefix: outprefix
    out: [vcf, vcf_tbi, log]
    
outputs:
  rmdup_bam:
    type: File
    format: edam:format_2572
    outputSource: picard_MarkDuplicates/out_bam

  rmdup_bai:
    type: File
    outputSource: picard_MarkDuplicates/out_bai

  rmdup_metrics:
    type: File
    outputSource: picard_MarkDuplicates/out_metrics

  rmdup_log:
    type: File
    outputSource: picard_MarkDuplicates/log

  picard_collect_multiple_metrics_alignment_summary_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/alignment_summary_metrics
    
  picard_collect_multiple_metrics_bait_bias_detail_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/bait_bias_detail_metrics

  picard_collect_multiple_metrics_bait_bias_summary_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/bait_bias_summary_metrics

  picard_collect_multiple_metrics_base_distribution_by_cycle_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/base_distribution_by_cycle_metrics

  picard_collect_multiple_metrics_base_distribution_by_cycle_pdf:
    type: File
    outputSource: picard_CollectMultipleMetrics/base_distribution_by_cycle_pdf

  picard_collect_multiple_metrics_error_summary_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/error_summary_metrics

  picard_collect_multiple_metrics_gc_bias_detail_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/gc_bias_detail_metrics

  picard_collect_multiple_metrics_gc_bias_pdf:
    type: File
    outputSource: picard_CollectMultipleMetrics/gc_bias_pdf

  picard_collect_multiple_metrics_gc_bias_summary_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/gc_bias_summary_metrics

  picard_collect_multiple_metrics_insert_size_histogram_pdf:
    type: File
    outputSource: picard_CollectMultipleMetrics/insert_size_histogram_pdf

  picard_collect_multiple_metrics_insert_size_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/insert_size_metrics

  picard_collect_multiple_metrics_pre_adapter_detail_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/pre_adapter_detail_metrics

  picard_collect_multiple_metrics_pre_adapter_summary_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/pre_adapter_summary_metrics

  picard_collect_multiple_metrics_quality_by_cycle_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/quality_by_cycle_metrics

  picard_collect_multiple_metrics_quality_by_cycle_pdf:
    type: File
    outputSource: picard_CollectMultipleMetrics/quality_by_cycle_pdf

  picard_collect_multiple_metrics_quality_distribution_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/quality_distribution_metrics

  picard_collect_multiple_metrics_quality_distribution_pdf:
    type: File
    outputSource: picard_CollectMultipleMetrics/quality_distribution_pdf

  picard_collect_multiple_metrics_log:
    type: File
    outputSource: picard_CollectMultipleMetrics/log

  samtools_flagstat_flagstat:
    type: File
    outputSource: samtools_flagstat/flagstat

  samtools_idxstats_idxstats:
    type: File
    outputSource: samtools_idxstats/idxstats

  picard_CollectWgsMetrics_autosome_wgs_metrics:
    type: File
    outputSource: picard_CollectWgsMetrics_autosome/wgs_metrics

  picard_CollectWgsMetrics_autosome_log:
    type: File
    outputSource: picard_CollectWgsMetrics_autosome/log
    
  picard_CollectWgsMetrics_chrX_wgs_metrics:
    type: File
    outputSource: picard_CollectWgsMetrics_chrX/wgs_metrics

  picard_CollectWgsMetrics_chrX_log:
    type: File
    outputSource: picard_CollectWgsMetrics_chrX/log
    
  picard_CollectWgsMetrics_chrY_wgs_metrics:
    type: File
    outputSource: picard_CollectWgsMetrics_chrY/wgs_metrics

  picard_CollectWgsMetrics_chrY_log:
    type: File
    outputSource: picard_CollectWgsMetrics_chrY/log

  gatk3_BaseRecalibrator_before_bqsr_table_before:
    type: File
    outputSource: gatk3_BaseRecalibrator_before/bqsr_table_before

  gatk3_BaseRecalibrator_before_log:
    type: File
    outputSource: gatk3_BaseRecalibrator_before/log

  gatk3_BaseRecalibrator_after_bqsr_table_after:
    type: File
    outputSource: gatk3_BaseRecalibrator_after/bqsr_table_after

  gatk3_BaseRecalibrator_after_log:
    type: File
    outputSource: gatk3_BaseRecalibrator_after/log

  gatk3_AnalyzeCovariates_bqsr_pdf:
    type: File
    outputSource: gatk3_AnalyzeCovariates/bqsr_pdf

  gatk3_AnalyzeCovariates_log:
    type: File
    outputSource: gatk3_AnalyzeCovariates/log

  gatk3_PrintReads_out_bam:
    type: File
    format: edam:format_2572
    outputSource: gatk3_PrintReads/out_bam

  gatk3_PrintReads_out_bai:
    type: File
    outputSource: gatk3_PrintReads/out_bai

  gatk3_PrintReads_log:
    type: File
    outputSource: gatk3_PrintReads/log
    
  gatk3_HaplotypeCaller_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_HaplotypeCaller/vcf

  gatk3_HaplotypeCaller_vcf_tbi:
    type: File
    outputSource: gatk3_HaplotypeCaller/vcf_tbi

  gatk3_HaplotypeCaller_log:
    type: File
    outputSource: gatk3_HaplotypeCaller/log
    
