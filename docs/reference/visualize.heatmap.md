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
  show_rownames = TRUE,
  show_pct_cols = FALSE,
  show_pct_rows = TRUE,
  show_pct_legend = TRUE,
  saveRes = TRUE
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

- show_pct_cols:

  A boolean (default = FALSE) specifying whether to append the
  percentage of missing values to the column names. Only applied when
  `dataSet` contains missing values.

- show_pct_rows:

  A boolean (default = TRUE) specifying whether to append the percentage
  of missing values to the row names. Only applied when `dataSet`
  contains missing values.

- show_pct_legend:

  A boolean (default = TRUE) specifying whether the percentages of
  missing and present values in the entire dataset are shown in the
  legend. Only applied when `dataSet` contains missing values.

- saveRes:

  A boolean (default = TRUE) specifying whether to save a summary of
  missingness information. Only applied when `dataSet` contains missing
  values.

## Value

An object of class `ggplot`.

## Details

A summary of missingness information including:

- "count_missing_protein": The count of missing values for each protein.

- "pct_missing_protein": The percentage of missing values for each
  protein.

- "pct_missing_total": The percentage of missing values for each protein
  relative to the total missing values in the entire dataset.
