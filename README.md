<p align="center">
  <img src="assets/mostar_final.jpg" 
       width="100%" alt="MOSTAR-ASM Banner">
</p>
</p>

# MOSTAR-Pipeline

### Multimodal ONT and Short-read Tool for Assembly and Refinement
MOSTAR is a comprehensive bioinformatics pipeline designed to bridge the gap between long-read structural continuity and short-read base-pair accuracy. By integrating Oxford Nanopore Technologies (ONT) with Illumina sequencing, the pipeline reconstructs highly polished bacterial genomes. It performs hybrid and long-read assemblies, polishing, functional annotation, AMR profiling, and taxonomic classification — with built-in quality controls and an interactive HTML report. However, if short-reads are omitted, the pipeline will auto-switch to ONT-only mode. The pipeline will work with any bacteria, as long as the genome size and correct ONT model are specified. 

Note: Some settings are hard-coded in the intial release of the pipeline, but several of the included tools can be fine-tuned by passing optional arguments. 

### Hybrid assembly: Combines ONT long reads and Illumina short reads for high-quality assemblies
1. Short-read quality trimming: FastP for adapter & QC trimming
2. Long-read quality trimming: Filtlong for QC trimming 
3. Taxonomic profiling: EMU-based species identification with automatic database handling
4. Assembly: De-Novo Assembly with Flye
5. Polishing: Medaka for long-read polishing; Polypolish for hybrid polishing
6. Functional annotation: PROKKA annotation with customizable protein/GenBank references
7. AMR profiling: NCBI AMRFinder+ integration for detecting antimicrobial resistance genes
8. Comprehensive report: Generates a detailed HTML report with metrics, top taxa, and AMR results

### ONT-only assembly:
1. Long-read quality trimming: Filtlong 
2. Taxonomic profiling: EMU-based species identification with automatic database handling
3. De-novo assembly with Flye
4. Long-read consensus correction with Medaka
5. Functional annotation: PROKKA annotation with customizable protein/GenBank references
6. NCBI AMRFinder+ resistance profile 
8. Complete report in HTML-format


### Requirements and input files
<pre>
# In its simplest form, MOSTAR requires only 
1. ONT-reads 
2. Illumina paired end reads (R1/R2) (Optional)
3. Correct model (Very important!) (Default: r1041_e82_400bps_sup_v5.2.0)
4. Output folder 

# Hybrid mode: 
mostar -n ont.fq.gz -g [size] -o [dir]  -1 R1.fq -2 R2.fq

# Include EMU taxonomy, functional annotation with Prokka, and specify organism for AMRFinder+
# Remember to change (-g), (-m) and (-o) to match your organism, here we use Haemophilus influenzae as an example

mostar -n ont_read.fastq.gz -1 read1.fastq.gz -2 read2.fastq.gz -g 2.1m -o Output -a L42023.1.gb -p Haemophilus_influenzae -k ./emu_db -m r1041_e82_400bps_sup_v5.2.0

# To run the pipeline in ONT-only mode, just omit read1/read2. 
# ONT-only mode:
mostar -n ont.fq.gz -g [size] -o [dir] 
  
</pre>

### Output files
A successfull run wil contain the following, including the final polished fasta and html-report.
<pre>
  Output_folder
  |- amr_results
  |- annotation
  |- flye
  |- intermediate
  |- logs
  |- medaka
  |- MOSTAR_Assembly.fasta
  |- MOSTAR_Final_Report.html
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
git clone https://github.com/nermze/MOSTAR.git

# Change dir:
cd MOSTAR

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

### Command-Line Arguments
| Flag | Name | Description |
| :--- | :--- | :--- |
| `-n` | ONT Reads | Nanopore long-reads (.fastq.gz) |
| `-1` | Illumina R1 | Forward short-reads (.fastq.gz) |
| `-2` | Illumina R2 | Reverse short-reads (.fastq.gz) |
| `-m` | Model | Default: r1041_e82_400bps_sup_v5.2.0) |
| `-g` | Genome Size | Estimated size (e.g., 2.1m) |
| `-p` | AMRFinder+ | Organism (e.g., Escherichia, Staphylococcus) |
| `-o` | Output | Directory name for output files |
| `-f` | Filtlong | Target coverage (Default:100) |
| `-a` | Prokka | Reference .gbk for Prokka 
| `-c` | Coverage | Minimum coverage for Prokka (Default: 80) |
| `-i` | Identity | e-value for Prokka (Default: 1e-09) |
| `-x` | Cleanup | Delete intermediate files |
| `-h` | Help | Show help menu |


# Troubleshooting and known issues
Q: My assembly is poor
A: You have to specify the correct expected genome size (-g) and model example r1041.XX (-m)

Q: My assembly is still failing
A: Your input data might be too low quailty. Try more robust trim settings.  

Q: Im getting an index-error during assembly with Flye
A: You are using the same output folder from a previous run. Please specify a new output folder with (-o), or rename/move/delete the old one. 

Q. My exact model is not accepted 
A. you may need to downgrade medaka or install a specific version. You can do this by typing: conda install -c bioconda medaka=your_version, example medaka=2.2.0 

Q. I'm experiencing issues with annotations using Apple silicone (M-series)
A. This is a known issue stemming from blastn

# Maintainer and author
[![GitHub](https://img.shields.io/badge/GitHub-nermze-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/nermze)

Developed and maintained by **Nermin Zecic** ([@nermze](https://github.com/nermze)). 
For questions, bugs, or feature requests, please open an [Issue](https://github.com/nermze/mostar/issues).
