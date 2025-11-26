# Filtering proteins or contaminants

Apply a series of filtering steps to the data set.

## Usage

``` r
filterOutIn(
  dataSet,
  listName = c(),
  regexName = c(),
  by = NULL,
  removeList = TRUE,
  saveRm = TRUE
)
```

## Arguments

- dataSet:

  The 2d data set of experimental values.

- listName:

  A character vector of text strings used as keys for selecting or
  removing.

- regexName:

  A character vector specifying proteins for regular expression pattern
  matching to select or remove.

- by:

  A character string (default = "PG.ProteinName" for Spectronaut,
  default = "AccessionNumber" for Scaffold) specifying the information
  to which `listName` and/or `regexName` filter is applied. Allowable
  options include:

  - For Spectronaut: "PG.Genes", "PG.ProteinAccession",
    "PG.ProteinDescriptions", and "PG.ProteinName".

  - For Scaffold: "ProteinDescriptions", "AccessionNumber", and
    "AlternateID".

- removeList:

  A boolean (default = TRUE) specifying whether the list of proteins
  should be removed or selected.

  - TRUE: Remove the list of proteins from the data set.

  - FALSE: Remove all proteins not in the list from the data set.

- saveRm:

  A boolean (default = TRUE) specifying whether to save removed data to
  current working directory. This option only works when
  `removeList = TRUE`.

## Value

A filtered 2d dataframe.

## Details

If both `listName` and `regexName` are provided, the proteins selected
or removed will be the union of those specified in `listName` and those
matching the regex pattern in `regexName`.
