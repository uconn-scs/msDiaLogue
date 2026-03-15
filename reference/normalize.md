# Normalization

Apply a specified type of normalization to a data set.

## Usage

``` r
normalize(dataSet, applyto = "sample", normalizeType = "median", plot = TRUE)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

- applyto:

  A character string (default = "sample") specifying the target of
  normalization. Available options are:

  1.  "sample" or "row": Row-wise normalization.

  2.  "protein" or "column": Column-wise normalization.

- normalizeType:

  A character string (default = "median") specifying the normalization
  type to apply:

  - "auto": Auto scaling (Jackson 1991) .

  - "level": Level scaling.

  - "mean": Mean centering.

  - "median": Median centering.

  - "pareto": Pareto scaling.

  - "quant": Quantile normalization (Bolstad et al. 2003) .

  - "range": Range scaling.

  - "vast": Variable stability (VAST) scaling. (Keun et al. 2003) .

  - "none": None.

- plot:

  A logical value (default = TRUE) specifying whether to plot the
  boxplot for before and after normalization.

## Value

A normalized data frame.

## References

Bolstad BM, Irizarry RA, Astrand M, Speed TP (2003). “A Comparison of
Normalization Methods for High Density Oligonucleotide Array Data Based
on Variance and Bias.” *Bioinformatics*, **19**(2), 185–193.
[doi:10.1093/bioinformatics/19.2.185](https://doi.org/10.1093/bioinformatics/19.2.185)
.  
  
Jackson JE (1991). *A User's Guide to Principal Components*. John Wiley
& Sons, New York, NY, USA. ISBN 9780471622673.  
  
Keun HC, Ebbels TMD, Antti H, Bollard ME, Beckonert O, Holmes E, Lindon
JC, Nicholson JK (2003). “Improved Analysis of Multivariate Data by
Variable Stability Scaling: Application to NMR-based Metabolic
Profiling.” *Analytica Chimica Acta*, **490**(1–2), 265–276.
[doi:10.1016/S0003-2670(03)00094-1](https://doi.org/10.1016/S0003-2670%2803%2900094-1)
.
