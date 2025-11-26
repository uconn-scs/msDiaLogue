# Loading, filtering and reformatting of MS DIA data from Spectronaut

Read a data file from Spectronaut, apply filtering conditions, select
columns necessary for analysis, and return the reformatted data.

## Usage

``` r
preprocessing(
  fileName,
  dataSet = NULL,
  filterNaN = TRUE,
  filterUnique = 2,
  replaceBlank = TRUE,
  saveRm = TRUE
)
```

## Arguments

- fileName:

  The name of the .csv file containing MS data (including the path to
  the file, if needed).

- dataSet:

  The raw data set, if already loaded in R.

- filterNaN:

  A boolean (default = TRUE) specifying whether observations including
  NaN should be omitted.

- filterUnique:

  An integer (default = 2) specifying how many number of unique peptides
  are required to include a protein.

- replaceBlank:

  A boolean (default = TRUE) specifying whether proteins without names
  should be be named by their accession numbers.

- saveRm:

  A boolean (default = TRUE) specifying whether to save removed data to
  current working directory.

## Value

A 2d dataframe.

## Details

The function executes the following:

1.  Reads the file.

2.  Applies applicable filters, if necessary.

3.  Provides summary statistics and a histogram of all values reported
    in the data set.

4.  Selects columns that contain necessary information for the analysis.

5.  Re-formats the data to present individual proteins as columns and
    group replicates under each protein.

6.  Stores the data as a `data.frame` and prints the levels of condition
    and replicate to the user.
