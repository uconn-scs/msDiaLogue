# Imputation by the truncated k-nearest neighbors algorithm

Apply imputation to the data set by the truncated k-nearest neighbors
algorithm (Shah et al. 2017) .

## Usage

``` r
impute.knn_trunc(dataSet, k = 10)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

- k:

  An integer (default = 10) indicating the number of neighbors to be
  used in the imputation.

## Value

An imputed data frame.

## References

Shah JS, Rai SN, DeFilippis AP, Hill BG, Bhatnagar A, Brock GN (2017).
“Distribution Based Nearest Neighbor Imputation for Truncated High
Dimensional Data with Applications to Pre-Clinical and Clinical
Metabolomics Studies.” *BMC bioinformatics*, **18**, 114.
[doi:10.1186/s12859-017-1547-6](https://doi.org/10.1186/s12859-017-1547-6)
.
