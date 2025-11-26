# VIP scores plot

Generate a variable importance in projection (VIP) scores plot for the
data.

## Usage

``` r
visualize.vip(dataSet, comp = 1, num = 10, thres = 1, rel.widths)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.plsda`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md).

- comp:

  An integer (default = 1) specifying the PLS-DA component to use when
  ranking variables.

- num:

  An integer (default = 10) specifying the number of top variables
  (highest VIP scores) to display.

- thres:

  A scalar (default = 1) specifying the vertical dashed line drawn at
  this VIP value.

- rel.widths:

  A numerical vector specifying the proportion of relative widths for
  the plot panels. Defaults to widths chosen based on the range of the
  top variables' VIP scores and the number of group conditions.

## Value

An object of class `ggplot`.
