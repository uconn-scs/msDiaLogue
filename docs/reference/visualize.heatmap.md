# Heatmap

Generate a heatmap for the data.

## Usage

``` r
visualize.heatmap(
  dataSet,
  pkg = "pheatmap",
  cluster_cols = TRUE,
  cluster_rows = FALSE,
  show_colnames = TRUE,
  show_rownames = TRUE
)
```

## Arguments

- dataSet:

  The 2d data set of data.

- pkg:

  A string (default = "pheatmap") specifying the source package used to
  plot the heatmap. Two options: `"pheatmap"` and `"ggplot2"`.

- cluster_cols:

  A boolean (default = TRUE) determining if rows should be clustered or
  `hclust` object. This argument only works when `pkg = "pheatmap"`.

- cluster_rows:

  A boolean (default = FALSE) determining if columns should be clustered
  or `hclust` object. This argument only works when `pkg = "pheatmap"`.

- show_colnames:

  A boolean (default = TRUE) specifying if column names are be shown.
  This argument only works when `pkg = "pheatmap"`.

- show_rownames:

  A boolean (default = TRUE) specifying if row names are be shown. This
  argument only works when `pkg = "pheatmap"`.

## Value

An object of class `ggplot`.
