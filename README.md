# HyPol-ASM

HyPol-ASM is a streamlined bioinformatics pipeline designed for assembly of bacterial genomes. By leveraging the long-read capabilities of Oxford Nanopore Technologies (ONT) and the high base-pair accuracy of Illumina short-reads, it produces both a highly polished fasta in addition to all the annotaion files with PROKKA. 

The HyPol-ASM pipeline performs the following steps:
1. Dual-Stage QC: Automated adapter trimming (fastp) and length-based long-read filtering (Filtlong).
2. De Novo Assembly: High-performance assembly using Flye's nano-hq parameters.
3. Multi-Step Polishing: Long-read consensus correction with Medaka followed by short-read structural polishing via BWA and Polypolish.
4. Automated Annotation: Full functional annotation with Prokka. 
5. Generates standardized GFF3, GBK, and FASTA outputs.

Installation (Conda or Mamba)

# Clone the repository
git clone https://github.com/nermze/HyPol-ASM.git
# Change dir 
cd HyPol-ASM

# Create a conda env with all dependencies from the provided yml
conda env create -f environment.yml

# Activate the environment
conda activate hypol-env

# Install using pip
pip install . 


Basic usage:
hypol-asm -1 R1.fastq.gz -2 R2.fastq.gz -n ont_reads.fastq.gz -g 2.1m -o my_assembly_output

Recuired arguments:
Flag  Argument    Description
-1   <file>       # Path to Illumina Forward reads (R1.fastq.gz)
-2   <file>       # Path to Illumina Reverse reads (R2.fastq.gz)
-n   <file>       # Path to Nanopore long reads (fastq.gz)
-g   <size>       # Estimated genome size (e.g., 2.1m, 5.0m)
-o   <path>       # Specify name of output directory 

Optional arguments: 
Flag  Argument  Default  Description
-a	<file>	    None	   # Path to reference .gbk
-t  <int>       10       # Number of CPU threads
-m  <model>     r1041    # Medaka model (match your ONT flowcell/kit)
-h  N/A         N/A      # Display the help menu
