# HyPol-ASM

HyPol-ASM is a streamlined bioinformatics pipeline designed for assembly of bacterial genomes. By leveraging the long-read capabilities of Oxford Nanopore Technologies (ONT) and the high base-pair accuracy of Illumina short-reads, it produces both a highly polished fasta in addition to all the annotaion files with PROKKA. 

The HyPol-ASM pipeline performs the following steps:
1. Dual-Stage QC: Automated adapter trimming (fastp) and length-based long-read filtering (Filtlong).
2. De Novo Assembly: High-performance assembly using Flye's nano-hq parameters.
3. Multi-Step Polishing: Long-read consensus correction with Medaka followed by short-read structural polishing via BWA and Polypolish.
4. Automated Annotation: Full functional annotation with Prokka. 
5. Generates standardized GFF3, GBK, and FASTA outputs.

# Installation(Bioconda)
<pre>
Clone the repository:
git clone https://github.com/nermze/HyPol-ASM.git

Change dir:
cd HyPol-ASM

Create a conda env with all dependencies from the provided yml:
conda env create -f environment.yml

Activate the environment:
conda activate hypol-env

Install using pip:
pip install . 
</pre>

Basic Usage:
<pre>
hypol-asm -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -o results
</pre>

Recuired arguments:
### Command-Line Arguments

| Flag | Argument | Default | Description |
| :--- | :--- | :--- | :--- |
| **`-1`** | `<file>` | **Required** | Forward Illumina short-reads (`.fastq.gz`) |
| **`-2`** | `<file>` | **Required** | Reverse Illumina short-reads (`.fastq.gz`) |
| **`-n`** | `<file>` | **Required** | Nanopore long-reads (`.fastq.gz`) |
| **`-g`** | `<string>` | **Required** | Estimated genome size (e.g., `2.1m` or `5.0m`) |
| **`-o`** | `<path>` | **Required** | Output directory for all results |
| **`-a`** | `<file>` | `None` | Optional: Reference GenBank/FASTA for Prokka annotation |
| **`-t`** | `<int>` | `10` | Number of CPU threads to utilize |
| **`-m`** | `<string>` | `r1041...` | Medaka model (must match ONT chemistry) |
| **`-h`** | N/A | N/A | Display this help menu and exit |
