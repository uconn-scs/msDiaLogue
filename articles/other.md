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
## annotation-based filtering
dataFiltAnno <- filterOutIn(dataTran, listName = "ALBU_BOVIN",
                            removeList = TRUE, saveRm = TRUE)
## normalization
dataNorm <- normalize(dataFiltAnno, normalizeType = "median")
## data-driven filtering
dataFilt <- filterNA(dataNorm, minProp = 0.51, by = "cond", saveRm = TRUE)
## imputation
dataImput <- impute.min_local(dataFilt)
```

## pullProteinPath

The function
[`pullProteinPath()`](https://uconn-scs.github.io/msDiaLogue/reference/pullProteinPath.md)
allows you to see the quantitative values associated with specific
proteins at each step of processing, using either the exact match
argument `listname`, or the text match argument `regexName`, or both.

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

| PG.ProteinNames | PG.Genes | PG.ProteinAccession | PG.ProteinAccessions | PG.ProteinDescriptions               | PG.ProteinName | R.Condition | R.Replicate |    Initial | Transformed | Normalized |  Imputed |
|:----------------|:---------|:--------------------|:---------------------|:-------------------------------------|:---------------|:------------|:------------|-----------:|------------:|-----------:|---------:|
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 100pmol     | 1           | 111209.703 |    16.76292 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 100pmol     | 2           | 111659.883 |    16.76875 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 100pmol     | 3           | 105982.914 |    16.69347 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 100pmol     | 4           | 104442.562 |    16.67235 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 200pmol     | 1           | 109245.289 |    16.73721 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 200pmol     | 2           | 113357.508 |    16.79052 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 200pmol     | 3           | 114321.836 |    16.80274 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 200pmol     | 4           | 116439.820 |    16.82923 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 50pmol      | 1           | 117803.492 |    16.84602 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 50pmol      | 2           | 110086.680 |    16.74828 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 50pmol      | 3           | 105640.203 |    16.68880 |         NA |       NA |
| ALBU_BOVIN      | ALB      | CON\_\_P02769       | CON\_\_P02769        | Bovine serum albumin                 | ALBU_BOVIN     | 50pmol      | 4           | 110446.000 |    16.75298 |         NA |       NA |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 100pmol     | 1           |  23840.031 |    14.54110 |   4.602821 | 4.602821 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 100pmol     | 2           |  23963.307 |    14.54854 |   4.995489 | 4.995489 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 100pmol     | 3           |  22957.350 |    14.48667 |   4.690354 | 4.690354 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 100pmol     | 4           |  22311.297 |    14.44549 |   4.629191 | 4.629191 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 200pmol     | 1           |  41234.672 |    15.33157 |   6.005343 | 6.005343 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 200pmol     | 2           |  42899.434 |    15.38867 |   5.748865 | 5.748865 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 200pmol     | 3           |  42904.945 |    15.38886 |   6.070587 | 6.070587 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 200pmol     | 4           |  43279.844 |    15.40141 |   6.343191 | 6.343191 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 50pmol      | 1           |  14728.673 |    13.84634 |   4.671661 | 4.671661 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 50pmol      | 2           |  14736.710 |    13.84713 |   4.912229 | 4.912229 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 50pmol      | 3           |  14160.203 |    13.78955 |   4.927047 | 4.927047 |
| BGAL_ECOLI      | lacZ     | P00722              | P00722               | Beta-galactosidase                   | BGAL_ECOLI     | 50pmol      | 4           |  14758.731 |    13.84928 |   4.637064 | 4.637064 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 100pmol     | 1           |  10737.953 |    13.39043 |   3.452154 | 3.452154 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 100pmol     | 2           |  10655.384 |    13.37929 |   3.826245 | 3.826245 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 100pmol     | 3           |  10663.714 |    13.38042 |   3.584108 | 3.584108 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 100pmol     | 4           |  10843.115 |    13.40449 |   3.588195 | 3.588195 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 200pmol     | 1           |  19524.863 |    14.25302 |   4.926798 | 4.926798 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 200pmol     | 2           |  20072.297 |    14.29292 |   4.653112 | 4.653112 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 200pmol     | 3           |  20787.127 |    14.34340 |   5.025134 | 5.025134 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 200pmol     | 4           |  19924.240 |    14.28224 |   5.224020 | 5.224020 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 50pmol      | 1           |   6758.298 |    12.72244 |   3.547765 | 3.547765 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 50pmol      | 2           |   6721.135 |    12.71449 |   3.779592 | 3.779592 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 50pmol      | 3           |   6172.877 |    12.59173 |   3.729220 | 3.729220 |
| CYC_BOVIN       | CYCS     | CON\_\_P62894       | CON\_\_P62894        | Cytochrome c                         | CYC_BOVIN      | 50pmol      | 4           |   6028.398 |    12.55756 |   3.345342 | 3.345342 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 100pmol     | 1           |  13798.590 |    13.75223 |   3.813956 | 3.813956 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 100pmol     | 2           |  13880.411 |    13.76076 |   4.207712 | 4.207712 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 100pmol     | 3           |  13723.719 |    13.74438 |   3.948069 | 3.948069 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 100pmol     | 4           |  13944.603 |    13.76742 |   3.951123 | 3.951123 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 200pmol     | 1           |  24344.188 |    14.57129 |   5.245063 | 5.245063 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 200pmol     | 2           |  24742.227 |    14.59469 |   4.954881 | 4.954881 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 200pmol     | 3           |  24803.633 |    14.59826 |   5.279995 | 5.279995 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 200pmol     | 4           |  26381.047 |    14.68721 |   5.628997 | 5.628997 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 50pmol      | 1           |   7169.955 |    12.80775 |   3.633069 | 3.633069 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 50pmol      | 2           |   7797.536 |    12.92880 |   3.993905 | 3.993905 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 50pmol      | 3           |   7432.793 |    12.85969 |   3.997182 | 3.997182 |
| LYSC_CHICK      | LYZ      | P00698              | P00698               | Lysozyme C                           | LYSC_CHICK     | 50pmol      | 4           |   7543.633 |    12.88104 |   3.668827 | 3.668827 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 100pmol     | 1           |  15097.670 |    13.88204 |   3.943761 | 3.943761 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 100pmol     | 2           |  15840.281 |    13.95131 |   4.398260 | 4.398260 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 100pmol     | 3           |  15022.215 |    13.87481 |   4.078495 | 4.078495 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 100pmol     | 4           |  15160.493 |    13.88803 |   4.071733 | 4.071733 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 200pmol     | 1           |  21577.973 |    14.39727 |   5.071045 | 5.071045 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 200pmol     | 2           |  22968.959 |    14.48740 |   4.847591 | 4.847591 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 200pmol     | 3           |  20720.127 |    14.33875 |   5.020476 | 5.020476 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 200pmol     | 4           |  22153.398 |    14.43524 |   5.377023 | 5.377023 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 50pmol      | 1           |  12183.812 |    13.57268 |   4.397999 | 4.397999 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 50pmol      | 2           |  12521.783 |    13.61215 |   4.677255 | 4.677255 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 50pmol      | 3           |  11926.220 |    13.54185 |   4.679342 | 4.679342 |
| TRFE_BOVIN      | TF       | CON\_\_Q0IIK2       | CON\_\_Q0IIK2        | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN     | 50pmol      | 4           |  12021.495 |    13.55333 |   4.341111 | 4.341111 |

## trimFASTA

[←
Previous](https://uconn-scs.github.io/msDiaLogue/articles/visualization.md)
