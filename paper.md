---
title: 'MOSTAR: Modular ONT-Short-read Taxonomic Assembly and Resistance pipeline'
tags:
  - bioinformatics
  - nanopore sequencing
  - genome assembly
  - antimicrobial resistance
  - mobile genetic elements
authors:
  - name: Nermin Zecic
    orcid: 0009-0008-0687-424X
    affiliation: 1
  - name: Dagfinn Skaare
    orcid: 0009-0009-4084-4156
    affiliation: 1
  - name: Helene Johannessen Wefring
    orcid: 0000-0002-1743-5321
    affiliation: 1
  - name: Tore Taksdal Stubhaug
    orcid: 0000-0002-9234-7532
    affiliation: 1
affiliations:
  - name: Vestfold Hospital Trust, Tønsberg, Norway
    index: 1
date: 5 February 2026
bibliography: paper.bib
---

# Summary

MOSTAR (Modular ONT-Short-read Taxonomic Assembly and Resistance pipeline) is an
end-to-end command-line pipeline for the assembly, polishing, annotation, and
genomic characterisation of bacterial isolates sequenced on Oxford Nanopore
Technology (ONT) platforms. It supports both ONT-only and hybrid modes, where
the latter incorporates Illumina short reads for an additional polishing step.
Starting from raw reads, MOSTAR produces a polished assembly, a complete
resistome profile, mobile genetic element annotations, taxonomic classification,
and a self-contained interactive HTML report — all within a single command.

# Statement of Need

Oxford Nanopore sequencing has become a practical tool for routine clinical and
research microbiology due to its portability, long read lengths, and rapid
turnaround. However, translating raw ONT reads into actionable biological
insight requires coordinating a large number of tools across assembly,
polishing, annotation, resistance profiling, and mobile element detection.
This coordination is time-consuming to implement correctly, prone to
configuration errors, and presents a significant barrier for laboratories
without dedicated bioinformatics support.

Existing pipelines either focus narrowly on assembly quality [@kolmogorov2019]
or require complex infrastructure and manual post-processing to extract
clinically relevant outputs such as ICE localisation and mobile resistome
cross-referencing. MOSTAR addresses this gap by providing a single, opinionated
pipeline that takes a sequencing run as input and returns a fully characterised
genome report as output, with particular emphasis on the features most relevant
to clinical microbiology and infection control: antimicrobial resistance
profiling, horizontal gene transfer potential, and prophage burden.

# Implementation

MOSTAR is implemented as a self-contained Bash script with embedded Python for
visualisation and data processing. It requires no containerisation and installs
via a single `micromamba` environment. The pipeline is structured into thirteen
sequential steps, each managed by a progress-tracked `run_step` function that
provides real-time feedback and consistent error reporting.

## Assembly and Polishing

Long reads are quality-filtered using Filtlong [@wick2017filtlong]. In hybrid
mode, Filtlong uses supplied Illumina reads to preferentially retain ONT reads
with the highest k-mer consistency relative to the short-read data, improving
assembly accuracy before any polishing step. De novo assembly is performed with
Flye [@kolmogorov2019], followed by ONT consensus polishing with Medaka
[@ont2018medaka] to correct homopolymer errors and indels characteristic of
nanopore chemistry. In hybrid mode, a second polishing pass is performed with
Polypolish [@wick2022polypolish], which uses per-read multi-alignment short-read
mappings to correct errors in repeat regions that single-alignment approaches
cannot resolve.

## Taxonomic Classification and Functional Annotation

Assembled genomes are classified to species or subspecies level using Kraken 2
[@wood2019kraken2]. When a Kraken 2 database is provided, the top-confidence
classification is automatically passed to AMRFinder+ to enable organism-specific
point mutation screening. Optional 16S rRNA-based classification is supported
via EMU [@curry2022emu]. Full functional annotation is performed with Bakta
[@schwengers2021bakta], producing GFF3, GenBank, and FASTA outputs suitable for
downstream analysis and public database submission.

## Resistance and Mobile Element Profiling

Antimicrobial resistance genes and point mutations are identified using NCBI
AMRFinder+ [@feldgarden2021amrfinderplus]. Integrative and Conjugative Elements
(ICEs) are detected using MacSyFinder with the CONJScan model database, with
gene coordinates resolved against the Bakta annotation to precisely localise
ICE boundaries on the assembled sequence. Genomic plasticity is assessed using
geNomad, which identifies plasmid-derived contigs and integrated prophage
sequences. AMRFinder+ results are cross-referenced against geNomad plasmid calls
to identify plasmid-borne resistance genes, enabling a distinction between fixed
chromosomal resistance and resistance elements with active horizontal transfer
potential.

## Visualisation and Reporting

Circular genome maps are generated with Matplotlib for each contig, displaying
GC content deviation, ICE regions, prophage integrations, and colour-coded AMR
gene tracks with strand-aware orientation arrows. An adaptive label placement
algorithm resolves overlapping annotations at all assembly scales. All outputs
are consolidated into a single self-contained HTML report with embedded
base64-encoded genome maps and an interactive zoom interface, requiring no
external server or dependencies for viewing.

# Availability

MOSTAR is available at [https://github.com/nermze/MOSTAR](https://github.com/nermze/MOSTAR)
under the MIT licence. A `micromamba` environment file is provided for
reproducible installation. The pipeline has been validated on Linux and macOS.

# Acknowledgements

The authors thank the staff of the Department of Medical Microbiology at
Vestfold Hospital Trust for providing sequencing data used during development
and testing.

# References
