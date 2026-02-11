# Imputation by Bayesian linear regression

Apply imputation to the dataset by Bayesian linear regression (Rubin
1987; Schafer 1997; van Buuren and Groothuis-Oudshoorn 2011) .

## Usage

``` r
impute.mice_norm(dataSet, m = 5, seed = 362436069)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- m:

  An integer (default = 5) specifying the number of multiple
  imputations.

- seed:

  An integer (default = 362436069) specifying the seed used for the
  random number generator for reproducibility.

## Value

An imputed 2d dataframe.

## References

Rubin DB (1987). *Multiple Imputation for Nonresponse in Surveys*. John
Wiley \\ Sons, New York, NY, USA. ISBN 9780471087052.\
\
Schafer JL (1997). *Analysis of Incomplete Multivariate Data*. Chapman
\\ Hall/CRC, New York, NY, USA. ISBN 9780412040610.\
\
van Buuren S, Groothuis-Oudshoorn K (2011). “mice: Multivariate
Imputation by Chained Equations in R.” *Journal of Statistical
Software*, **45**(3), 1–67.
[doi:10.18637/jss.v045.i03](https://doi.org/10.18637/jss.v045.i03) .
