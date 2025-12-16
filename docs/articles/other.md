# Other Useful

## Preliminary

``` r

## load R package
library(msDiaLogue)
## preprocessing
fileName <- "../inst/extdata/Toy_Spectronaut_Data.csv"
dataSet <- preprocessing(fileName,
                         filterNaN = TRUE, filterUnique = 2,
                         replaceBlank = TRUE, saveRm = TRUE)
## transformation
dataTran <- transform(dataSet, logFold = 2)
## normalization
dataNorm <- normalize(dataTran, normalizeType = "quant")
## imputation
dataImput <- impute.min_local(dataNorm, reportImputing = FALSE,
                              reqPercentPresent = 0.51)
## filtering
dataImput <- filterNA(dataImput, saveRm = TRUE)
```

## pullProteinPath

The function
[`pullProteinPath()`](https://uconn-scs.github.io/msDiaLogue/reference/pullProteinPath.md)
allows you to see the quantitative values associated with specific
proteins at each step of processing, using either the exact match
argument `listname =`, or the text match argument `regexName =`, or
both.

This can be useful for questions such as,

- “Which of the values for my favorite protein were actually measured,
  vs. imputed?”
- “Why didn’t my favorite protein make it to the final list? At what
  step was it filtered out?”.

It can also be used to check whether the fold-change observed for a
specific protein is an artifact from one of the processing steps.

``` r

Check <- pullProteinPath(
  listName = c("LYSC_CHICK", "BGAL_ECOLI"),
  regexName = c("BOVIN"),
  by = "PG.ProteinNames",
  dataSetList = list(Initial = dataSet,
                     Transformed = dataTran,
                     Normalized = dataNorm,
                     Imputed = dataImput))
```

| PG.ProteinNames | PG.Genes | PG.ProteinAccession | PG.ProteinAccessions | PG.ProteinDescriptions | PG.ProteinName | R.Condition | R.Replicate | Initial | Transformed | Normalized | Imputed |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|---:|---:|
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100pmol | 1 | 111209.703 | 16.76292 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100pmol | 2 | 111659.883 | 16.76875 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100pmol | 3 | 105982.914 | 16.69347 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100pmol | 4 | 104442.562 | 16.67235 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200pmol | 1 | 109245.289 | 16.73721 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200pmol | 2 | 113357.508 | 16.79052 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200pmol | 3 | 114321.836 | 16.80274 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200pmol | 4 | 116439.820 | 16.82923 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50pmol | 1 | 117803.492 | 16.84602 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50pmol | 2 | 110086.680 | 16.74828 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50pmol | 3 | 105640.203 | 16.68880 | 16.75777 | 16.75777 |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50pmol | 4 | 110446.000 | 16.75298 | 16.75777 | 16.75777 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100pmol | 1 | 23840.031 | 14.54110 | 14.44005 | 14.44005 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100pmol | 2 | 23963.307 | 14.54854 | 14.44005 | 14.44005 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100pmol | 3 | 22957.350 | 14.48667 | 14.42169 | 14.42169 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100pmol | 4 | 22311.297 | 14.44549 | 14.20112 | 14.20112 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200pmol | 1 | 41234.672 | 15.33157 | 14.77650 | 14.77650 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200pmol | 2 | 42899.434 | 15.38867 | 14.70670 | 14.70670 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200pmol | 3 | 42904.945 | 15.38886 | 14.77650 | 14.77650 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200pmol | 4 | 43279.844 | 15.40141 | 14.70670 | 14.70670 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50pmol | 1 | 14728.673 | 13.84634 | 14.38206 | 14.38206 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50pmol | 2 | 14736.710 | 13.84713 | 14.10465 | 14.10465 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50pmol | 3 | 14160.203 | 13.78955 | 14.38206 | 14.38206 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50pmol | 4 | 14758.731 | 13.84928 | 14.10465 | 14.10465 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100pmol | 1 | 10737.953 | 13.39043 | 12.96499 | 12.96499 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100pmol | 2 | 10655.384 | 13.37929 | 13.62766 | 13.62766 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100pmol | 3 | 10663.714 | 13.38042 | 12.81909 | 12.81909 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100pmol | 4 | 10843.115 | 13.40449 | 12.96499 | 12.96499 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200pmol | 1 | 19524.863 | 14.25302 | 13.10393 | 13.10393 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200pmol | 2 | 20072.297 | 14.29292 | 12.49496 | 12.49496 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200pmol | 3 | 20787.127 | 14.34340 | 14.00189 | 14.00189 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200pmol | 4 | 19924.240 | 14.28224 | 13.38772 | 13.38772 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50pmol | 1 | 6758.298 | 12.72244 | 12.49496 | 12.49496 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50pmol | 2 | 6721.135 | 12.71449 | 12.30540 | 12.30540 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50pmol | 3 | 6172.877 | 12.59173 | 13.38772 | 13.38772 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50pmol | 4 | 6028.398 | 12.55756 | 12.30540 | 12.30540 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100pmol | 1 | 13798.590 | 13.75223 | 13.62766 | 13.62766 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100pmol | 2 | 13880.411 | 13.76076 | 13.97388 | 13.97388 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100pmol | 3 | 13723.719 | 13.74438 | 13.55168 | 13.55168 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100pmol | 4 | 13944.603 | 13.76742 | 13.62766 | 13.62766 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200pmol | 1 | 24344.188 | 14.57129 | 14.22236 | 14.22236 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200pmol | 2 | 24742.227 | 14.59469 | 13.88102 | 13.88102 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200pmol | 3 | 24803.633 | 14.59826 | 14.22236 | 14.22236 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200pmol | 4 | 26381.047 | 14.68721 | 14.13067 | 14.13067 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50pmol | 1 | 7169.955 | 12.80775 | 13.38772 | 13.38772 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50pmol | 2 | 7797.536 | 12.92880 | 13.25790 | 13.25790 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50pmol | 3 | 7432.793 | 12.85969 | 13.88102 | 13.88102 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50pmol | 4 | 7543.633 | 12.88104 | 13.25790 | 13.25790 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100pmol | 1 | 15097.670 | 13.88204 | 13.97388 | 13.97388 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100pmol | 2 | 15840.281 | 13.95131 | 14.20112 | 14.20112 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100pmol | 3 | 15022.215 | 13.87481 | 13.94448 | 13.94448 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100pmol | 4 | 15160.493 | 13.88803 | 13.97388 | 13.97388 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200pmol | 1 | 21577.973 | 14.39727 | 14.00189 | 14.00189 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200pmol | 2 | 22968.959 | 14.48740 | 13.38772 | 13.38772 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200pmol | 3 | 20720.127 | 14.33875 | 13.70002 | 13.70002 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200pmol | 4 | 22153.398 | 14.43524 | 13.88102 | 13.88102 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50pmol | 1 | 12183.812 | 13.57268 | 13.88102 | 13.88102 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50pmol | 2 | 12521.783 | 13.61215 | 13.84672 | 13.84672 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50pmol | 3 | 11926.220 | 13.54185 | 14.13067 | 14.13067 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50pmol | 4 | 12021.495 | 13.55333 | 13.84672 | 13.84672 |

## trimFASTA

[←
Previous](https://uconn-scs.github.io/msDiaLogue/articles/visualization.md)
