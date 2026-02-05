# MOSTAR-ASM (Multimodal ONT and Short-read Tool for Assembly and Refinement)

MOSTAR-ASM is a comprehensive bioinformatics pipeline designed to bridge the gap between long-read structural continuity and short-read base-pair accuracy. By integrating Oxford Nanopore Technologies (ONT) with Illumina sequencing, the pipeline reconstructs highly polished bacterial genomes through an automated de novo assembly, annotation and AMR profiling.  

The HyPol-ASM pipeline performs the following steps:
1. Dual-Stage QC: Automated adapter trimming (fastp) and length-based long-read filtering (Filtlong).
2. De Novo Assembly: High-performance assembly using Flye's nano-hq parameters.
3. Multi-Step Polishing: Long-read consensus correction with Medaka followed by short-read structural polishing via BWA and Polypolish.
4. Automated Annotation: Full functional annotation with Prokka.
5. Automated AMR: AMRFinder+ resistance profile (tsv)
6. Generates standardized GFF3, GBK, and FASTA outputs.

# Requirments (Installed by yml)
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

Basic Usage:
<pre>
Assembly & polish:
hypol-asm -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -o results

Assembly, polish and annotate:
hypol-asm -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -a reference.gbk -o results
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


# Output Structure

The pipeline produces the following output files depending on specified flags:
1. HyPol_Assembly.fasta: Final polished genome.
2. amr_results/AMR_Report.tsv: Detected AMR genes and virulence factors.
3. annotation/: Full functional annotation suite (GFF3, GBK, FAA).




# Maintaner and author
[![GitHub](https://img.shields.io/badge/GitHub-nermze-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/nermze)

Developed and maintained by **Nermin** ([@nermze](https://github.com/nermze)). 
For questions, bugs, or feature requests, please open an [Issue](https://github.com/nermze/HyPol-ASM/issues).
