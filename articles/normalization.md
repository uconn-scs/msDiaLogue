# Normalization

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
```

## Example

``` r
dataNorm <- normalize(dataFiltAnno, normalizeType = "median")
#> Warning: Removed 55 rows containing non-finite outside the scale range
#> (`stat_boxplot()`).
```

![](normalization_files/figure-html/unnamed-chunk-2-1.png)

    #> Warning: Removed 55 rows containing non-finite outside the scale range
    #> (`stat_boxplot()`).

![](normalization_files/figure-html/unnamed-chunk-2-2.png)

The message “Warning: Removed 55 rows containing non-finite values
outside the scale range
([`stat_boxplot()`](https://ggplot2.tidyverse.org/reference/geom_boxplot.html))”
indicates the presence of 55 `NA` (Not Available) values in the data.
These `NA` values arise when a protein was not identified in a
particular sample or condition and are automatically excluded when
generating the boxplot but retained in the actual dataset.

| R.Condition | R.Replicate | NUD4B_HUMAN (+1) | A0A7P0T808_HUMAN (+1) | A0A8I5KU53_HUMAN (+1) | ZN840_HUMAN | CC85C_HUMAN | TMC5B_HUMAN | C9JEV0_HUMAN (+1) | C9JNU9_HUMAN | CYC_BOVIN | TRFE_BOVIN | KRT16_MOUSE | F8W0H2_HUMAN | H0Y7V7_HUMAN (+1) | H0YD14_HUMAN | H3BUF6_HUMAN | H7C1W4_HUMAN (+1) | H7C3M7_HUMAN | TCPR2_HUMAN | TLR3_HUMAN | LRIG2_HUMAN | RAB3D_HUMAN | ADH1_YEAST | LYSC_CHICK | BGAL_ECOLI | CYTA_HUMAN | KPCB_HUMAN | LIPL_HUMAN |  PIP_HUMAN | CO6_HUMAN | BGAL_HUMAN | SYTC_HUMAN | CASPE_HUMAN | DCAF6_HUMAN | DALD3_HUMAN | HGNAT_HUMAN | RFFL_HUMAN | RN185_HUMAN | ZN462_HUMAN | ALKB7_HUMAN | POLK_HUMAN | ACAD8_HUMAN | A0A7I2PK40_HUMAN (+2) | NBDY_HUMAN | H0Y5R1_HUMAN (+1) |
|:------------|:------------|-----------------:|----------------------:|----------------------:|------------:|------------:|------------:|------------------:|-------------:|----------:|-----------:|------------:|-------------:|------------------:|-------------:|-------------:|------------------:|-------------:|------------:|-----------:|------------:|------------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|----------:|-----------:|-----------:|------------:|------------:|------------:|------------:|-----------:|------------:|------------:|------------:|-----------:|------------:|----------------------:|-----------:|------------------:|
| 100pmol     | 1           |        0.6578963 |             1.6912275 |              1.523093 |  -1.6229297 |  -0.9854966 |  -1.1043408 |        -2.2020970 |   -2.0487396 |  3.452154 |   3.943761 |   0.8750155 |   -0.6386260 |         0.4190686 |    0.3832438 |   -1.8057427 |         -1.711792 |    0.2348458 |   4.0685046 |  -2.451893 |  -0.9267417 |   0.3315355 |   4.814073 |   3.813956 |   4.602821 | -0.6759724 |  0.0138251 | -1.1567811 | -2.8904188 | -2.703667 |   1.866666 |   4.775565 |  -3.1627881 |   -2.212775 |   0.3976973 |   1.0009580 |  -2.370005 |   0.1730515 |   0.0000000 |  -2.4413680 |  -2.300598 |  -2.2255399 |                    NA |         NA |                NA |
| 100pmol     | 2           |        1.1618220 |             2.6069381 |              0.499450 |  -0.8939165 |  -0.4318767 |  -0.5842473 |        -2.0224822 |   -1.2582828 |  3.826245 |   4.398260 |          NA |   -0.3855094 |         0.5688423 |    0.7856583 |   -1.4665636 |         -1.598602 |    0.4582302 |   0.9594429 |  -1.817571 |  -0.6094305 |   0.6593645 |   5.179413 |   4.207712 |   4.995489 | -0.2306371 |  0.5203989 | -1.0431798 | -2.5441755 | -2.550131 |   2.183688 |   5.153782 |  -2.2734413 |   -1.107578 |   0.5054164 |   1.0064713 |  -2.287126 |   0.7952927 |  -0.9506921 |  -2.6135205 |   0.000000 |  -1.6024466 |             0.9187622 |         NA |                NA |
| 100pmol     | 3           |        0.6700794 |             2.3944773 |              1.292374 |  -1.6925457 |  -0.6687828 |          NA |        -2.9987418 |   -0.8270544 |  3.584108 |   4.078495 |          NA |   -0.5356376 |         0.4615256 |    0.0895033 |   -1.5213077 |         -1.715882 |    1.0240181 |   4.5994444 |  -2.147069 |  -1.3776219 |   0.4651160 |   4.902153 |   3.948069 |   4.690354 | -0.6886192 |  0.4043134 | -1.4787373 |         NA | -2.907444 |   1.976459 |   4.876785 |  -3.2755551 |   -1.478305 |   0.1742765 |   0.5943610 |  -2.635191 |   0.6053144 |  -1.0476748 |  -2.6195940 |  -2.377350 |  -2.0024438 |             1.0871434 | -0.0895033 |                NA |
| 100pmol     | 4           |        0.8459180 |             2.0861542 |              1.194119 |  -1.2273728 |  -0.6919248 |  -1.0950379 |        -3.4192914 |   -1.4298346 |  3.588195 |   4.071733 |          NA |   -0.0242533 |         0.3495332 |    0.2761703 |           NA |         -1.974565 |    0.0000000 |   4.6691086 |  -1.904616 |  -1.1083001 |   0.4016035 |   4.859260 |   3.951123 |   4.629191 | -1.0397232 |  0.3669244 | -1.3587551 |         NA | -2.708964 |   1.949330 |   4.844947 |  -3.3525778 |   -2.049782 |  -0.8802224 |   0.9334560 |  -3.173078 |   0.1359572 |  -1.1958590 |  -2.7445785 |  -2.634663 |  -2.0589152 |             0.8367645 |  0.0759563 |         0.0187146 |
| 200pmol     | 1           |        1.2367495 |             2.7209140 |              1.643059 |  -0.9241627 |  -2.0376118 |  -0.8162876 |        -2.1284865 |           NA |  4.926798 |   5.071045 |   1.7850326 |   -0.3843617 |         0.9573775 |    0.7511402 |   -1.2486171 |         -1.348386 |    1.1799089 |   5.0396476 |  -1.519906 |  -1.0325902 |   0.8746494 |   6.245210 |   5.245063 |   6.005343 | -0.8155394 |  0.9062960 | -0.7355826 | -3.2948861 | -2.086968 |   2.468791 |   5.354433 |  -2.9824358 |   -1.791057 |   0.5501207 |   1.7437348 |  -2.291354 |  -0.7523574 |  -0.5793031 |  -1.4223468 |  -2.145883 |  -0.5956163 |             1.8647392 |         NA |         0.3843617 |
| 200pmol     | 2           |        0.8920522 |             2.1320303 |              1.448951 |          NA |  -0.5354481 |          NA |        -2.5546421 |   -1.4310495 |  4.653112 |   4.847591 |          NA |   -0.2522428 |         0.4211597 |           NA |   -1.4825147 |         -1.620216 |    0.3960272 |   5.0130415 |  -2.067634 |  -0.8169825 |   0.6131741 |   5.965971 |   4.954881 |   5.748865 | -0.3324563 |  0.6299749 | -0.9458767 |         NA | -2.553825 |   2.208374 |   5.114606 |  -3.5195148 |   -1.671696 |   0.3551539 |  -0.1366535 |  -2.779264 |   0.1366535 |  -0.8642755 |  -2.5798709 |  -2.309546 |  -2.3627650 |                    NA |  0.4016397 |         0.3267698 |
| 200pmol     | 3           |        1.2852038 |            -0.8407850 |              1.836982 |  -0.7498530 |  -0.1779857 |  -0.3638482 |        -2.6275134 |   -0.4297874 |  5.025134 |   5.020476 |   1.1847594 |   -0.1217261 |         1.1101593 |    0.9043385 |   -1.1300491 |         -1.793222 |    0.8158324 |          NA |  -1.870606 |  -0.5628205 |   0.9300210 |   6.311564 |   5.279995 |   6.070587 | -0.5160321 |  0.7621903 | -0.8359278 |         NA | -2.306285 |   2.467474 |   5.407801 |  -3.3621142 |   -2.223375 |   0.8759602 |   1.3922679 |  -2.542126 |   0.5557834 |  -0.1662571 |  -1.0158409 |  -2.121038 |  -1.6854347 |             1.1308682 |  0.3911933 |         0.1217261 |
| 200pmol     | 4           |        1.5207481 |            -0.6040897 |              2.060276 |  -0.3758423 |  -0.8639327 |  -0.0299450 |        -2.4855064 |   -0.7430913 |  5.224020 |   5.377023 |          NA |    0.0161123 |         0.7924755 |    1.0651086 |   -0.7232350 |         -2.448600 |    0.8442237 |          NA |  -1.693849 |          NA |   1.1502570 |   6.655618 |   5.628997 |   6.343191 | -0.0161123 |  1.0727957 | -0.6382337 |         NA | -2.135701 |   2.815138 |   5.691298 |  -2.9208223 |   -1.419815 |   0.9018856 |   1.6702296 |  -2.088800 |   0.1983234 |  -0.0738239 |  -1.3827316 |  -1.718714 |  -0.5015723 |             0.7489989 |         NA |                NA |
| 50pmol      | 1           |        1.3569066 |            -0.0418239 |             -1.605374 |  -1.1289594 |  -0.9034872 |          NA |         0.0539109 |   -1.5868197 |  3.547765 |   4.397999 |          NA |    0.0418239 |         0.6383018 |    1.0090953 |   -0.9876086 |         -1.713483 |    0.1019217 |   4.6094571 |  -1.921549 |  -0.9836494 |   1.0378691 |   4.827457 |   3.633069 |   4.671661 |  2.3687002 |  0.8333762 | -1.0023667 |  0.6250027 | -2.155108 |   2.618091 |   5.473048 |   0.5514687 |   -1.981854 |          NA |  -0.3248609 |  -2.734260 |  -0.6292096 |  -3.5325733 |  -1.2902634 |  -4.787183 |  -2.0214147 |                    NA |         NA |                NA |
| 50pmol      | 2           |        1.6024612 |                    NA |              1.579083 |  -0.5872764 |  -0.4786125 |          NA |        -0.9419543 |   -0.6649410 |  3.779592 |   4.677255 |          NA |    0.2521855 |         0.1196002 |    1.1937745 |   -0.7693976 |         -2.240260 |    0.7951258 |   5.6696768 |  -1.798939 |  -0.4338096 |   1.3649676 |   5.070432 |   3.993905 |   4.912229 |  0.8090999 |         NA | -0.4372525 | -1.4502514 | -1.552151 |   2.850557 |   5.750686 |  -1.2356313 |   -1.562935 |  -0.8838660 |   1.2757206 |  -2.381622 |   0.6504456 |   0.0000000 |  -1.7357928 |  -2.468666 |  -2.2680179 |                    NA |         NA |                NA |
| 50pmol      | 3           |        1.6576732 |            -3.4526216 |              1.552080 |  -2.4702967 |  -0.6505471 |  -0.2331366 |        -0.8524562 |   -0.7371056 |  3.729220 |   4.679342 |   1.5613017 |    0.2920380 |                NA |    1.1969443 |   -0.6623836 |         -2.395087 |    0.6664780 |   0.5179572 |         NA |          NA |   1.3371078 |   5.157961 |   3.997182 |   4.927047 |  0.9774672 |  1.0924818 | -0.5422253 | -1.8553484 | -1.947256 |   2.893225 |   5.804690 |  -1.1925628 |   -1.811837 |  -0.6752742 |   1.0031749 |  -2.315473 |   0.2331366 |  -0.8188381 |  -0.5723308 |  -2.056650 |  -2.4453921 |                    NA |         NA |                NA |
| 50pmol      | 4           |        1.3361532 |             0.6443309 |              1.275179 |  -1.1057418 |  -1.2905885 |  -0.4784206 |        -1.5849506 |   -0.6332468 |  3.345342 |   4.341111 |          NA |           NA |         0.0000000 |    1.1344349 |   -0.8056352 |         -4.298759 |    0.5579245 |   4.7272986 |  -2.058139 |  -1.0248051 |   0.9560929 |   4.778818 |   3.668827 |   4.637064 |  0.5802164 |  0.9408524 |         NA | -1.9589666 |        NA |   2.591638 |   5.452341 |  -1.6387928 |   -1.429612 |   0.1904210 |   0.7490866 |  -4.231605 |  -0.1802510 |  -0.3981666 |  -1.8530176 |  -2.042691 |  -2.1323101 |                    NA |         NA |                NA |

## Details

Normalization is designed to address systematic biases in the data.
Biases can arise from inadvertent sample grouping during generation or
preparation, from variations in instrument performance during
acquisition, analysis of different peptide amounts across experiments,
or other reasons. These factors can artificially mask or enhance actual
biological changes.

Many normalization methods have been developed for large datasets, each
with its own strengths and weaknesses. The following factors should be
considered when choosing a normalization method:

1.  Experiment-Specific Normalization:  
    Most experiments run with [UConn PMF](https://proteomics.uconn.edu)
    are normalized by injection amount at the time of analysis to
    facilitate comparison. “Amount” is measured by UV absorbance at 280
    nm, a standard method for generic protein quantification.

2.  Assumption of Non-Changing Species:  
    Most biological experiments implicitly assume that the majority of
    measured species in an experiment will not change across conditions.
    This assumption is more robust the more measurements your experiment
    has (e.g. several thousand proteins). It may not be true at all for
    small datasets (tens of proteins).

If you are analyzing a batch of samples with very different complexities
(e.g. a set of IPs where the control samples have tens of proteins and
the experimental samples have hundreds of proteins), you should not
normalize all of these together, but break them up into subsets of
similar complexity.

By default, normalization is performed across samples, adjusting protein
expression levels within each sample relative to the other samples. So
far, this package provides eight normalization methods for use:

1.  “auto”: Auto scaling (mean centering and then dividing by the
    standard deviation of each variable) ([Jackson
    1991](#ref-jackson1991user)).

2.  “level”: Level scaling (mean centering and then dividing by the mean
    of each variable).

3.  “mean”: Mean centering.

4.  “median”: Median centering.

5.  “pareto”: Pareto scaling (mean centering and then dividing by the
    square root of the standard deviation of each variable).

6.  “quant”: Quantile normalization ([Bolstad et al.
    2003](#ref-bolstad2003comparison)).

7.  “range”: Range scaling (mean centering and then dividing by the
    range of each variable).

8.  “vast”: Variable stability (VAST) scaling ([Keun et al.
    2003](#ref-keun2003improved)).

## Reference

[←
Previous](https://uconn-scs.github.io/msDiaLogue/articles/filtering_annotation_based.md)

[Next
→](https://uconn-scs.github.io/msDiaLogue/articles/filtering_data_driven.md)

Bolstad, B. M., R. A. Irizarry, M. Astrand, and T. P. Speed. 2003. “A
Comparison of Normalization Methods for High Density Oligonucleotide
Array Data Based on Variance and Bias.” *Bioinformatics* 19 (2): 185–93.
<https://doi.org/10.1093/bioinformatics/19.2.185>.

Jackson, J. Edward. 1991. *A User’s Guide to Principal Components*. John
Wiley & Sons.

Keun, Hector C., Timothy M. D. Ebbels, Henrik Antti, Mary E. Bollard,
Olaf Beckonert, Elaine Holmes, John C. Lindon, and Jeremy K. Nicholson.
2003. “Improved Analysis of Multivariate Data by Variable Stability
Scaling: Application to NMR-Based Metabolic Profiling.” *Analytica
Chimica Acta* 490 (1–2): 265–76.
<https://doi.org/10.1016/S0003-2670(03)00094-1>.
