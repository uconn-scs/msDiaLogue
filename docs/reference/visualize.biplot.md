# Biplot of score (individuals) and loading (variables)

Generate a biplot of individuals and variables for the data.

## Usage

``` r
visualize.biplot(dataSet, ellipse = TRUE, ellipse.level = 0.95, label = "all")
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

  A text (default = "all") specifying the elements to be labelled.
  Allowed values:

  - "all": Label both active individuals and active variables.

  - "ind": Label only active individuals.

  - "var": Label only active variables.

  - "none": No labels.

## Value

An object of class `ggplot`.
