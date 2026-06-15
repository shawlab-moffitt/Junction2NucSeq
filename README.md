Junction2NucSeq
===============

Junction2NucSeq is an interactive R Shiny application for converting splice
junction coordinates into nucleotide sequences. The application retrieves
genomic sequences from the human reference genome (GRCh38/hg38) using the
Ensembl REST API and provides donor, acceptor, and junction-flanking
sequences for downstream splicing analyses.

LIVE APPLICATION
----------------

https://shawlab-moffitt.shinyapps.io/junction2nucseq/

GITHUB REPOSITORY
-----------------

https://github.com/shawlab-moffitt/Junction2NucSeq

FEATURES
--------

* Convert genomic splice junction coordinates into nucleotide sequences
* Supports standard genomic coordinate format:

    chr:start-stop

  Example:

    chr7:55019017-55019278

* Extract:
    - Donor splice-site sequence
    - Acceptor splice-site sequence
    - Junction-flanking sequence
    - Complete splice junction sequence

* Supports positive (+) and negative (-) strand junctions
* Uses the Ensembl REST API for sequence retrieval
* No local genome installation required
* Interactive web-based interface

COMMON USE CASES
----------------

1. Novel Splice Junction Validation

   Investigate splice junctions identified from:
   - Bulk RNA-seq
   - Single-cell RNA-seq
   - Long-read sequencing
   - Recount3 splice junction analyses

2. Splice Site Motif Analysis

   Evaluate canonical splice motifs:

   Donor:    GT
   Acceptor: AG

3. Tumor-Specific Splicing

   Characterize:
   - Cryptic splice junctions
   - Alternative splicing events
   - Neojunctions
   - Cancer-specific splice variants

4. Primer Design

   Generate splice-junction sequences for:
   - RT-PCR
   - qPCR
   - Validation experiments

INPUT FORMAT
------------

Enter a splice junction coordinate in the format:

    chr:start-stop

Examples:

    chr1:155239876-155240921
    chr7:55019017-55019278
    chr17:7673615-7675320

Optional parameters:

* Strand (+ or -)
* Flanking sequence length

OUTPUT
------

The application returns:

* Chromosome
* Donor splice-site position
* Acceptor splice-site position
* Strand
* Donor sequence
* Acceptor sequence
* Junction sequence
* User-defined flanking sequence

REFERENCE GENOME
----------------

Genome Build:
    GRCh38 / hg38

Sequence Source:
    Ensembl REST API

INSTALLATION
------------

Clone the repository:

    git clone https://github.com/shawlab-moffitt/Junction2NucSeq.git

Install required R packages:

    install.packages(c("shiny", "httr2"))

Run locally:

    shiny::runApp()

DEPENDENCIES
------------

R Packages:
    shiny
    httr2

External Services:
    Ensembl REST API

LAB INFORMATION
---------------

Shaw Immuno Systems Biology Laboratory
Department of Biostatistics and Bioinformatics
Moffitt Cancer Center
Tampa, Florida, USA

CONTACT
-------

Timothy I. Shaw, Ph.D.
Assistant Member
Department of Biostatistics and Bioinformatics
Moffitt Cancer Center

Repository:
https://github.com/shawlab-moffitt/Junction2NucSeq

Web Application:
https://shawlab-moffitt.shinyapps.io/junction2nucseq/

LICENSE
-------

MIT License

Copyright (c) 2026 Shaw Immuno Systems Biology Laboratory
