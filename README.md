# msDiaLogue <img src="man/figure/logo.png" align="right" alt="" width="150">

<!-- badges: start -->
[![R-CMD-check](https://github.com/uconn-scs/msDiaLogue/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/uconn-scs/msDiaLogue/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


## Code building for workflow package

This repository will be used to build a customized [UConn](https://uconn.edu/)
[PMF](https://proteomics.uconn.edu/)-[SCS](https://statsconsulting.uconn.edu/)
workflow for Data-Independent Acquisition (DIA) proteomics data. The code will
be expanded to include more options for users, and more detailed explanations of
the steps in the analysis process.


## Installation

You can install the development version of **msDiaLogue** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("uconn-scs/msDiaLogue")
```


## Main areas include

* Data preprocessing: getting data from Spectronaut
* Data transformation: options for transforming abundance data
* Data filtering: providing options to filter out data based on preset levels 
* Data normalization: normalization procedures
* Data imputation: missing data procedures
* Data summary: calculating and presenting numerical summaries in tabular form
* Differential Abundance Analysis: statistical tools for DIA data analysis
* Data visualization: providing clean visuals to aid in data analysis decisions


## General problems during installation

1. `WARNING: Rtools is required to build R packages but is not currently installed.`

For Windows, the [RTools](https://cran.r-project.org/bin/windows/Rtools/) is required to
build this package.

2. `sh: /opt/gfortran/bin/gfortran: No such file or directory`

The [GFortran](https://fortran-lang.org/learn/os_setup/install_gfortran/) compiler is
required to build this package.


3. `dependency 'impute' is not available`

There are dependent packages—[impute](https://bioconductor.org/packages/impute/),
[limma](https://bioconductor.org/packages/limma/), and
[pcaMethods](https://bioconductor.org/packages/pcaMethods/)—that are available
via Bioconductor rather than CRAN. If you get an error message about these
packages, simply install them using:

``` r
install.packages("BiocManager")
BiocManager::install("impute")
BiocManager::install("limma")
BiocManager::install("pcaMethods")
```

