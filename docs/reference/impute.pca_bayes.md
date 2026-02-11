# Imputation by Bayesian principal components analysis

Apply imputation to the dataset by Bayesian principal components
analysis (Oba et al. 2003) .

## Usage

``` r
impute.pca_bayes(dataSet, nPcs = NULL, maxSteps = 100)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- nPcs:

  An integer specifying the number of principal components to calculate.
  The default is set to the minimum between the number of samples and
  the number of proteins.

- maxSteps:

  An integer (default = 100) specifying the maximum number of estimation
  steps.

## Value

An imputed 2d dataframe.

## References

Oba S, Sato M, Takemasa I, Monden M, Matsubara K, Ishii S (2003). “A
Bayesian Missing Value Estimation Method for Gene Expression Profile
Data.” *Bioinformatics*, **19**(16), 2088–2096.
[doi:10.1093/bioinformatics/btg287](https://doi.org/10.1093/bioinformatics/btg287)
.
