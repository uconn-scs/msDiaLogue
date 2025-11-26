# Filtering NA's post-imputation

Remove proteins with NA values.

## Usage

``` r
filterNA(dataSet, saveRm = TRUE)
```

## Arguments

- dataSet:

  The 2d data set of experimental values.

- saveRm:

  A boolean (default = TRUE) specifying whether to save removed data to
  current working directory.

## Value

A filtered 2d dataframe.

## Details

If proteins that do not meet the imputation requirement are removed, a
.csv file is created with the removed data.
