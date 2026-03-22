# Rank abundance distribution plot (Whittaker plot)

Generate a rank abundance distribution plot, also known as Whittaker
plot, for the data.

## Usage

``` r
visualize.rank(
  dataSet,
  listName = c(),
  regexName = c(),
  by = NULL,
  facet = c("Condition", "Replicate"),
  color = "red",
  ...
)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

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

- facet:

  A character string (default = c("Replicate", "Condition")) specifying
  grouping variables for faceting. Allowed values are:

  - "Condition": Abundance values are averaged across replicates.

  - "Replicate": Abundance values are averaged across conditions.

  - c("Condition", "Replicate"): No averaging is performed.

  - c("Replicate", "Condition"): No averaging is performed.

- color:

  A character string (default = red") specifying the color used to
  highlight proteins.

- ...:

  Optional arguments passed to
  [`geom_text_repel`](https://ggrepel.slowkow.com/reference/geom_text_repel.html).

## Value

An object of class `ggplot`.
