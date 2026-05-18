# Loading plot / graph of variables

Generate a loadings plot (graph of variables) for the data.

## Usage

``` r
visualize.loading(dataSet, axes = c(1, 2), label = TRUE)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.pca`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.pca.md)
  or
  [`analyze.plsda`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md).

- axes:

  A numeric vector (default = c(1, 2)) specifying the axes of interest.

- label:

  A logical value (default = TRUE) specifying whether the active
  variables to be labeled.

## Value

An object of class `ggplot`.
