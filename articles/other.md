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

| PG.ProteinNames | PG.Genes | PG.ProteinAccession | PG.ProteinAccessions | PG.ProteinDescriptions | PG.ProteinName | R.Condition | R.Replicate | Initial | Transformed | Normalized | Imputed |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|---:|---:|
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100fmol | 1 | 108811.839 | 16.73148 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100fmol | 2 | 98828.470 | 16.59264 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100fmol | 3 | 101598.443 | 16.63252 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 100fmol | 4 | 99355.873 | 16.60032 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200fmol | 1 | 132136.026 | 17.01166 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200fmol | 2 | 105138.414 | 16.68193 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200fmol | 3 | 113944.784 | 16.79798 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 200fmol | 4 | 115019.734 | 16.81152 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50fmol | 1 | 131830.656 | 17.00833 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50fmol | 2 | 116311.560 | 16.82764 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50fmol | 3 | 104564.526 | 16.67403 | NA | NA |
| ALBU_BOVIN | ALB | CON\_\_P02769 | CON\_\_P02769 | Bovine serum albumin | ALBU_BOVIN | 50fmol | 4 | 123775.117 | 16.91736 | NA | NA |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100fmol | 1 | 23121.661 | 14.49696 | 4.645080 | 4.645080 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100fmol | 2 | 27456.118 | 14.74484 | 5.274795 | 5.274795 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100fmol | 3 | 24838.926 | 14.60032 | 4.620371 | 4.620371 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 100fmol | 4 | 20619.410 | 14.33172 | 4.685813 | 4.685813 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200fmol | 1 | 41429.571 | 15.33837 | 6.004221 | 6.004221 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200fmol | 2 | 50769.826 | 15.63168 | 6.077079 | 6.077079 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200fmol | 3 | 45150.455 | 15.46245 | 6.077462 | 6.077462 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 200fmol | 4 | 42463.095 | 15.37392 | 6.256076 | 6.256076 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50fmol | 1 | 16139.561 | 13.97831 | 4.783498 | 4.783498 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50fmol | 2 | 15811.830 | 13.94872 | 5.021220 | 5.021220 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50fmol | 3 | 15935.567 | 13.95996 | 5.294049 | 5.294049 |
| BGAL_ECOLI | lacZ | P00722 | P00722 | Beta-galactosidase | BGAL_ECOLI | 50fmol | 4 | 15485.397 | 13.91862 | 4.840452 | 4.840452 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100fmol | 1 | 9690.868 | 13.24241 | 3.390533 | 3.390533 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100fmol | 2 | 10850.332 | 13.40545 | 3.935406 | 3.935406 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100fmol | 3 | 8684.345 | 13.08420 | 3.104257 | 3.104257 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 100fmol | 4 | 11078.152 | 13.43543 | 3.789528 | 3.789528 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200fmol | 1 | 19328.703 | 14.23846 | 4.904306 | 4.904306 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200fmol | 2 | 18274.136 | 14.15752 | 4.602911 | 4.602911 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200fmol | 3 | 16244.333 | 13.98765 | 4.602658 | 4.602658 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 200fmol | 4 | 19116.837 | 14.22256 | 5.104710 | 5.104710 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50fmol | 1 | 8234.339 | 13.00744 | 3.812621 | 3.812621 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50fmol | 2 | 7605.903 | 12.89290 | 3.965407 | 3.965407 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50fmol | 3 | 5484.956 | 12.42126 | 3.755350 | 3.755350 |
| CYC_BOVIN | CYCS | CON\_\_P62894 | CON\_\_P62894 | Cytochrome c | CYC_BOVIN | 50fmol | 4 | 6424.339 | 12.64933 | 3.571163 | 3.571163 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100fmol | 1 | 13713.424 | 13.74330 | 3.891424 | 3.891424 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100fmol | 2 | 13035.651 | 13.67018 | 4.200130 | 4.200130 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100fmol | 3 | 12066.374 | 13.55870 | 3.578761 | 3.578761 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 100fmol | 4 | 13296.061 | 13.69871 | 4.052809 | 4.052809 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200fmol | 1 | 23180.376 | 14.50062 | 5.166465 | 5.166465 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200fmol | 2 | 21816.062 | 14.41310 | 4.858498 | 4.858498 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200fmol | 3 | 26937.736 | 14.71734 | 5.332350 | 5.332350 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 200fmol | 4 | 22846.437 | 14.47968 | 5.361835 | 5.361835 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50fmol | 1 | 7750.717 | 12.92011 | 3.725298 | 3.725298 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50fmol | 2 | 7440.498 | 12.86118 | 3.933687 | 3.933687 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50fmol | 3 | 6121.150 | 12.57959 | 3.913673 | 3.913673 |
| LYSC_CHICK | LYZ | P00698 | P00698 | Lysozyme C | LYSC_CHICK | 50fmol | 4 | 6524.873 | 12.67173 | 3.593565 | 3.593565 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100fmol | 1 | 14036.363 | 13.77688 | 3.925004 | 3.925004 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100fmol | 2 | 15621.794 | 13.93127 | 4.461227 | 4.461227 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100fmol | 3 | 16821.601 | 14.03803 | 4.058083 | 4.058083 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 100fmol | 4 | 14676.159 | 13.84119 | 4.195285 | 4.195285 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200fmol | 1 | 18834.474 | 14.20109 | 4.866936 | 4.866936 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200fmol | 2 | 20674.320 | 14.33555 | 4.780947 | 4.780947 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200fmol | 3 | 26795.966 | 14.70973 | 5.324737 | 5.324737 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 200fmol | 4 | 17007.867 | 14.05391 | 4.936069 | 4.936069 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50fmol | 1 | 11845.641 | 13.53207 | 4.337253 | 4.337253 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50fmol | 2 | 12697.176 | 13.63222 | 4.704723 | 4.704723 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50fmol | 3 | 12536.008 | 13.61379 | 4.947876 | 4.947876 |
| TRFE_BOVIN | TF | CON\_\_Q0IIK2 | CON\_\_Q0IIK2 | Serotransferrin (UP merge to Q29443) | TRFE_BOVIN | 50fmol | 4 | 11443.279 | 13.48221 | 4.404044 | 4.404044 |

## trimFASTA

[←
Previous](https://uconn-scs.github.io/msDiaLogue/articles/visualization.md)
