# Histograms of fold changes and p-values from test results

Generate histograms of fold changes and p-values for the data.

## Usage

``` r
visualize.test(dataSet)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.mod_t`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.mod_t.md),
  [`analyze.t`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.t.md),
  or
  [`analyze.wilcox`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.wilcox.md).

## Value

An object of class `ggplot`.
