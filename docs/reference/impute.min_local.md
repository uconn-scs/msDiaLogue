# Imputation by the local minimum

Apply imputation to the dataset by the minimum measured value for that
protein in that condition.

## Usage

``` r
impute.min_local(dataSet, reportImputing = FALSE, reqPercentPresent = 0.51)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- reportImputing:

  A boolean (default = FALSE) specifying whether to provide a shadow
  data frame with imputed data labels, where 1 indicates the
  corresponding entries have been imputed, and 0 indicates otherwise.
  Alters the return structure.

- reqPercentPresent:

  A scalar (default = 0.51) specifying the required percent of values
  that must be present in a given protein by condition combination for
  values to be imputed.

## Value

- If `reportImputing = FALSE`, the function returns the imputed 2d
  dataframe.

- If `reportImputing = TRUE`, the function returns a list of the imputed
  2d dataframe and a shadow matrix showing which proteins by replicate
  were imputed.
