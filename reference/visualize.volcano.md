# Volcano plot

Generate a volcano plot for the data.

## Usage

``` r
visualize.volcano(dataSet, P.thres = 0.05, F.thres = 1)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.mod_t`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.mod_t.md),
  [`analyze.t`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.t.md),
  or
  [`analyze.wilcox`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.wilcox.md).

- P.thres:

  A numeric value (default = 0.05) specifying the p-value threshold used
  to draw the horizontal line at -log10(`P.thres`) on the volcano plot.

- F.thres:

  threshold (default = 1) specifying the absolute fold change threshold
  used to draw the vertical lines at `-F.thres` and `F.thres` on the
  volcano plot.

## Value

An object of class `ggplot`.
