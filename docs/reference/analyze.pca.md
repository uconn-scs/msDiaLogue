# PCA: principal component analysis

Perform a principal component analysis (Pearson 1901; Hotelling 1933) on
the data.

## Usage

``` r
analyze.pca(dataSet, center = TRUE, scale = TRUE)
```

## Arguments

- dataSet:

  The 2d data set of data.

- center:

  A boolean (default = TRUE) indicating whether the variables should be
  shifted to be zero centered.

- scale:

  A boolean (default = TRUE) indicating whether the variables should be
  scaled to have unit variance before the analysis takes place.

## Value

A list containing the following components:

- sdev:

  The standard deviations of the principal components.

- loadings:

  The matrix of variable loadings.

- scores:

  The principal component scores.

- center:

  The centering used.

- scale:

  The scaling used.

## References

Hotelling H (1933). “Analysis of a Complex of Statistical Variables into
Principal Components.” *Journal of Educational Psychology*, **24**(6),
417–441. [doi:10.1037/h0071325](https://doi.org/10.1037/h0071325) .\
\
Pearson K (1901). “On Lines and Planes of Closest Fit to Systems of
Points in Space.” *The London, Edinburgh, and Dublin Philosophical
Magazine and Journal of Science*, **2**(11), 559–572.
[doi:10.1080/14786440109462720](https://doi.org/10.1080/14786440109462720)
.
