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

  dbsnp:
    type: File
    doc: dbSNP data file for base recalibrator
    secondaryFiles:
      - .idx

  mills_indel:
    type: File
    doc: Mills indel data file for base recalibrator
    secondaryFiles:
      - .idx

  onek_indel:
    type: File
    doc: Onek indel data file for base recalibrator
    secondaryFiles:
      - .idx
    
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
    out: [out_bam, out_metrics, log]

  gatk3_BaseRecalibrator_before:
    label: gatk3_BaseRecalibrator_before
    doc: Calculate base recalibrator table (before)
    run: ../Tools/gatk3-BaseRecalibrator-before.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      nthreads: nthreads
      reference: reference
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
    out: [bqsr_table_before, log]

  gatk3_BaseRecalibrator_after:
    label: gatk3_BaseRecalibrator_after
    doc: Calculate base recalibrator table (after)
    run: ../Tools/gatk3-BaseRecalibrator-after.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      nthreads: nthreads
      reference: reference
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
      bqsr_table_before: gatk3_BaseRecalibrator_before/bqsr_table_before
    out: [bqsr_table_after, log]

  gatk3_AnalyzeCovariates:
    label: gatk3_AnalyzeCovariates
    doc: Draw plots of BQSR tables
    run: ../Tools/gatk3-AnalyzeCovariates.cwl
    in:
      reference: reference
      bqsr_table_before: gatk3_BaseRecalibrator_before/bqsr_table_before
      bqsr_table_after: gatk3_BaseRecalibrator_after/bqsr_table_after
    out: [bqsr_pdf, log]
      
  gatk3_PrintReads:
    label: gatk3_PrintReads
    doc: Output bam file while modifying base quality
    run: ../Tools/gatk3-PrintReads.cwl
    in:
      in_bam: picard_MarkDuplicates/out_bam
      nthreads: nthreads
      reference: reference
      bqsr_table_before: gatk3_BaseRecalibrator_before/bqsr_table_before
      outprefix: outprefix
    out: [out_bam, log]
    
  picard_CollectMultipleMetrics:
    label: picard_CollectMultipleMetrics
    doc: Collect multiple metrics using picard
    run: ../Tools/picard-CollectMultipleMetrics.cwl
    in:
      in_bam: gatk3_PrintReads/out_bam
      reference: reference
    out: [alignment_summary_metrics, insert_size_metrics, log]

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
      nthreads: nthreads
      reference: reference
      outprefix: outprefix
    out: [vcf, log]
    
outputs:
  rmdup_bam:
    type: File
    format: edam:format_2572
    outputSource: picard_MarkDuplicates/out_bam
    secondaryFiles:
      - ^.bai

  rmdup_metrics:
    type: File
    outputSource: picard_MarkDuplicates/out_metrics

  rmdup_log:
    type: File
    outputSource: picard_MarkDuplicates/log

  picard_collect_multiple_metrics_alignment_summary_metrics:
    type: File
    outputSource: picard_CollectMultipleMetrics/alignment_summary_metrics
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
    type: File
    outputSource: picard_CollectMultipleMetrics/insert_size_metrics
    secondaryFiles:
      - ^.insert_size_histogram.pdf

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
    secondaryFiles:
      - ^.bai

  gatk3_PrintReads_log:
    type: File
    outputSource: gatk3_PrintReads/log
    
  gatk3_HaplotypeCaller_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_HaplotypeCaller/vcf
    secondaryFiles:
      - .tbi

  gatk3_HaplotypeCaller_log:
    type: File
    outputSource: gatk3_HaplotypeCaller/log
    
