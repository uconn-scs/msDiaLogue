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

  THe threshold value of p-value (default = 0.05) used to plot the
  horizontal line (-log10(P.thres)) on the volcano plot.

- F.thres:

  The absolute threshold value of fold change (default = 1) used to plot
  the two vertical lines (-F.thres and F.thres) on the volcano plot.

## Value

An object of class `ggplot`.
