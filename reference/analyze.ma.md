# MA: fold change versus average abundance

Compute the fold change (M) and average abundance (A) values from the
data for MA plots.

## Usage

``` r
analyze.ma(dataSet, ref = NULL, saveRes = TRUE)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

- ref:

  A character string (default = NULL) specifying the reference condition
  for comparison. If NULL, all pairwise comparisons are performed.

- saveRes:

  A logical value (default = TRUE) specifying whether to save the
  analysis results to the current working directory.

## Value

A list comprising data frames for each comparison, with each data frame
containing the means of the two compared conditions for each protein, as
well as the average and difference in means.
