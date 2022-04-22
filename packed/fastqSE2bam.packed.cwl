{
    "$graph": [
        {
            "class": "CommandLineTool",
            "id": "#bwa-mem-SE.cwl",
            "label": "bwa-mem-SE-0.7.12",
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biocontainers/bwa:v0.7.12_cv3"
                }
            ],
            "requirements": [
                {
                    "class": "ShellCommandRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "ramMin": 6300
                }
            ],
            "baseCommand": [
                "bwa",
                "mem"
            ],
            "inputs": [
                {
                    "id": "#bwa-mem-SE.cwl/reference",
                    "type": "File",
                    "format": "http://edamontology.org/format_1929",
                    "inputBinding": {
                        "position": 4
                    },
                    "doc": "FastA file for reference genome",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".pac",
                        ".sa"
                    ]
                },
                {
                    "id": "#bwa-mem-SE.cwl/RG_ID",
                    "type": "string",
                    "doc": "Read group identifier (ID) in RG line"
                },
                {
                    "id": "#bwa-mem-SE.cwl/RG_PL",
                    "type": "string",
                    "doc": "Platform/technology used to produce the read (PL) in RG line"
                },
                {
                    "id": "#bwa-mem-SE.cwl/RG_PU",
                    "type": "string",
                    "doc": "Platform Unit (PU) in RG line"
                },
                {
                    "id": "#bwa-mem-SE.cwl/RG_LB",
                    "type": "string",
                    "doc": "DNA preparation library identifier (LB) in RG line"
                },
                {
                    "id": "#bwa-mem-SE.cwl/RG_SM",
                    "type": "string",
                    "doc": "Sample (SM) identifier in RG line"
                },
                {
                    "id": "#bwa-mem-SE.cwl/fq",
                    "type": "File",
                    "format": "http://edamontology.org/format_1930",
                    "inputBinding": {
                        "position": 5
                    },
                    "doc": "FastQ file from next-generation sequencers"
                },
                {
                    "id": "#bwa-mem-SE.cwl/nthreads",
                    "type": "int",
                    "inputBinding": {
                        "prefix": "-t",
                        "position": 3
                    },
                    "doc": "number of cpu cores to be used"
                },
                {
                    "id": "#bwa-mem-SE.cwl/outprefix",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#bwa-mem-SE.cwl/sam",
                    "type": "File",
                    "format": "http://edamontology.org/format_2573",
                    "outputBinding": {
                        "glob": "$(inputs.outprefix).sam"
                    }
                },
                {
                    "id": "#bwa-mem-SE.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.outprefix).sam.log"
                    }
                }
            ],
            "stdout": "$(inputs.outprefix).sam",
            "stderr": "$(inputs.outprefix).sam.log",
            "arguments": [
                {
                    "position": 1,
                    "prefix": "-K",
                    "valueFrom": "10000000"
                },
                {
                    "position": 2,
                    "prefix": "-R",
                    "valueFrom": "@RG\tID:$(inputs.RG_ID)\tPL:$(inputs.RG_PL)\tPU:$(inputs.RG_PU)\tLB:$(inputs.RG_LB)\tSM:$(inputs.RG_SM)"
                }
            ],
            "$namespaces": {
                "edam": "http://edamontology.org/"
            }
        },
        {
            "class": "CommandLineTool",
            "id": "#picard-SortSam.cwl",
            "label": "picard-SortSam-2.10.6",
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/biocontainers/picard:2.10.6--py27_0"
                }
            ],
            "requirements": [
                {
                    "class": "ShellCommandRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "ramMin": 6300
                }
            ],
            "baseCommand": [
                "java",
                "-jar",
                "/usr/local/share/picard-2.10.6-0/picard.jar",
                "SortSam"
            ],
            "inputs": [
                {
                    "id": "#picard-SortSam.cwl/sam",
                    "type": "File",
                    "format": "http://edamontology.org/format_2573",
                    "inputBinding": {
                        "prefix": "INPUT=",
                        "position": 1
                    },
                    "doc": "input SAM alignment file"
                },
                {
                    "id": "#picard-SortSam.cwl/outprefix",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#picard-SortSam.cwl/bam",
                    "type": "File",
                    "format": "http://edamontology.org/format_2572",
                    "outputBinding": {
                        "glob": "$(inputs.outprefix).bam"
                    }
                },
                {
                    "id": "#picard-SortSam.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.outprefix).bam.log"
                    }
                }
            ],
            "stderr": "$(inputs.outprefix).bam.log",
            "arguments": [
                {
                    "position": 2,
                    "valueFrom": "OUTPUT=$(inputs.outprefix).bam"
                },
                {
                    "position": 3,
                    "valueFrom": "TMP_DIR=$(inputs.outprefix).bam.temp"
                },
                {
                    "position": 4,
                    "valueFrom": "SORT_ORDER=coordinate"
                },
                {
                    "position": 5,
                    "valueFrom": "COMPRESSION_LEVEL=1"
                },
                {
                    "position": 6,
                    "valueFrom": "VALIDATION_STRINGENCY=LENIENT"
                }
            ]
        },
        {
            "class": "Workflow",
            "id": "#main",
            "label": "fastqSE2bam",
            "inputs": [
                {
                    "type": "string",
                    "doc": "Read group identifier (ID) in RG line",
                    "id": "#RG_ID"
                },
                {
                    "type": "string",
                    "doc": "DNA preparation library identifier (LB) in RG line",
                    "id": "#RG_LB"
                },
                {
                    "type": "string",
                    "doc": "Platform/technology used to produce the read (PL) in RG line",
                    "id": "#RG_PL"
                },
                {
                    "type": "string",
                    "doc": "Platform Unit (PU) in RG line",
                    "id": "#RG_PU"
                },
                {
                    "type": "string",
                    "doc": "Sample (SM) identifier in RG line",
                    "id": "#RG_SM"
                },
                {
                    "type": "File",
                    "format": "http://edamontology.org/format_1930",
                    "doc": "FastQ file from next-generation sequencers",
                    "id": "#fq"
                },
                {
                    "type": "int",
                    "doc": "number of cpu cores to be used",
                    "id": "#nthreads"
                },
                {
                    "type": "string",
                    "doc": "Output prefix name",
                    "id": "#outprefix"
                },
                {
                    "type": "File",
                    "format": "http://edamontology.org/format_1929",
                    "doc": "FastA file for reference genome",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".pac",
                        ".sa"
                    ],
                    "id": "#reference"
                }
            ],
            "steps": [
                {
                    "label": "bwa_mem_SE",
                    "doc": "Mapping onto reference using BWA MEM",
                    "run": "#bwa-mem-SE.cwl",
                    "in": [
                        {
                            "source": "#RG_ID",
                            "id": "#bwa_mem_SE/RG_ID"
                        },
                        {
                            "source": "#RG_LB",
                            "id": "#bwa_mem_SE/RG_LB"
                        },
                        {
                            "source": "#RG_PL",
                            "id": "#bwa_mem_SE/RG_PL"
                        },
                        {
                            "source": "#RG_PU",
                            "id": "#bwa_mem_SE/RG_PU"
                        },
                        {
                            "source": "#RG_SM",
                            "id": "#bwa_mem_SE/RG_SM"
                        },
                        {
                            "source": "#fq",
                            "id": "#bwa_mem_SE/fq"
                        },
                        {
                            "source": "#nthreads",
                            "id": "#bwa_mem_SE/nthreads"
                        },
                        {
                            "source": "#outprefix",
                            "id": "#bwa_mem_SE/outprefix"
                        },
                        {
                            "source": "#reference",
                            "id": "#bwa_mem_SE/reference"
                        }
                    ],
                    "out": [
                        "#/bwa_mem_SE/sam",
                        "#/bwa_mem_SE/log"
                    ],
                    "id": "#bwa_mem_SE"
                },
                {
                    "label": "picard_SortSam",
                    "doc": "Sort sam file and save as bam file",
                    "run": "#picard-SortSam.cwl",
                    "in": [
                        {
                            "source": "#outprefix",
                            "id": "#picard_SortSam/outprefix"
                        },
                        {
                            "source": "#/bwa_mem_SE/sam",
                            "id": "#picard_SortSam/sam"
                        }
                    ],
                    "out": [
                        "#/picard_SortSam/bam",
                        "#/picard_SortSam/log"
                    ],
                    "id": "#picard_SortSam"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "format": "http://edamontology.org/format_2572",
                    "outputSource": "#/picard_SortSam/bam",
                    "id": "#bam"
                },
                {
                    "type": "File",
                    "outputSource": "#/picard_SortSam/log",
                    "id": "#bam_log"
                },
                {
                    "type": "File",
                    "format": "http://edamontology.org/format_2573",
                    "outputSource": "#/bwa_mem_SE/sam",
                    "id": "#sam"
                },
                {
                    "type": "File",
                    "outputSource": "#/bwa_mem_SE/log",
                    "id": "#sam_log"
                }
            ]
        }
    ],
    "cwlVersion": "v1.0"
}