# Scree plot

Generate a scree plot for the data.

## Usage

``` r
visualize.scree(
  dataSet,
  type = c("bar", "line"),
  bar.color = "gray",
  bar.fill = "gray",
  line.color = "black",
  label = TRUE,
  ncp = 10
)
```

## Arguments

- dataSet:

  The data set corresponds to the output from the function
  [`analyze.pca`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.pca.md).

- type:

  A string (default = c("bar", "line"))specifying the plot type. Allowed
  values are "bar" for a barplot, "line" for a line plot, or c("bar",
  "line") to use both types.

- bar.color:

  Color of the bar outline in the bar plot. Defaults to "gray".

- bar.fill:

  Fill color of the bars in the bar plot. Defaults to "gray".

- line.color:

  Color of the line and point in the line plot. Defaults to "black".

- label:

  A boolean (default = TRUE) specifying whether labels are added at the
  top of bars or points to show the information retained by each
  dimension.

- ncp:

  A numeric value (default = 10) specifying the number of dimensions to
  be shown.

## Value

An object of class `ggplot`.
