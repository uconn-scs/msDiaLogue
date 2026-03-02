# Abundance distributions

Generate distribution plots for protein abundance values.

## Usage

``` r
visualize.dist(dataSet)
```

## Arguments

- dataSet:

  A data frame containing the data signals, or a list of data frames.

## Value

An object of class `ggplot`.

## Details

If `dataSet` is a single data frame, the function summarizes the
distribution of proteins' average abundance across conditions and
replicates, including both a kernel density estimate and an empirical
cumulative distribution function (ECDF).

If `dataSet` is a list of data frames, the function produces comparative
density plots across data sets (e.g., before vs after imputation),
stratified by "R.Condition".
