#!/usr/bin/env cwl-runner

class: Workflow
id: bam2gvcf-woBQSR-male
label: bam2gvcf-woBQSR-male
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  
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

  chrXY_outprefix:
    type: string
    doc: Output prefix name for chrXY
    
steps:
  bams2gvcf_woBQSR:
    label: bams2gvcf_woBQSR
    doc: Call haplotypes from bam files
    run: ../Workflows/bams2gvcf.woBQSR.cwl
    in:
      bam_files: bam_files
      outprefix: outprefix
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      reference_interval_name_autosome: reference_interval_name_autosome
      reference_interval_list_autosome: reference_interval_list_autosome
      reference_interval_name_chrX: reference_interval_name_chrX
      reference_interval_list_chrX: reference_interval_list_chrX
      reference_interval_name_chrY: reference_interval_name_chrY
      reference_interval_list_chrY: reference_interval_list_chrY
      nthreads: nthreads
    out:
      - rmdup_bam
      - rmdup_bai
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

  gatk3_HaplotypeCaller_XCORE_ploidy1:
    label: gatk3_HaplotypeCaller_XCORE_ploidy1
    doc: Call haplotypes for chrX core region with ploidy=1
    run: ../Tools/gatk3-HaplotypeCaller-XCORE-ploidy1.cwl
    in:
      in_bam: bams2gvcf_woBQSR/rmdup_bam
      in_bai: bams2gvcf_woBQSR/rmdup_bai
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      outprefix: outprefix
    out: [vcf, vcf_tbi, log]

  gatk3_HaplotypeCaller_Y_ploidy1:
    label: gatk3_HaplotypeCaller_Y_ploidy1
    doc: Call haplotypes for chrY region with ploidy=1
    run: ../Tools/gatk3-HaplotypeCaller-Y-ploidy1.cwl
    in:
      in_bam: bams2gvcf_woBQSR/rmdup_bam
      in_bai: bams2gvcf_woBQSR/rmdup_bai
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      outprefix: outprefix
    out: [vcf, vcf_tbi, log]

  gatk3_SelectVariants_PAR1:
    label: gatk3_SelectVariants_PAR1
    doc: Select variants for chrX PAR1 region
    run: ../Tools/gatk3-SelectVariants-PAR1.cwl
    in:
      vcf: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_vcf
      vcf_tbi: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_vcf_tbi
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      outprefix: outprefix
    out: [out_vcf, out_vcf_tbi, log]
      
  gatk3_SelectVariants_PAR2:
    label: gatk3_SelectVariants_PAR2
    doc: Select variants for chrX PAR2 region
    run: ../Tools/gatk3-SelectVariants-PAR2.cwl
    in:
      vcf: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_vcf
      vcf_tbi: bams2gvcf_woBQSR/gatk3_HaplotypeCaller_vcf_tbi
      nthreads: nthreads
      reference: reference
      reference_fai: reference_fai
      reference_dict: reference_dict
      outprefix: outprefix
    out: [out_vcf, out_vcf_tbi, log]
      
  bcftools_concat:
    label: bcftools_concat
    doc: Concatenate VCF files
    run: ../Tools/bcftools-concat.cwl
    in:
      vcf_files:
        - gatk3_SelectVariants_PAR1/out_vcf
        - gatk3_HaplotypeCaller_XCORE_ploidy1/vcf
        - gatk3_SelectVariants_PAR2/out_vcf
        - gatk3_HaplotypeCaller_Y_ploidy1/vcf
      nthreads: nthreads
      outprefix: chrXY_outprefix
    out: [after_vcf]

  bcftools_index:
    label: bcftools_index
    doc: Make index for VCF file
    run: ../Tools/bcftools-index.cwl
    in:
      vcf: bcftools_concat/after_vcf
      nthreads: nthreads
    out: [vcf_tbi]
      
outputs:
  rmdup_bam:
    type: File
    format: edam:format_2572
    outputSource: bams2gvcf_woBQSR/rmdup_bam

  rmdup_bai:
    type: File
    outputSource: bams2gvcf_woBQSR/rmdup_bai

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
    
  gatk3_HaplotypeCaller_XCORE_ploidy1_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_HaplotypeCaller_XCORE_ploidy1/vcf

  gatk3_HaplotypeCaller_XCORE_ploidy1_vcf_tbi:
    type: File
    outputSource: gatk3_HaplotypeCaller_XCORE_ploidy1/vcf_tbi

  gatk3_HaplotypeCaller_XCORE_ploidy1_log:
    type: File
    outputSource: gatk3_HaplotypeCaller_XCORE_ploidy1/log

  gatk3_HaplotypeCaller_Y_ploidy1_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_HaplotypeCaller_Y_ploidy1/vcf

  gatk3_HaplotypeCaller_Y_ploidy1_vcf_tbi:
    type: File
    outputSource: gatk3_HaplotypeCaller_Y_ploidy1/vcf_tbi

  gatk3_HaplotypeCaller_Y_ploidy1_log:
    type: File
    outputSource: gatk3_HaplotypeCaller_Y_ploidy1/log

  gatk3_SelectVariants_PAR1_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_SelectVariants_PAR1/out_vcf

  gatk3_SelectVariants_PAR1_vcf_tbi:
    type: File
    outputSource: gatk3_SelectVariants_PAR1/out_vcf_tbi

  gatk3_SelectVariants_PAR1_log:
    type: File
    outputSource: gatk3_SelectVariants_PAR1/log

  gatk3_SelectVariants_PAR2_vcf:
    type: File
    format: edam:format_3016
    outputSource: gatk3_SelectVariants_PAR2/out_vcf

  gatk3_SelectVariants_PAR2_vcf_tbi:
    type: File
    outputSource: gatk3_SelectVariants_PAR2/out_vcf_tbi

  gatk3_SelectVariants_PAR2_log:
    type: File
    outputSource: gatk3_SelectVariants_PAR2/log

  bcftools_concat_vcf:
    type: File
    format: edam:format_3016
    outputSource: bcftools_concat/after_vcf

  bcftools_index_vcf_tbi:
    type: File
    outputSource: bcftools_index/vcf_tbi
