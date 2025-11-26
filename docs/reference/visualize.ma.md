# MA plot: plots fold change versus average abundance

Generate an MA plot for the data.

## Usage

``` r
visualize.ma(dataSet, M.thres = 1)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.ma`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.ma.md).

- M.thres:

  The absolute threshold value of M (fold-change) (default = 1) used to
  plot the two vertical lines (-M.thres and M.thres) on the MA plot.

## Value

An object of class `ggplot`.
