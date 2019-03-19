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
  - Metrics for the merged BAM file were calculated using samtools (1.6), picard CollectMultipleMetrics (version 2.18.23), and picard CollectWgsMetrics (version 2.10.6). 
  - Variants were called using gatk3 HaplotypeCaller (version 3.7.0) with ploidy=2 option. A genomic VCF file will be output. 

- Workflows/bams2gvcf.woBQSR_male.cwl
  - This workflow takes as input a list of BAM files and outpus two genomic VCF file (one VCF file is for autosome variants, and another is for sex chromosome variants). This workflow does not perform base quality recalibration. This workflow assumes that the target sample is male. 
  - PCR duplicons were removed using picard MarkDuplicates (version 2.10.6), which outputs a BAM file.  
  - Metrics for the merged BAM file were calculated using samtools (1.6), picard CollectMultipleMetrics (version 2.18.23), and picard CollectWgsMetrics (version 2.10.6). 
  - Variants on autosomes were called using gatk3 HaplotypeCaller (version 3.7.0) with ploidy=2 option. A genomic VCF file for autosome variants will be output.
  - Variants on sex chromosomes were called using gatk3 HaplotypeCaller (version 3.7.0) with ploidy=2 option for PAR regions and with ploidy=1 option for non-PAR regions. A genomic VCF file for sex chromosome (X/Y) variants will be output.


## Acknowledgment
We thank Dr. Shu Tadaka for providing pipeline codes via GitHub (https://github.com/gpc-gr/panel3552-scripts). 
