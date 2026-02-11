# Abundance distributions

Generate distribution plots for protein abundance values. If `dataSet`
is a single data frame, the function summarizes the distribution of
proteins' average abundance across conditions and replicates, including
both a kernel density estimate and an empirical cumulative distribution
function (ECDF).

If `dataSet` is a list of data frames, the function produces comparative
density plots across datasets (e.g., before vs after imputation),
stratified by `R.Condition`.

## Usage

``` r
visualize.dist(dataSet)
```

## Arguments

- dataSet:

  The 2d data set of data, or a list of data frames.

## Value

An object of class `ggplot`.
