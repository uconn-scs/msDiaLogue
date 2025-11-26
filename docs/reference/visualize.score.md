# Score plot / graph of individuals

Generate a scores plot (graph of individuals) for the data.

## Usage

``` r
visualize.score(dataSet, ellipse = TRUE, ellipse.level = 0.95, label = TRUE)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.pca`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.pca.md)
  or
  [`analyze.plsda`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md).

- ellipse:

  A boolean (default = TRUE) specifying whether to draw ellipses around
  the individuals.

- ellipse.level:

  A numeric value (default = 0.95) specifying the size of the
  concentration ellipse in normal probability.

- label:

  A boolean (default = TRUE) specifying whether the active individuals
  to be labeled.

## Value

An object of class `ggplot`.
