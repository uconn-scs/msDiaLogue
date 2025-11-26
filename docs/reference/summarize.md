# Summarize protein intensities across conditions

Calculate the mean, standard deviation, and replicate count for protein
across every condition.

## Usage

``` r
summarize(dataSet, saveSumm = TRUE)
```

## Arguments

- dataSet:

  A data frame containing the data signals and labels.

- saveSumm:

  A boolean (default = TRUE) specifying whether to save the summary
  statistics to current working directory.

## Value

A 2d summarized data frame.

## Details

The column 'Stat' in the generated data.frame includes the following
statistics:

- n: Number.

- mean: Mean.

- sd: Standard deviation.

- median: Median.

- trimmed: Trimmed mean with a trim of 0.1.

- mad: Median absolute deviation (from the median).

- min: Minimum.

- max: Maximum.

- range: The difference between the maximum and minimum value.

- skew: Skewness.

- kurtosis: Kurtosis.

- se: Standard error.
