# msDiaLogue ![](man/figure/logo.png)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15706003.svg)](https://doi.org/10.5281/zenodo.15706003)
[![GitHub R package
version](https://img.shields.io/github/r-package/v/uconn-scs/msDiaLogue?label=R%20in%20dev&color=green)](https://github.com/uconn-scs/msDiaLogue/blob/main/DESCRIPTION)
[![GitHub last
commit](https://img.shields.io/github/last-commit/uconn-scs/msDiaLogue)](https://github.com/uconn-scs/msDiaLogue/commits/main)
[![R-CMD-check](https://github.com/uconn-scs/msDiaLogue/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/uconn-scs/msDiaLogue/actions/workflows/R-CMD-check.yaml)
[![GitHub
License](https://img.shields.io/github/license/uconn-scs/msDiaLogue?color=blue)](https://github.com/uconn-scs/msDiaLogue/blob/main/LICENSE)

**msDiaLogue** is a customized, modular, and flexible workflow developed
jointly by [UConn](https://uconn.edu/)’s
[PMF](https://proteomics.uconn.edu/) and
[SCS](https://statsconsulting.uconn.edu/) for data-independent
acquisition (DIA) mass spectrometry (MS)-based proteomics data.

## Installation

You can install **msDiaLogue** directly from
[GitHub](https://github.com/).

- Development (latest) version:

``` r

# install.packages("devtools")
devtools::install_github("uconn-scs/msDiaLogue")
```

- Specific released version (e.g. v0.0.6):

``` r

# install.packages("devtools")
devtools::install_github("uconn-scs/msDiaLogue@v0.0.6")
```

## Modular Structure

![](https://raw.githubusercontent.com/uconn-scs/msDiaLogue/refs/heads/main/man/figure/workflow.png)

- Preprocessing: Getting data from Spectronaut.
- Transformation: Options for transforming abundance data.
- Normalization: Normalization procedures.
- Imputation: Missing data procedures.
- Summarization: Calculating and presenting numerical summaries in
  tabular form.
- Analysis: Statistical tools for DIA data analysis.
- Filtering: Providing options to filter out data based on preset
  levels.
- Visualization: Providing clean visuals to aid in data analysis
  decisions.
