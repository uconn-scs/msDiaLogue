# Imputation by probabilistic principal components analysis

Apply imputation to the dataset by probabilistic principal components
analysis (Stacklies et al. 2007) .

## Usage

``` r
impute.pca_prob(
  dataSet,
  reportImputing = FALSE,
  nPcs = NULL,
  maxIterations = 1000,
  seed = 362436069
)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- reportImputing:

  A boolean (default = FALSE) specifying whether to provide a shadow
  data frame with imputed data labels, where 1 indicates the
  corresponding entries have been imputed, and 0 indicates otherwise.
  Alters the return structure.

- nPcs:

  An integer specifying the number of principal components to calculate.
  The default is set to the minimum between the number of samples and
  the number of proteins.

- maxIterations:

  An integer (default = 1000) specifying the maximum number of allowed
  iterations.

- seed:

  An integer (default = 362436069) specifying the seed used for the
  random number generator for reproducibility.

## Value

- If `reportImputing = FALSE`, the function returns the imputed 2d
  dataframe.

- If `reportImputing = TRUE`, the function returns a list of the imputed
  2d dataframe and a shadow matrix showing which proteins by replicate
  were imputed.

## References

Stacklies W, Redestig H, Scholz M, Walther D, Selbig J (2007).
“pcaMethods–A Bioconductor Package Providing PCA Methods for Incomplete
Data.” *Bioinformatics*, **23**(9), 1164–1167.
[doi:10.1093/bioinformatics/btm069](https://doi.org/10.1093/bioinformatics/btm069)
.
