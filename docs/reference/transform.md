# Transformation

Apply a transformation to the data to stabilize the variance.

## Usage

``` r
transform(dataSet, method = "log", logFold = 2, root = 2)
```

## Arguments

- dataSet:

  A data frame containing the data signals.

- method:

  A string (default = "log") specifying the method to be used for the
  transformation:

  1.  "log": Logarithm transformation.

  2.  "root": Root transformation.

- logFold:

  An integer (default = 2) specifying the base for the log
  transformation when `method = "log"`.

- root:

  An integer (default = 2) specifying the degree of the root for the
  root transformation when `method = "root"`. For example, set it to 2
  for square root or 3 for cube root.

## Value

The transformed data.

## Details

The function executes the following:

1.  Plots the mean-variance relationship.

2.  Transforms the data.

3.  Plots the mean-variance relationship again for comparison.
