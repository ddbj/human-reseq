# Human Re-sequencing Data Analysis

This repository includes several workflows written in Common Workflow Language (CWL) for human resequence data analysis. Before running this workflow, please read GATK3 license, especially for non-academic users. https://software.broadinstitute.org/gatk/about/license.html


## Input FastQ file(s) and output BAM file

- Workflows/fastqPE2bam.cwl ... This workflow maps paired-end (PE) fastq files on a human reference genome using BWA MEM (version 0.7.12) and outputs a SAM file. Then, the SAM file was converted into BAM file using picard SortSam command (version 2.10.6). 

- 


## Acknowledgment
We thank Dr. Shu Tadaka for providing pipeline codes via GitHub (https://github.com/gpc-gr/panel3552-scripts). 
