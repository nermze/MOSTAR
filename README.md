# MOSTAR - Modular ONT-Short-read Taxonomic Assembly and Resistome-Evolution pipeline
<p align="center">
  <img src="assets/mostar_final.jpg" 
       width="100%" alt="MOSTAR-ASM Banner">
</p>

### 
MOSTAR is comprehensive and complete bioinformatics pipeline for downstream analysis of whole-genome Oxford Nanopore sequencing data (ONT-reads). The pipeline constructs highly-polished genomes (using hybrid- or non-hybrid assembly), in addition to performing functional annotation, AMR profiling, ICE detection, and taxonomic classification — with built-in quality controls and an interactive HTML report.  The name Mostar is inspired by the historic Stari Most (Old Bridge) of Mostar, a symbol of connection and cultural resilience.  

MOSTAR has been developed and tested on *S. aureus*, *B. fragilis*, as well as *H. influenzae* strains, but will work with any bacteria, as long as the correct genome size and ONT model are specified. The pipeline contains some of the most well known tools in bioinformatics, and is designed to be a "one-stop shop" for most bacterial analysis. Finnaly the pipeline provides individual results and log files from every included tool. 

Note: Most settings are hard-coded in the initial release, however some of the key arguemnts are available to fine-tune the pipeline (see below). 

# Run mode 

#### ONT-only mode:
* Long-read quality trimming 
* De-novo assembly
* Long-read consensus correction
* AMR profiling
* Report

#### Hybrid mode - Additional steps if short-reads are provided:
* Short-read quality trimming
* Mapping short reads to conesensus
* Polishing using supplied short-reads

#### Optional tools
* Taxonomic profiling  
* Functional annotation
* Integrative and Conjugative Elements (ICEs)

### Output files
A successfull run wil contain the following output, including the final polished fasta, HTML-report, as well as individual output files and logs from all the included tools. 
<pre>
  Output_folder
  |- amr_results
  |- annotation
  |- flye
  |- ice_detection
  |- intermediate
  |- logs
  |- medaka
  |- taxonomy
  |- amr_summary.html
  |- MOSTAR_Final_Report.html
  |- MOSTAR_Assembly.fasta
</pre>

# Installation (Conda)
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

# Run MOSTAR and display help text
mostar -h
</pre>

#### Setup and download Databases
<pre> 
# Activate env (if not activated)
conda activate mostar-env 
  
# Download AMRFinder+ database: 
amrfinder -u

# Download bakta database (Specify light or full)
bakta_db download --output <output-path> --type [light|full]

# Download Kraken2 database
# To download the small pre-built db (any Kraken2 compatible DB will also work)
mkdir -p ~/kraken2_db && cd ~/kraken2_db
wget https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_08gb_20240904.tar.gz
tar -xvzf k2_pluspf_08gb_20240904.tar.gz
  
# Download standard EMU database
# The pipeline will auto-download the EMU-db if --emu-db is specified.
# If the automatic download fails, use the steps below
pip install osfclient
export EMU_DATABASE_DIR=<path_to_database>
cd ${EMU_DATABASE_DIR}
osf -p 56uf7 fetch osfstorage/emu-prebuilt/emu.tar
tar -xvf emu.tar
</pre> 

# Interactive HTML-report 
#### Species ID and QC-metrics for assembly
The report features key run-metrics, including assembly statistics and number of contigs. The report is dynamic and will adapt to user input, as some of the tools like taxonomy and short-read polishing are optional.  

<p align="center">
  <img src="assets/Main_report.png" 
       width="100%" alt="QC-Metrics">
</p>

#### Genome visualization
The report will also draw interactive genome maps, with visualizagion of AMR-gene locations, direction, detected ICE, and GC-content. 
<p align="center">
  <img src="assets/AMR_and_Genome_visualization.png" 
       width="100%" alt="Circular Genome Visualization">
</p>

#### AMR+ Summary Table
Finnaly the report willl also feature a detailed AMR table, in addition to all included software.  
<p align="center">
  <img src="assets/AMR_Summary_table.png" 
       width="100%" alt="AMR summary table">
</p>

#### Requirements and input files
<pre>
# In its simplest form, MOSTAR requires only 
1. ONT-reads 
2  Expected genome size 
3. Correct model (Default: r1041_e82_400bps_sup_v5.2.0)
4. Output folder 

# Run Mostar in Hybrid mode: 
mostar --ont ont.fq.gz --genome-size [size] --output [dir]  --r1 R1.fq --r2 R2.fq

# Include Kraken2 & EMU taxonomy, annotation with Bakta, and specify organism for AMRFinder+ (if supported, otherwise leave empty)
# Remember to change (--genome-size), (--model) and (--organism), this will tailor the algortihm to your data. 
# Example using Haemophilus influenzae

mostar --ont ont_read.fastq.gz --r1 read1.fastq.gz --r2 read2.fastq.gz -g 2.1m --output Output -a L42023.1.gb --organism Haemophilus_influenzae --emu-db ./emu_db -m r1041_e82_400bps_sup_v5.2.0 

# To run the pipeline in ONT-only mode, just omit read1/read2. 
# ONT-only mode:
mostar --ont ont.fq.gz --genome-size [size] --output [dir] 
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
11. Kraken2
12. EMU
</pre>  



### Command-Line Arguments
| Required | Tool/Name| Description |
| :--- | :--- | :--- |
| `--ont` | ONT Reads | Nanopore long-reads (.fastq.gz) |
| `--genome-size` | Genome Size | Estimated size (e.g., 2.1m) |
| `--outoput` | Output | Directory name for output files |
| `--model` | Model | Default: r1041_e82_400bps_sup_v5.2.0) |
| Options | |
| `--r1/--r2` | Illumina | Forward & Reverse short-reads (.fastq.gz) |
| `--organism` | AMRFinder+ | Organism (e.g., Escherichia, Staphylococcus) |
| `--meta` | Flye | Enable Meta-Genome mode, omit --genome-size [Default: disabled] |
| Annotation | |
| `--bakta-db` | Bakta | Path to Bakta database |
| `--bakta-ref` | Bakta | Annotation reference sequence (.gff) |
| `--complete` | Bakta | Enable if sequence is complete (circular) [Default: disabled] |
| ICE Detection | |
| `--ice` | MacSyFinder | Use with --bakta-db [Default: disabled] |
| Classification | |
| `--kraken-db` | Kraken2 | Requires path to pre-built Kraken2 database" |
| `--confidence` | Kraken2 | Kraken2 confidence threshold [Default: 0.1 |
| `--emu-db` | EMU | Requires EMU database path, auto-download [16s Amplicon classifier] |
| Other | |
| `--cleanup` | Cleanup | Delete intermediate files |
| `--threads` | Threads | Select number of threads |
| `--help/-h` | Help | Show help menu|


# Troubleshooting and known issues
Q: Poor or fragmentet assembly
A: Make sure to specify the correct expected genome size (--genome-size) and model (--model) example r1041.XX
 
Q: I have highly uneven data
A: Try running the pipeline with (--meta) 

Q. My exact model is not accepted 
A. you may need to downgrade medaka or install a specific version. You can do this by typing: conda install -c bioconda medaka=your_version, example medaka=2.2.0 


# Maintainer and author
[![GitHub](https://img.shields.io/badge/GitHub-nermze-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/nermze)

Developed and maintained by **Nermin Zecic** ([@nermze](https://github.com/nermze)). 
For questions, bugs, or feature requests, please open an [Issue](https://github.com/nermze/mostar/issues).
