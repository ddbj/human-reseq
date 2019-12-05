#!/usr/bin/env cwl-runner

class: Workflow
id: fq2bam_bqsr_haplotypecall
label: fq2bam_bqsr_haplotypecall
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

requirements:
  - class: StepInputExpressionRequirement

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
  fqs:
    type:
      type: array
      items:
        type: record
        fields:
          - name: read1
            type: File # seems file format cannot be specified
          - name: read2
            type: File # seems file format cannot be specified
          - name: read_group
            type:
              - type: record
                fields:
                  - name: RG_ID
                    type: string
                    doc: Read group identifier (ID) in RG line
                  - name: RG_PL
                    type: string
                    doc: Platform/technology used to produce the read (PL) in RG line
                  - name: RG_PU
                    type: string
                    doc: Platform Unit (PU) in RG line
                  - name: RG_LB
                    type: string
                    doc: DNA preparation library identifier (LB) in RG line
                  - name: RG_SM
                    type: string
                    doc: Sample (SM) identifier in RG line
    doc: FastQ file from next-generation sequencers
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
  outprefix:
    type: string
  num_threads:
    type: int
    default: 1
    doc: number of cpu cores to be used    
  num_gpus:
    type: int?

steps:
  fq2bam:
    label: fq2bam
    run: ../Tools/parabricks-fq2bam-without-bqsr.cwl
    in:
      reference: reference
      fqs: fqs
      outprefix: outprefix
      num_gpus: num_gpus
    out:
      [bam, dup_metrics, log]
  first_bqsr:
    label: first_bqsr
    run: ../Tools/parabricks-bqsr.cwl
    in:
      reference: reference
      bam: fq2bam/bam
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
      outprefix:
        source: outprefix
        valueFrom: $(self).bqsr
      num_gpus: num_gpus
    out: [recal, log]
  applybqsr:
    label: applybqsr
    run: ../Tools/parabricks-applybqsr.cwl
    in:
      reference: reference
      in_bam: fq2bam/bam
      recal: first_bqsr/recal
      outprefix:
        source: outprefix
        valueFrom: $(self).bqsr
      num_threads: num_threads
      num_gpus: num_gpus
    out: [out_bam, log]
  second_bqsr:
    label: second_bqsr
    run: ../Tools/parabricks-bqsr.cwl
    in:
      reference: reference
      bam: applybqsr/out_bam
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
      outprefix:
        source: outprefix
        valueFrom: $(self).second_bqsr
      num_gpus: num_gpus
    out: [recal, log]
  analyze_covariates:
    label: analyze_covariates
    run: ../Tools/gatk4-AnalyzeCovariates.cwl
    in:
      bqsr_table_before: first_bqsr/recal
      bqsr_table_after: second_bqsr/recal
    out: [pdf, log]
  picard_CollectMultipleMetrics:
    label: picard_CollectMultipleMetrics
    doc: Collect multiple metrics using picard
    run: ../Tools/picard-CollectMultipleMetrics.cwl
    in:
      in_bam: applybqsr/out_bam
      reference: reference
    out: [alignment_summary_metrics, insert_size_metrics, log]
  samtools_flagstat:
    label: samtools_flagstat
    doc: Calculate flagstat using samtools
    run: ../Tools/samtools-flagstat.cwl
    in:
      in_bam: applybqsr/out_bam
      nthreads: num_threads
    out: [flagstat]
  samtools_idxstats:
    label: samtools_idxstats
    doc: Calculate idxstats using samtools
    run: ../Tools/samtools-idxstats-x.cwl
    in:
      in_bam: applybqsr/out_bam
    out: [idxstats]
  picard_CollectWgsMetrics_autosome:
    label: picard_CollectWgsMetrics
    doc: Collect WGS metrics using picard
    run: ../Tools/picard-CollectWgsMetrics.cwl
    in:
      in_bam: applybqsr/out_bam
      reference: reference
      reference_interval_name: reference_interval_name_autosome
      reference_interval_list: reference_interval_list_autosome
    out: [wgs_metrics, log]
  picard_CollectWgsMetrics_chrX:
    label: picard_CollectWgsMetrics
    doc: Collect WGS metrics using picard
    run: ../Tools/picard-CollectWgsMetrics.cwl
    in:
      in_bam: applybqsr/out_bam
      reference: reference
      reference_interval_name: reference_interval_name_chrX
      reference_interval_list: reference_interval_list_chrX
    out: [wgs_metrics, log]
  picard_CollectWgsMetrics_chrY:
    label: picard_CollectWgsMetrics
    doc: Collect WGS metrics using picard
    run: ../Tools/picard-CollectWgsMetrics.cwl
    in:
      in_bam: applybqsr/out_bam
      reference: reference
      reference_interval_name: reference_interval_name_chrY
      reference_interval_list: reference_interval_list_chrY
    out: [wgs_metrics, log]
  haplotypecall:
    label: parabricks_haplotypecaller
    doc: Haplotype calling using parabricks haplotypecaller
    run: ../Tools/parabricks-haplotypecaller.cwl
    in:
      reference: reference
      bam: applybqsr/out_bam
      outprefix: outprefix
      num_gpus: num_gpus
    out: [vcf, log]

outputs:
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
  first_bqsr_table:
    type: File
    outputSource: first_bqsr/recal
  first_bqsr_log:
    type: File
    outputSource: first_bqsr/log
  second_bqsr_table:
    type: File
    outputSource: second_bqsr/recal
  second_bqsr_log:
    type: File
    outputSource: second_bqsr/log
  analyze_covariates_pdf:
    type: File
    outputSource: analyze_covariates/pdf
  analyze_covariates_log:
    type: File
    outputSource: analyze_covariates/log
  applybqsr_bam:
    type: File
    outputSource: applybqsr/out_bam
  applybqsr_log:
    type: File
    outputSource: applybqsr/log
  haplotypecall_vcf:
    type: File
    format: edam:format_3016
    outputSource: haplotypecall/vcf
  haplotypecall_log:
    type: File
    format: edam:format_3016
    outputSource: haplotypecall/log
