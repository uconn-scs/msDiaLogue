# Compiling data on a single protein from each step in the process

Summarize the steps performed on the data for one protein.

## Usage

``` r
pullProteinPath(listName = NULL, regexName = NULL, dataSetList, by = NULL)
```

## Arguments

- listName:

  A character vector identifying the proteins of interest.

- regexName:

  A character vector specifying the proteins for regular expression
  pattern matching.

- dataSetList:

  A list of data frames, the order dictates the order of presentation.

- by:

  A character string (default = "PG.ProteinName" for Spectronaut,
  default = "AccessionNumber" for Scaffold) specifying the information
  to which `listName` and/or `regexName` are applied. Allowable options
  include:

  - For Spectronaut: "PG.Genes", "PG.ProteinAccession",
    "PG.ProteinDescriptions", and "PG.ProteinName".

  - For Scaffold: "ProteinDescriptions", "AccessionNumber", and
    "AlternateID".

## Value

A 2d dataframe, with the protein data at each step present in the
`dataSetList`.
