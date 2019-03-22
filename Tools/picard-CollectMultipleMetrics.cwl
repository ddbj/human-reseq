#!/usr/bin/env cwl-runner

class: CommandLineTool
id: picard-CollectMultipleMetrics-2.18.23
label: picard-CollectMultipleMetrics-2.18.23
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/broadinstitute/picard:2.18.23'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 32000

baseCommand: [ java, -Xmx12G, -jar, /picard-tools/picard.jar, CollectMultipleMetrics ]

inputs:
  - id: in_bam
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: "INPUT="
      position: 1
    doc: input BAM alignment file
  - id: reference
    type: File
    format: edam:format_1929
    inputBinding:
      prefix: "REFERENCE_SEQUENCE="
      position: 3
    doc: FastA file for reference genome

outputs:
  - id: alignment_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.in_bam.basename).collect_multiple_metrics.alignment_summary_metrics
    secondaryFiles:
      - ^.bait_bias_detail_metrics
      - ^.bait_bias_summary_metrics
      - ^.base_distribution_by_cycle_metrics
      - ^.base_distribution_by_cycle.pdf
      - ^.error_summary_metrics
      - ^.gc_bias.detail_metrics
      - ^.gc_bias.pdf
      - ^.gc_bias.summary_metrics
      - ^.insert_size_histogram.pdf
      - ^.insert_size_metrics
      - ^.pre_adapter_detail_metrics
      - ^.pre_adapter_summary_metrics
      - ^.quality_by_cycle_metrics
      - ^.quality_by_cycle.pdf
      - ^.quality_distribution_metrics
      - ^.quality_distribution.pdf
  - id: log
    type: stderr

stderr: $(inputs.in_bam.basename).collect_multiple_metrics.log

arguments:
  - position: 2
    valueFrom: "OUTPUT=$(inputs.in_bam.basename).collect_multiple_metrics"
  - position: 4
    valueFrom: "PROGRAM=null"
  - position: 5
    valueFrom: "PROGRAM=CollectAlignmentSummaryMetrics"
  - position: 6
    valueFrom: "PROGRAM=CollectInsertSizeMetrics"
  - position: 7
    valueFrom: "PROGRAM=QualityScoreDistribution"
  - position: 8
    valueFrom: "PROGRAM=MeanQualityByCycle"
  - position: 9
    valueFrom: "PROGRAM=CollectBaseDistributionByCycle"
  - position: 10
    valueFrom: "PROGRAM=CollectGcBiasMetrics"
  - position: 11
    valueFrom: "PROGRAM=CollectSequencingArtifactMetrics"
  - position: 12
    valueFrom: "TMP_DIR=temp"
  - position: 13
    valueFrom: "VALIDATION_STRINGENCY=LENIENT"
