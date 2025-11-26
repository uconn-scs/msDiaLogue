# Imputation by Bayesian principal components analysis

Apply imputation to the dataset by Bayesian principal components
analysis (Oba et al. 2003) .

## Usage

``` r
impute.pca_bayes(dataSet, reportImputing = FALSE, nPcs = NULL, maxSteps = 100)
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

- maxSteps:

  An integer (default = 100) specifying the maximum number of estimation
  steps.

## Value

- If `reportImputing = FALSE`, the function returns the imputed 2d
  dataframe.

- If `reportImputing = TRUE`, the function returns a list of the imputed
  2d dataframe and a shadow matrix showing which proteins by replicate
  were imputed.

## References

Oba S, Sato M, Takemasa I, Monden M, Matsubara K, Ishii S (2003). “A
Bayesian Missing Value Estimation Method for Gene Expression Profile
Data.” *Bioinformatics*, **19**(16), 2088–2096.
[doi:10.1093/bioinformatics/btg287](https://doi.org/10.1093/bioinformatics/btg287)
.
