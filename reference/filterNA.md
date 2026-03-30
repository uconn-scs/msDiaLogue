# Filter proteins by non-missing proportion and/or count

Remove proteins with insufficient non-missing values based on a minimum
non-missing proportion threshold, a minimum non-missing count threshold,
or both.

## Usage

``` r
filterNA(dataSet, minProp = 0.51, minCount = NULL, by = "cond", saveRm = TRUE)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

- minProp:

  A numeric value (default = 0.51) specifying the minimum non-missing
  proportion required for a protein to be retained.

- minCount:

  An integer specifying the minimum non-missing count required for a
  protein to be retained.

- by:

  A character string (default = "cond") specifying how non-missingness
  is evaluated.

  - `"cond"`: The non-missing proportion and/or count for a protein must
    meet the specified threshold (`minProp` and/or `minCount`) within
    each condition. Proteins failing in any condition are filtered out.

  - `"all"`: The overall non-missing proportion and/or count across all
    samples must meet the specified threshold (`minProp` and/or
    `minCount`).

- saveRm:

  A logical value (default = TRUE) specifying whether to save removed
  data to current working directory.

## Value

A filtered data frame.

## Details

- If `minProp` is provided, proteins are filtered based on the
  non-missing proportion.

- If `minCount` is provided, proteins are filtered based on the
  non-missing count.

- If both are provided, both criteria must be satisfied.

- At least one of `minProp` and `minCount` must be specified.
