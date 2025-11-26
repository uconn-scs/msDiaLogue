# Imputation by the k-nearest neighbors algorithm

Apply imputation to the dataset by the sequential k-nearest neighbors
algorithm (Kim et al. 2004) .

## Usage

``` r
impute.knn_seq(dataSet, reportImputing = FALSE, k = 10)
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

Kim K, Kim B, Yi G (2004). “Reuse of Imputed Data in Microarray Analysis
Increases Imputation Efficiency.” *BMC bioinformatics*, **5**, 160.
[doi:10.1186/1471-2105-5-160](https://doi.org/10.1186/1471-2105-5-160) .
