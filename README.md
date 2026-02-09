# MOSTAR-ASM (Multimodal ONT and Short-read Tool for Assembly and Refinement)

<p align="center">
  <img src="assets/mostar_final.jpg" 
       width="100%" alt="MOSTAR-ASM Banner">
</p>
</p>

MOSTAR-ASM is a comprehensive bioinformatics pipeline designed to bridge the gap between long-read structural continuity and short-read base-pair accuracy. By integrating Oxford Nanopore Technologies (ONT) with Illumina sequencing, the pipeline reconstructs highly polished bacterial genomes through an automated de novo assembly, functional annotation as well as AMR profiling. The pipeline is compatible with all Unix-based operating systems, in addition to M-series Apple Silicone (see workarround below).  

The pipeline performs the following with minimal input from the user:
1. Dual-Stage QC: Automated adapter trimming (fastp) and length-based long-read filtering (Filtlong).
2. De Novo Assembly: High-performance assembly using Flye's nano-hq parameters.
3. Long-read consensus correction with Medaka
4. Short-read structural polishing via BWA and Polypolish.
5. Annotation (optional): Full functional annotation with PROKKA.
6. NCBI AMRFinder+ resistance profile 
7. Generates standardized GFF3, GBK, tsv, and FASTA outputs.

# Requirements and input files
<pre>
1. ONT-reads 
2. Illumina paired end reads (R1/R2)
3. Model (Very important!) (Default: r1041_e82_400bps_sup_v5.2.0) 
  
Optional (if running PROKKA)
1. Genbank reference sequence 
</pre>

# Packages & Dependencies (installed by yml)
<pre>
1. Fastp
2. Flye
3. Medaka
4. BWA
5. AMRFinder+
6. PROKKA
7. Polypolish
8. Filtlong
9. Samtools
10. Minimap2
</pre>  

# Installation (Conda or Mamba)
<pre>
Clone the repository:
git clone https://github.com/nermze/MOSTAR-ASM.git

Change dir:
cd MOSTAR-ASM

Create a conda env with all dependencies from the provided yml:
conda env create -f environment.yml

Activate the environment:
conda activate mostar-env

Install using pip:
pip install . 

### Important! ###
Download AMRFinder+ database: 
amrfinder -u
</pre>

# Apple Silicone Users:
<pre>
Please create the environment using Intel-emulation (Rosetta 2) with the following command:
  
CONDA_SUBDIR=osx-64 conda env create -f environment.yml
conda activate mostar_env
conda config --env --set subdir osx-64
</pre>

# Basic Usage:
<pre>
Assembly & polish:
mostar -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -o results

Assembly, polish and annotate:
mostar -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -a reference.gbk -o results
</pre>

### Command-Line Arguments
| Flag | Name | Description |
| :--- | :--- | :--- |
| `-1` | Illumina R1 | Forward short-reads (.fastq.gz) |
| `-2` | Illumina R2 | Reverse short-reads (.fastq.gz) |
| `-n` | ONT Reads | Nanopore long-reads (.fastq.gz) |
| `-g` | Genome Size | Estimated size (e.g., 2.1m) |
| `-a` | Reference | (Optional) Reference .gbk for Prokka |
| `-o` | Output | Directory name for output files |

### Output and folder structure
| File | Type | Description |
| :--- | :--- | :--- |
| `1` | amr_results | NCBI AMRFinder+ results |
| `2` | annotation | Annotations by PROKKA |
| `3` | flye | De-novo assembly |
| `4` | Intermediate  | Temporary and intermediate files |
| `5` | Logs | Run log |
| `6` | MEDAKA | Consensus sequence |
| `7` | MOSTAR_Assembly.fasta | Final polished genome. |

# Troubleshooting and known issues
Q: My assembly is poor
A: You have to specify the correct expected genome size (-g) and model r1041.XX (-m)

Q: My assembly is still failing
A: Your input data might be too low quailty. Try more robust trim settings.  

Q: Im getting an index-error during assembly with Flye
A: You are using the same output folder from a previous run. Please specify a new output folder with (-o), or rename/move/delete the old one. 

Q. My exact model is not accepted 
A. you may need to downgrade medaka or install a specific version. You can do this by typing: conda install -c bioconda medaka=your_version, example medaka=2.2.0 

Q. I'm experiencing issues with annotations using Apple silicone (M-series)
A. Skip the annotation step and annotate the final polished fasta manually

# Maintainer and author
[![GitHub](https://img.shields.io/badge/GitHub-nermze-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/nermze)

Developed and maintained by **Nermin Zecic** ([@nermze](https://github.com/nermze)). 
For questions, bugs, or feature requests, please open an [Issue](https://github.com/nermze/HyPol-ASM/issues).
