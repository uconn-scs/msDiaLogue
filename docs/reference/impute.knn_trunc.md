# Imputation by the truncated k-nearest neighbors algorithm

Apply imputation to the dataset by the truncated k-nearest neighbors
algorithm (Shah et al. 2017) .

## Usage

``` r
impute.knn_trunc(dataSet, reportImputing = FALSE, k = 10)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- reportImputing:

  A boolean (default = FALSE) specifying whether to provide a shadow
  data frame with imputed data labels, where 1 indicates the
  corresponding entries have been imputed, and 0 indicates otherwise.
  Alters the return structure.

- k:

  An integer (default = 10) indicating the number of neighbors to be
  used in the imputation.

## Value

- If `reportImputing = FALSE`, the function returns the imputed 2d
  dataframe.

- If `reportImputing = TRUE`, the function returns a list of the imputed
  2d dataframe and a shadow matrix showing which proteins by replicate
  were imputed.

## References

Shah JS, Rai SN, DeFilippis AP, Hill BG, Bhatnagar A, Brock GN (2017).
“Distribution Based Nearest Neighbor Imputation for Truncated High
Dimensional Data with Applications to Pre-Clinical and Clinical
Metabolomics Studies.” *BMC bioinformatics*, **18**, 114.
[doi:10.1186/s12859-017-1547-6](https://doi.org/10.1186/s12859-017-1547-6)
.
