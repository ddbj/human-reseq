#!/usr/bin/env cwl-runner

class: Workflow
id: bam2gvcf-woBQSR-female
label: bam2gvcf-woBQSR-female
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome

  reference_amb:
    type: File
    doc: AMB index file for reference genome

  reference_ann:
    type: File
    doc: ANN index file for reference genome

  reference_bwt:
    type: File
    doc: BWT index file for reference genome

  reference_pac:
    type: File
    doc: PAC index file for reference genome

  reference_sa:
    type: File
    doc: SA index file for reference genome

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

  picard_CollectMultipleMetrics:
    label: picard_CollectMultipleMetrics
    doc: Collect multiple metrics using picard
    run: ../Tools/picard-CollectMultipleMetrics.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
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
      in_bam: picard_MarkDuplicates/out_bam
      nthreads: nthreads
    out: [flagstat]

  samtools_idxstats:
    label: samtools_idxstats
    doc: Calculate idxstats using samtools
    run: ../Tools/samtools-idxstats.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      in_bai: picard_MarkDuplicates/out_bai
    out: [idxstats]
    
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


