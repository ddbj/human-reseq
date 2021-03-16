#!/bin/sh

# Download hg38 reference genome files (minimum)
curl -X GET -o Homo_sapiens_assembly38.fasta.alt "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.alt"
curl -X GET -o Homo_sapiens_assembly38.fasta.amb "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb"
curl -X GET -o Homo_sapiens_assembly38.fasta.ann "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann"
curl -X GET -o Homo_sapiens_assembly38.fasta.bwt "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt"
curl -X GET -o Homo_sapiens_assembly38.fasta.pac "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac"
curl -X GET -o Homo_sapiens_assembly38.fasta.sa "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa"
curl -X GET -o Homo_sapiens_assembly38.fasta.fai "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai"
curl -X GET -o Homo_sapiens_assembly38.fasta "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta"
curl -X GET -o Homo_sapiens_assembly38.dict "https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict"

