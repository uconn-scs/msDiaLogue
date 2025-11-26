# Loading plot / graph of variables

Generate a loadings plot (graph of variables) for the data.

## Usage

``` r
visualize.loading(dataSet, label = TRUE)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.pca`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.pca.md)
  or
  [`analyze.plsda`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md).

- label:

  A boolean (default = TRUE) specifying whether the active variables to
  be labeled.

## Value

An object of class `ggplot`.
