# Compiling data on a single protein from each step in the process

Summarize the steps performed on the data for one protein.

## Usage

``` r
pullProteinPath(listName = c(), regexName = c(), by = NULL, dataSetList)
```

## Arguments

- listName:

  A character vector specifying proteins for exact matching.

- regexName:

  A character vector specifying proteins for regular expression pattern
  matching.

- by:

  A character string (default = "PG.ProteinName" for Spectronaut,
  default = "AccessionNumber" for Scaffold) specifying the information
  to which `listName` and/or `regexName` filter is applied. Allowable
  options include:

  - For Spectronaut: "PG.Genes", "PG.ProteinAccession",
    "PG.ProteinDescriptions", and "PG.ProteinName".

  - For Scaffold: "ProteinDescriptions", "AccessionNumber", and
    "AlternateID".

- dataSetList:

  A list of data frames, the order dictates the order of presentation.

## Value

A data frame, with the protein data at each step present in the
`dataSetList`.
