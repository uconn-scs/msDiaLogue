# Imputation by the k-nearest neighbors algorithm

Apply imputation to the dataset by the sequential k-nearest neighbors
algorithm (Kim et al. 2004) .

## Usage

``` r
impute.knn_seq(dataSet, k = 10)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- k:

  An integer (default = 10) indicating the number of neighbors to be
  used in the imputation.

## Value

An imputed 2d dataframe.

## References

Kim K, Kim B, Yi G (2004). “Reuse of Imputed Data in Microarray Analysis
Increases Imputation Efficiency.” *BMC bioinformatics*, **5**, 160.
[doi:10.1186/1471-2105-5-160](https://doi.org/10.1186/1471-2105-5-160) .
