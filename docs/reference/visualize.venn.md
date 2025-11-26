# Venn diagram

Generate a Venn diagram for the data.

## Usage

``` r
visualize.venn(
  dataSet,
  show_percentage = TRUE,
  fill_color = c("blue", "yellow", "green", "red"),
  saveRes = TRUE
)
```

## Arguments

- dataSet:

  The 2d data set of data.

- show_percentage:

  A boolean (default = TRUE) specifying whether to show the percentage
  for each set.

- fill_color:

  A text (default = c("blue", "yellow", "green", "red")) specifying the
  colors to fill in circles.

- saveRes:

  A boolean (default = TRUE) specifying whether to save the data, with
  logical columns representing sets, to current working directory.

## Value

An object of class `ggplot`.
