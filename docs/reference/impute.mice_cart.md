# Imputation by classification and regression trees

Apply imputation to the dataset by classification and regression trees
(Breiman et al. 1984; Doove et al. 2014; van Buuren 2018) .

## Usage

``` r
impute.mice_cart(dataSet, reportImputing = FALSE, m = 5, seed = 362436069)
```

## Arguments

- dataSet:

  The 2d dataset of experimental values.

- reportImputing:

  A boolean (default = FALSE) specifying whether to provide a shadow
  data frame with imputed data labels, where 1 indicates the
  corresponding entries have been imputed, and 0 indicates otherwise.
  Alters the return structure.

- m:

  An integer (default = 5) specifying the number of multiple
  imputations.

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

Breiman L, Friedman J, Olshen RA, Stone CJ (1984). *Classification and
Regression Trees*. Routledge, New York, NY, USA. ISBN 9780412048418.  
  
Doove LL, van Buuren S, Dusseldorp E (2014). “Recursive Partitioning for
Missing Data Imputation in the Presence of Interaction Effects.”
*Computational Statistics & Data Analysis*, **72**, 92–104.
[doi:10.1016/j.csda.2013.10.025](https://doi.org/10.1016/j.csda.2013.10.025)
.  
  
van Buuren S (2018). *Flexible Imputation of Missing Data*. Chapman \\
Hall/CRC, New York, NY, USA. ISBN 9781032178639.
