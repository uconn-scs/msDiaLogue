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
  ht.color = "black",
  ht.shape = 17,
  ht.size = 1.5,
  ht.textcolor = "black",
  ht.textsize = 2,
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

- ht.color:

  A character string (default = "black") specifying the point color of
  highlighted proteins.

- ht.shape:

  A numeric value (default = 17) specifying the point shape of
  highlighted points. See \[ggplot2: Elegant Graphics for Data
  Analysis\](https://ggplot2-book.org/scales-other.html#sec-scale-shape)
  for more details.

- ht.size:

  A numeric value (default = 1.5) specifying the point size of
  highlighted proteins.

- ht.textcolor:

  A character string (default = "black") specifying the font color of
  text labels for highlighted proteins.

- ht.textsize:

  A numeric value (default = 2) specifying the font size of text labels
  for highlighted proteins.

- ...:

  Optional arguments passed to
  [`geom_text_repel`](https://ggrepel.slowkow.com/reference/geom_text_repel.html).

## Value

An object of class `ggplot`.
