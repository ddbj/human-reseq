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
    ramMin: 8000

baseCommand: [ java, -Xmx8G, -jar, /picard-tools/picard.jar, CollectMultipleMetrics ]

inputs:
  - id: experimentID
    type: string
    doc: experiment ID for input FastQ file
  - id: sampleID
    type: string
    doc: sample ID for input FastQ file
  - id: centerID
    type: string
    doc: sequencing center ID for input FastQ file
  - id: marked.bam
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: "INPUT="
      position: 1
    doc: input BAM alignment file
  - id: fadir
    type: Directory
    doc: directory containing FastA file and index
  - id: ref
    type: string
    doc: name of reference (e.g., hs37d5)

outputs:
  - id: marked.bam.metrics
    type: File
    outputBinding:
      glob: $(inputs.experimentID).marked.bam.alignment_summary_metrics

arguments:
  - position: 2
    valueFrom: "OUTPUT=$(inputs.experimentID).marked.bam"
  - position: 3
    valueFrom: "REFERENCE_SEQUENCE=$(inputs.fadir.path)/$(inputs.ref).fa"
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
    valueFrom: "TMP_DIR=$(inputs.experimentID).s13.bam_metrics.temp"
  - position: 13
    valueFrom: "VALIDATION_STRINGENCY=LENIENT"
