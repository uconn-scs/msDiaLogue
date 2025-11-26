# Counting missing data

Calculate and plot the missingness.

## Usage

``` r
dataMissing(
  dataSet,
  sort_miss = FALSE,
  plot = FALSE,
  show_pct_legend = TRUE,
  show_labels = TRUE,
  show_pct_col = TRUE
)
```

## Arguments

- dataSet:

  The 2d data set of experimental values.

- sort_miss:

  A boolean (default = FALSE) specifying whether to arrange the columns
  in order of missingness.

- plot:

  A boolean (default = FALSE) specifying whether to plot the
  missingness.

- show_pct_legend:

  A boolean (default = TRUE) specifying whether the percentages of
  missing and present values in the entire dataset are shown in the
  legend of the visualization when `plot = TRUE`.

- show_labels:

  A boolean (default = TRUE) specifying whether protein names are shown
  in the visualization when `plot = TRUE`.

- show_pct_col:

  A boolean (default = TRUE) specifying whether the percentages of
  missing data in the samples for that protein are shown in the labels
  of the visualization when `show_labels = TRUE`.

## Value

A 2d dataframe including:

- "count_miss": The count of missing values for each protein.

- "pct_miss_col": The percentage of missing values for each protein.

- "pct_miss_tot": The percentage of missing values for each protein
  relative to the total missing values in the entire dataset.
