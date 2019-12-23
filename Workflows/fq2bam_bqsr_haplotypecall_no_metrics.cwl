#!/usr/bin/env cwl-runner

class: Workflow
id: fq2bam_bqsr_haplotypecall_no_metrics
label: fq2bam_bqsr_haplotypecall_no_metrics
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
    run: ../Tools/parabricks-fq2bam.cwl
    in:
      reference: reference
      fqs: fqs
      dbsnp: dbsnp
      mills_indel: mills_indel
      onek_indel: onek_indel
      outprefix: outprefix
      num_gpus: num_gpus
    out:
      [bam, recal, dup_metrics, log]
  applybqsr:
    label: applybqsr
    run: ../Tools/parabricks-applybqsr.cwl
    in:
      reference: reference
      in_bam: fq2bam/bam
      recal: fq2bam/recal
      outprefix:
        source: outprefix
        valueFrom: $(self).bqsr
      num_threads: num_threads
      num_gpus: num_gpus
    out: [out_bam, log]
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
