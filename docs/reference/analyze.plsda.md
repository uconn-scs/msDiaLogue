# PLS-DA: partial least squares discriminant analysis

Perform a partial least squares discriminant analysis on the data.

## Usage

``` r
analyze.plsda(
  dataSet,
  method = "kernelpls",
  ncomp,
  center = TRUE,
  scale = FALSE
)
```

## Arguments

- dataSet:

  The 2d data set of data.

- method:

  A character string (default = "kernelpls") specifying the multivariate
  regression method to be used:

  - "kernelpls": Kernel algorithm (Dayal and MacGregor 1997) .

  - "widekernelpls": Wide kernel algorithm (Rännar et al. 1994) .

  - "simpls": SIMPLS algorithm (de Jong 1993) .

  - "oscorespls": NIPALS algorithm (classical orthogonal scores
    algorithm) (Martens and Næs 1989) .

- ncomp:

  An integer specifying the number of components to include in the
  model. Defaults to min(n-1, p).

- center:

  A boolean (default = TRUE) indicating whether the variables should be
  shifted to be zero centered.

- scale:

  A boolean (default = FALSE) indicating whether the variables should be
  scaled to have unit variance before the analysis takes place.

## Value

A list containing the following components:

- coefficients:

  An array of regression coefficients for `ncomp` components. The
  dimensions are c(nvar, npred, `ncomp`), where nvar is the number of
  variables X (proteins) and npred is the number of predicted variables
  Y (conditions).

- scores:

  A matrix of scores.

- vips:

  A matrix of variable importance in projection (VIP) scores.

- loadings:

  A matrix of loadings.

- loading.weights:

  A matrix of loading weights.

- Xvar:

  A vector with the amount of X-variance explained by each component.

- Xtotvar:

  Total variance in X.

- ncomp:

  The number of components.

- method:

  The method used to fit the model.

- center:

  Indicates whether centering was applied to the model.

- scale:

  The scaling used.

- model:

  The model frame.

## References

Dayal BS, MacGregor JF (1997). “Improved PLS Algorithms.” *Journal of
Chemometrics*, **11**(1), 73–85.
[doi:10.1002/(SICI)1099-128X(199701)11:1\<73::AID-CEM435\>3.0.CO;2-\\23](https://doi.org/10.1002/%28SICI%291099-128X%28199701%2911%3A1%3C73%3A%3AAID-CEM435%3E3.0.CO%3B2-%5C%2523)
.  
  
de Jong S (1993). “SIMPLS: An Alternative Approach to Partial Least
Squares Regression.” *Chemometrics and Intelligent Laboratory Systems*,
**18**(3), 251–263.
[doi:10.1016/0169-7439(93)85002-X](https://doi.org/10.1016/0169-7439%2893%2985002-X)
.  
  
Martens H, Næs T (1989). *Multivariate Calibration*. Chichester, Wiley,
New York, USA. ISBN 0471909793.  
  
Rännar S, Lindgren F, Geladi P, Wold S (1994). “A PLS Kernel Algorithm
for Data Sets with Many Variables and Fewer Objects. Part 1: Theory and
Algorithm.” *Journal of Chemometrics*, **8**(2), 111–125.
[doi:10.1002/cem.1180080204](https://doi.org/10.1002/cem.1180080204) .
