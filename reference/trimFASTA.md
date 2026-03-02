# Trimming down a protein FASTA file to certain proteins

Trim down a FASTA file to only contain proteins present in an associated
Spectronaut report file.

## Usage

``` r
trimFASTA(
  FASTAFileName,
  reportFileName,
  outputFileName = "trimFASTA_output.txt",
  by = "PG.ProteinNames",
  selectString = "*BOVIN"
)
```

## Arguments

- FASTAFileName:

  A character string specifying the name of the input FASTA .txt file.

- reportFileName:

  A character string specifying the name of the Spectronaut report .csv
  file.

- outputFileName:

  A character string (default = "trimFASTA_output.txt") specifying the
  name of the output file.

- by:

  A character string (default = "PG.ProteinNames") specifying the
  identifier (column name) used for selection in the report file.

- selectString:

  A character string specifying the regular expression to search for.

## Value

A FASTA file with only the specified proteins present.

## Details

Depending on the size of the FASTA file, this function may run slowly
and take several minutes. The FASTA file must be in .txt format; other
formats will not work.
