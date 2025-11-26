# Loading and reformatting of MS data from Scaffold

Read a data file from Scaffold, select columns necessary for analysis,
and return the reformatted data.

## Usage

``` r
preprocessing_scaffold(fileName, dataSet = NULL, zeroNA = TRUE, oneNA = TRUE)
```

## Arguments

- fileName:

  The name of the .xls file containing MS data (including the path to
  the file, if needed).

- dataSet:

  The raw data set, if already loaded in R.

- zeroNA:

  A boolean (default = TRUE) specifying whether 0's should be converted
  to NA's.

- oneNA:

  A boolean (default = TRUE) specifying whether 1's should be converted
  to NA's.

## Value

- If the data contains columns for Gene Ontology (GO) annotation terms,
  the function returns a list containing both the preprocessed 2d
  dataframe and a list of GO terms.

- If no GO annotation columns are present, the function returns only the
  preprocessed 2d dataframe.

## Details

The function executes the following:

1.  Reads the file.

2.  Provides summary statistics and a histogram of all values reported
    in the data set.

3.  Selects columns that contain necessary information for the analysis.

4.  Re-formats the data to present individual proteins as columns and
    group replicates under each protein.

5.  Stores the data as a `data.frame` and prints the levels of condition
    and replicate to the user.
