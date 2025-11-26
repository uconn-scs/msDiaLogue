# Imputation by the nuclear-norm regularization

Apply imputation to the dataset by the nuclear-norm regularization
(Hastie et al. 2015) .

## Usage

``` r
impute.nuc_norm(
  dataSet,
  reportImputing = FALSE,
  rank.max = NULL,
  lambda = NULL,
  thresh = 1e-05,
  maxit = 100,
  final.svd = TRUE,
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

- rank.max:

  An integer specifying the restriction on the rank of the solution. The
  default is set to one less than the minimum dimension of the dataset.

- lambda:

  A scalar specifying the nuclear-norm regularization parameter. If
  `lambda = 0`, the algorithm convergence is typically slower. The
  default is set to the maximum singular value obtained from the
  singular value decomposition (SVD) of the dataset.

- thresh:

  A scalar (default = 1e-5) specifying the convergence threshold,
  measured as the relative change in the Frobenius norm between two
  successive estimates.

- maxit:

  An integer (default = 100) specifying the maximum number of iterations
  before the convergence is reached.

- final.svd:

  A boolean (default = TRUE) specifying whether to perform a one-step
  unregularized iteration at the final iteration, followed by
  soft-thresholding of the singular values, resulting in hard zeros.

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

Hastie T, Mazumder R, Lee JD, Zadeh R (2015). “Matrix Completion and
Low-Rank SVD via Fast Alternating Least Squares.” *Journal of Machine
Learning Research*, **16**(104), 3367—3402.
[http://jmlr.org/papers/v16/hastie15a.html](http://jmlr.org/papers/v16/hastie15a.md).
