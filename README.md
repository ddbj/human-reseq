# Human Re-sequencing Data Analysis

This repository includes several workflows written in Common Workflow Language (CWL) for human resequence data analysis. Before running this workflow, please read GATK3 license, especially for non-academic users. https://software.broadinstitute.org/gatk/about/license.html


## From FastQ file(s) to a BAM file

- Workflows/fastqPE2bam.cwl
  - This workflow takes as input paired-end (PE) fastq files and outputs a BAM file.
  - PE fastq files were mapped onto a human reference genome using BWA MEM (version 0.7.12), which outputs a SAM file. 
  - Then, the SAM file was sorted and converted into BAM file using picard SortSam command (version 2.10.6). 

- Workflows/fastqSE2bam.cwl
  - This workflow takes as input a single-end (SE) fastq files and outputs a BAM file.
  - SE fastq file was mapped onto a human reference genome using BWA MEM (version 0.7.12), which outputs a SAM file. 
  - Then, the SAM file was sorted and converted into BAM file using picard SortSam command (version 2.10.6). 

## From BAM file(s) to a genomic VCF file

- Workflows/bams2gvcf.woBQSR_female.cwl
  - This workflow takes as input a list of BAM files and outpus a genomic VCF file. This workflow does not perform base quality recalibration. This workflow assumes that the target sample is female. 
  - PCR duplicons were removed using picard MarkDuplicates (version 2.10.6), which outputs a BAM file.  
  - 


## Acknowledgment
We thank Dr. Shu Tadaka for providing pipeline codes via GitHub (https://github.com/gpc-gr/panel3552-scripts). 
