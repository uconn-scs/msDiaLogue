# Rank abundance distribution plot (Whittaker plot)

Generate a rank abundance distribution plot, also known as Whittaker
plot, for the data.

## Usage

``` r
visualize.rank(
  dataSet,
  listName = NULL,
  regexName = NULL,
  by = NULL,
  facet = c("Condition", "Replicate"),
  color = "red"
)
```

## Arguments

- dataSet:

  The 2d data set of data.

- listName:

  A character vector of proteins to highlight.

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

- facet:

  A character string (default = c("Replicate", "Condition")) specifying
  grouping variables for faceting. Allowed values are "Condition",
  "Replicate", c("Condition", "Replicate"), c("Replicate", "Condition"),
  or "none" for no grouping.

- color:

  A string (default = red") specifying the color used to highlight
  proteins.

## Value

An object of class `ggplot`.
