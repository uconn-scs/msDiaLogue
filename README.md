# msDiaLogue <img src="man/figure/logo.png" align="right" alt="" width="150">


<!-- badges: start -->
[![R-CMD-check](https://github.com/uconn-scs/msDiaLogue/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/uconn-scs/msDiaLogue/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


**msDiaLogue** is a customized, modular, and flexible workflow developed jointly
by [UConn](https://uconn.edu/)'s [PMF](https://proteomics.uconn.edu/) and
[SCS](https://statsconsulting.uconn.edu/) for data-independent acquisition (DIA)
mass spectrometry (MS)-based proteomics data.


## Installation


You can install the development version of **msDiaLogue** from
[GitHub](https://github.com/) with:


``` r
# install.packages("devtools")
devtools::install_github("uconn-scs/msDiaLogue")
```


## Modular Structure


![](https://raw.githubusercontent.com/uconn-scs/msDiaLogue/refs/heads/main/man/figure/workflow.png)


* Preprocessing: Getting data from Spectronaut.
* Transformation: Options for transforming abundance data.
* Normalization: Normalization procedures.
* Imputation: Missing data procedures.
* Summarization: Calculating and presenting numerical summaries in tabular form.
* Analysis: Statistical tools for DIA data analysis.
* Filtering: Providing options to filter out data based on preset levels.
* Visualization: Providing clean visuals to aid in data analysis decisions.

