# Target protein abundance plot

Generate bar, box, or violin plots for selected protein(s) of interest.

## Usage

``` r
visualize.target(
  dataSet,
  type = "bar",
  facet = TRUE,
  listName = c(),
  regexName = c(),
  by = NULL
)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

- type:

  A character string specifying the plot type. Allowable options
  include:

  - "bar": Bar chart.

  - "boxplot": Boxplot.

  - "violin": Violin plot.

- facet:

  A logical value (default = TRUE) specifying whether to facet the plot
  by protein.

- listName:

  A character vector specifying proteins for exact matching to
  highlight.

- regexName:

  A character vector specifying proteins for regular expression pattern
  matching to highlight.

- by:

  A character string (default = "PG.ProteinName" for Spectronaut,
  default = "AccessionNumber" for Scaffold) specifying the information
  to which `listName` and/or `regexName` filter is applied. Allowable
  options include:

  - For Spectronaut: "PG.Genes", "PG.ProteinAccession",
    "PG.ProteinDescriptions", and "PG.ProteinName".

  - For Scaffold: "ProteinDescriptions", "AccessionNumber", and
    "AlternateID".

## Value

An object of class `ggplot`.
