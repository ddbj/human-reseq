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
    type: int?
    default: 1
    doc: number of cpu cores to be used    
  num_gpus:
    type: int?

steps:
  fq2bam_bqsr:
    label: fq2bam_bqsr
    run: ../Tools/parabricks-fq2bam.cwl
    in:
      reference: reference
      fqs: fqs
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
      outprefix:
        source: outprefix
        valueFrom: $(self).bqsr
      num_gpus: num_gpus
    out:
      [bam, recal, dup_metrics, log]
  applybqsr:
    label: applybqsr
    run: ../Tools/parabricks-applybqsr.cwl
    in:
      reference: reference
      in_bam: fq2bam_bqsr/bam
      recal: fq2bam_bqsr/recal
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
      bqsr_table_before: fq2bam_bqsr/recal
      bqsr_table_after: second_bqsr/recal
    out: [bqsr_pdf, log]
#  picard_CollectMultipleMetrics:
#    label: picard_CollectMultipleMetrics
#    doc: Collect multiple metrics using picard
#    run: ../Tools/picard-CollectMultipleMetrics.cwl
#    in:
#      in_bam: applybqsr/out_bam
#      reference: reference
#    out: [alignment_summary_metrics, insert_size_metrics, log]
#  samtools_flagstat:
#    label: samtools_flagstat
#    doc: Calculate flagstat using samtools
#    run: ../Tools/samtools-flagstat.cwl
#    in:
#      in_bam: applybqsr/out_bam
#      nthreads: num_threads
#    out: [flagstat]
#  samtools_idxstats:
#    label: samtools_idxstats
#    doc: Calculate idxstats using samtools
#    run: ../Tools/samtools-idxstats.cwl
#    in:
#      in_bam: applybqsr/out_bam
#    out: [idxstats]
#  picard_CollectWgsMetrics_autosome:
#    label: picard_CollectWgsMetrics
#    doc: Collect WGS metrics using picard
#    run: ../Tools/picard-CollectWgsMetrics.cwl
#    in:
#      in_bam: applybqsr/out_bam
#      reference: reference
#      reference_interval_name: reference_interval_name_autosome
#      reference_interval_list: reference_interval_list_autosome
#    out: [wgs_metrics, log]
#  picard_CollectWgsMetrics_chrX:
#    label: picard_CollectWgsMetrics
#    doc: Collect WGS metrics using picard
#    run: ../Tools/picard-CollectWgsMetrics.cwl
#    in:
#      in_bam: applybqsr/out_bam
#      reference: reference
#      reference_interval_name: reference_interval_name_chrX
#      reference_interval_list: reference_interval_list_chrX
#    out: [wgs_metrics, log]
#  picard_CollectWgsMetrics_chrY:
#    label: picard_CollectWgsMetrics
#    doc: Collect WGS metrics using picard
#    run: ../Tools/picard-CollectWgsMetrics.cwl
#    in:
#      in_bam: applybqsr/out_bam
#      reference: reference
#      reference_interval_name: reference_interval_name_chrY
#      reference_interval_list: reference_interval_list_chrY
#    out: [wgs_metrics, log]
#    

outputs:
  bam:
    type: File
    format: edam:format_2572
    outputSource: applybqsr/out_bam
#  recal:
#    type: File
#    outputSource: parabricks-fq2bam/recal
#  dup_metrics:
#    type: File
#    outputSource: parabricks-fq2bam/dup_metrics
#  log:
#    type: File
#    outputSource: parabricks-fq2bam/log
#
