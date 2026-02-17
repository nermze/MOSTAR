<p align="center">
  <img src="assets/mostar_final.jpg" 
       width="100%" alt="MOSTAR-ASM Banner">
</p>
</p>

# MOSTAR-ASM (Multimodal ONT and Short-read Tool for Assembly and Refinement)

MOSTAR-ASM is a comprehensive bioinformatics pipeline designed to bridge the gap between long-read structural continuity and short-read base-pair accuracy. By integrating Oxford Nanopore Technologies (ONT) with Illumina sequencing, the pipeline reconstructs highly polished bacterial genomes. It performs hybrid and long-read assemblies, polishing, functional annotation, AMR profiling, and taxonomic classification — with built-in quality controls and an interactive HTML report. 

# Hybrid assembly: Combines ONT long reads and Illumina short reads for high-quality assemblies
1. Trimming: Filtlong 
2. Polishing: Medaka for long-read polishing; Polypolish for hybrid polishing
3. Assembly: De-Novo Assembly with Flye
4. Trimming: FastP for adapter and QC trimming of short reads
5. Taxonomic profiling: EMU-based species identification with automatic database handling
6. Functional annotation: PROKKA annotation with customizable protein/GenBank references
7. AMR profiling: NCBI AMRFinder+ integration for detecting antimicrobial resistance genes
8. Comprehensive report: Generates a detailed HTML report with metrics, top taxa, and AMR results

# ONT-only
1. Quality filter with Filtlong
2. De-novo assembly with Flye
3. Long-read consensus correction with Medaka
4. Functional Annotation with PROKKA (optional)
6. NCBI AMRFinder+ resistance profile 
8. Complete report in HTML-format


# Requirements and input files
<pre>
1. ONT-reads 
2. Illumina paired end reads (R1/R2) (Optional)
3. Correct model (Very important!) (Default: r1041_e82_400bps_sup_v5.2.0) 
  
Functional Annotation with PROKKA (Optional)
1. Genbank reference sequence 

Taxonomic Classification with EMU 
1. Specify EMU-db path


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
# Clone the repository:
git clone https://github.com/nermze/MOSTAR-ASM.git

# Change dir:
cd MOSTAR-ASM

# Create a conda env with all dependencies from the provided yml:
conda env create -f environment.yml

# Activate the environment:
conda activate mostar-env

# Install using pip:
pip install . 

### Important! ###
Download AMRFinder+ database: 
amrfinder -u
</pre>

# Apple Silicone Users:
<pre>
Please create the environment using Intel-emulation (Rosetta 2) before install:
  
CONDA_SUBDIR=osx-64 conda env create -f environment.yml
conda activate mostar_env
conda config --env --set subdir osx-64
</pre>

# Basic Usage:
<pre>
# Hybrid Assembly, Polish & AMR
mostar -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -o results

# Hybrid Assembly, Polish, AMR, Annotate & Taxonomy:
mostar -1 R1.fastq.gz -2 R2.fastq.gz -n long_reads.fastq.gz -g 2.1m -a reference.gbk --o results


</pre>

### Command-Line Arguments
| Flag | Name | Description |
| :--- | :--- | :--- |
| `-n` | ONT Reads | Nanopore long-reads (.fastq.gz) |
| `-1` | Illumina R1 | Forward short-reads (.fastq.gz) |
| `-2` | Illumina R2 | Reverse short-reads (.fastq.gz) |
| `-m` | Medaka model | Default: r1041_e82_400bps_sup_v5.2.0) |
| `-g` | Genome Size | Estimated size (e.g., 2.1m) |
| `-p` | Organism | AMRFinder+ (e.g., Escherichia, Staphylococcus) |
| `-o` | Output | Directory name for output files |
| `-a` | Reference | (Optional) Reference .gbk for Prokka |
| `-f` | Output | Directory name for output files |
| `-c` | Output | Directory name for output files |
| `-i` | Output | Directory name for output files |
| `-x` | Output | Directory name for output files |



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
