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

For Windows, the [RTools](https://cran.r-project.org/bin/windows/Rtools/) is required to
build this package.

## Main areas include

* Data preprocessing: getting data from Spectronaut
* Data transformation: options for transforming abundance data
* Data filtering: providing options to filter out data based on preset levels 
* Data normalization: normalization procedures
* Data imputation: missing data procedures
* Data summary: calculating and presenting numerical summaries in tabular form
* Differential Abundance Analysis: statistical tools for DIA data analysis
* Data visualization: providing clean visuals to aid in data analysis decisions

