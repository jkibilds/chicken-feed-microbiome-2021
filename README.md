# Data analysis details for chicken feed supplement study

This repository contains the relevant scripts and documented manual operations that were performed in order to analyse the microbiome sequencing data from article ... *(will add link when paper is published)*.

The corresponding raw sequence reads have been deposited in [European Nucleotide Archive](https://www.ebi.ac.uk/ena/browser/home) under study accession number PRJEB46042.

## Contents of this repository

- [data](data) - contains the QIIME2 metadata files that are used in some scripts

- [env/qiime2-2020.11-py36-linux-conda.yml](env/qiime2-2020.11-py36-linux-conda.yml) - contains package version and source info that can be used to reconstruct the software environment where most data processing was done (this does not include R). The file can be conveniently used with the `conda env create --file` command.

- [src/hpc](src/hpc) - contains resource-demanding scripts that were run an a computing cluster via the Torque/PBS scheduler

- [src/local](src/local) - scripts that don't require so much RAM and CPU power and thus were run on a desktop computer. Both HPC and local scripts use the same `conda` environment

- [src/manual](src/manual) - a few manual commands (were run locally on a desktop computer)

- [src/R_notebooks](src/R_notebooks) - whatever was done in R, documented in the form of R notebooks. R version 4.0.3 and MaAsLin2 package version 1.4.0 were used.
