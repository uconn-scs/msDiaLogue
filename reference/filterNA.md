# Filter proteins by non-missing proportion

Remove proteins with NA values.

## Usage

``` r
filterNA(dataSet, minProp = 0.51, by = "cond", saveRm = TRUE)
```

## Arguments

- dataSet:

  The 2d data set of experimental values.

- minProp:

  A numeric value (default = 0.51) specifying the minimum non-missing
  proportion required for a protein to be retained.

- by:

  A character string (default = "cond") specifying how coverage is
  evaluated.

  - `"cond"`: The non-missing proportion for a protein must be at least
    `minProp` within each condition. Proteins failing in any condition
    are filtered out.

  - `"all"`: The overall non-missing proportion across all samples must
    be at least `minProp`.

- saveRm:

  A logical value (default = TRUE) specifying whether to save removed
  data to current working directory.

## Value

A filtered data frame.
