# Imputation

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
```

## Examples

``` r
dataImput <- impute.min_local(dataFilt)
```

| R.Condition | R.Replicate | NUD4B_HUMAN (+1) | A0A7P0T808_HUMAN (+1) | A0A8I5KU53_HUMAN (+1) | ZN840_HUMAN | CC85C_HUMAN | C9JEV0_HUMAN (+1) | C9JNU9_HUMAN | CYC_BOVIN | TRFE_BOVIN | F8W0H2_HUMAN | H0Y7V7_HUMAN (+1) | H0YD14_HUMAN | H3BUF6_HUMAN | H7C1W4_HUMAN (+1) | H7C3M7_HUMAN | TLR3_HUMAN | LRIG2_HUMAN | RAB3D_HUMAN | ADH1_YEAST | LYSC_CHICK | BGAL_ECOLI | CYTA_HUMAN | KPCB_HUMAN | LIPL_HUMAN | CO6_HUMAN | BGAL_HUMAN | SYTC_HUMAN | CASPE_HUMAN | DCAF6_HUMAN | DALD3_HUMAN | HGNAT_HUMAN | RFFL_HUMAN | RN185_HUMAN | ZN462_HUMAN | ALKB7_HUMAN | POLK_HUMAN | ACAD8_HUMAN |
|:------------|:------------|-----------------:|----------------------:|----------------------:|------------:|------------:|------------------:|-------------:|----------:|-----------:|-------------:|------------------:|-------------:|-------------:|------------------:|-------------:|-----------:|------------:|------------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|----------:|-----------:|-----------:|------------:|------------:|------------:|------------:|-----------:|------------:|------------:|------------:|-----------:|------------:|
| 100pmol     | 1           |        0.6578963 |             1.6912275 |              1.523093 |  -1.6229297 |  -0.9854966 |        -2.2020970 |   -2.0487396 |  3.452154 |   3.943761 |   -0.6386260 |         0.4190686 |    0.3832438 |   -1.8057427 |         -1.711792 |    0.2348458 |  -2.451893 |  -0.9267417 |   0.3315355 |   4.814073 |   3.813956 |   4.602821 | -0.6759724 |  0.0138251 | -1.1567811 | -2.703667 |   1.866666 |   4.775565 |  -3.1627881 |   -2.212775 |   0.3976973 |   1.0009580 |  -2.370005 |   0.1730515 |   0.0000000 |  -2.4413680 |  -2.300598 |  -2.2255399 |
| 100pmol     | 2           |        1.1618220 |             2.6069381 |              0.499450 |  -0.8939165 |  -0.4318767 |        -2.0224822 |   -1.2582828 |  3.826245 |   4.398260 |   -0.3855094 |         0.5688423 |    0.7856583 |   -1.4665636 |         -1.598602 |    0.4582302 |  -1.817571 |  -0.6094305 |   0.6593645 |   5.179413 |   4.207712 |   4.995489 | -0.2306371 |  0.5203989 | -1.0431798 | -2.550131 |   2.183688 |   5.153782 |  -2.2734413 |   -1.107578 |   0.5054164 |   1.0064713 |  -2.287126 |   0.7952927 |  -0.9506921 |  -2.6135205 |   0.000000 |  -1.6024466 |
| 100pmol     | 3           |        0.6700794 |             2.3944773 |              1.292374 |  -1.6925457 |  -0.6687828 |        -2.9987418 |   -0.8270544 |  3.584108 |   4.078495 |   -0.5356376 |         0.4615256 |    0.0895033 |   -1.5213077 |         -1.715882 |    1.0240181 |  -2.147069 |  -1.3776219 |   0.4651160 |   4.902153 |   3.948069 |   4.690354 | -0.6886192 |  0.4043134 | -1.4787373 | -2.907444 |   1.976459 |   4.876785 |  -3.2755551 |   -1.478305 |   0.1742765 |   0.5943610 |  -2.635191 |   0.6053144 |  -1.0476748 |  -2.6195940 |  -2.377350 |  -2.0024438 |
| 100pmol     | 4           |        0.8459180 |             2.0861542 |              1.194119 |  -1.2273728 |  -0.6919248 |        -3.4192914 |   -1.4298346 |  3.588195 |   4.071733 |   -0.0242533 |         0.3495332 |    0.2761703 |   -1.8057427 |         -1.974565 |    0.0000000 |  -1.904616 |  -1.1083001 |   0.4016035 |   4.859260 |   3.951123 |   4.629191 | -1.0397232 |  0.3669244 | -1.3587551 | -2.708964 |   1.949330 |   4.844947 |  -3.3525778 |   -2.049782 |  -0.8802224 |   0.9334560 |  -3.173078 |   0.1359572 |  -1.1958590 |  -2.7445785 |  -2.634663 |  -2.0589152 |
| 200pmol     | 1           |        1.2367495 |             2.7209140 |              1.643059 |  -0.9241627 |  -2.0376118 |        -2.1284865 |   -1.4310495 |  4.926798 |   5.071045 |   -0.3843617 |         0.9573775 |    0.7511402 |   -1.2486171 |         -1.348386 |    1.1799089 |  -1.519906 |  -1.0325902 |   0.8746494 |   6.245210 |   5.245063 |   6.005343 | -0.8155394 |  0.9062960 | -0.7355826 | -2.086968 |   2.468791 |   5.354433 |  -2.9824358 |   -1.791057 |   0.5501207 |   1.7437348 |  -2.291354 |  -0.7523574 |  -0.5793031 |  -1.4223468 |  -2.145883 |  -0.5956163 |
| 200pmol     | 2           |        0.8920522 |             2.1320303 |              1.448951 |  -0.9241627 |  -0.5354481 |        -2.5546421 |   -1.4310495 |  4.653112 |   4.847591 |   -0.2522428 |         0.4211597 |    0.7511402 |   -1.4825147 |         -1.620216 |    0.3960272 |  -2.067634 |  -0.8169825 |   0.6131741 |   5.965971 |   4.954881 |   5.748865 | -0.3324563 |  0.6299749 | -0.9458767 | -2.553825 |   2.208374 |   5.114606 |  -3.5195148 |   -1.671696 |   0.3551539 |  -0.1366535 |  -2.779264 |   0.1366535 |  -0.8642755 |  -2.5798709 |  -2.309546 |  -2.3627650 |
| 200pmol     | 3           |        1.2852038 |            -0.8407850 |              1.836982 |  -0.7498530 |  -0.1779857 |        -2.6275134 |   -0.4297874 |  5.025134 |   5.020476 |   -0.1217261 |         1.1101593 |    0.9043385 |   -1.1300491 |         -1.793222 |    0.8158324 |  -1.870606 |  -0.5628205 |   0.9300210 |   6.311564 |   5.279995 |   6.070587 | -0.5160321 |  0.7621903 | -0.8359278 | -2.306285 |   2.467474 |   5.407801 |  -3.3621142 |   -2.223375 |   0.8759602 |   1.3922679 |  -2.542126 |   0.5557834 |  -0.1662571 |  -1.0158409 |  -2.121038 |  -1.6854347 |
| 200pmol     | 4           |        1.5207481 |            -0.6040897 |              2.060276 |  -0.3758423 |  -0.8639327 |        -2.4855064 |   -0.7430913 |  5.224020 |   5.377023 |    0.0161123 |         0.7924755 |    1.0651086 |   -0.7232350 |         -2.448600 |    0.8442237 |  -1.693849 |  -1.0325902 |   1.1502570 |   6.655618 |   5.628997 |   6.343191 | -0.0161123 |  1.0727957 | -0.6382337 | -2.135701 |   2.815138 |   5.691298 |  -2.9208223 |   -1.419815 |   0.9018856 |   1.6702296 |  -2.088800 |   0.1983234 |  -0.0738239 |  -1.3827316 |  -1.718714 |  -0.5015723 |
| 50pmol      | 1           |        1.3569066 |            -0.0418239 |             -1.605374 |  -1.1289594 |  -0.9034872 |         0.0539109 |   -1.5868197 |  3.547765 |   4.397999 |    0.0418239 |         0.6383018 |    1.0090953 |   -0.9876086 |         -1.713483 |    0.1019217 |  -1.921549 |  -0.9836494 |   1.0378691 |   4.827457 |   3.633069 |   4.671661 |  2.3687002 |  0.8333762 | -1.0023667 | -2.155108 |   2.618091 |   5.473048 |   0.5514687 |   -1.981854 |  -0.8838660 |  -0.3248609 |  -2.734260 |  -0.6292096 |  -3.5325733 |  -1.2902634 |  -4.787183 |  -2.0214147 |
| 50pmol      | 2           |        1.6024612 |            -3.4526216 |              1.579083 |  -0.5872764 |  -0.4786125 |        -0.9419543 |   -0.6649410 |  3.779592 |   4.677255 |    0.2521855 |         0.1196002 |    1.1937745 |   -0.7693976 |         -2.240260 |    0.7951258 |  -1.798939 |  -0.4338096 |   1.3649676 |   5.070432 |   3.993905 |   4.912229 |  0.8090999 |  0.8333762 | -0.4372525 | -1.552151 |   2.850557 |   5.750686 |  -1.2356313 |   -1.562935 |  -0.8838660 |   1.2757206 |  -2.381622 |   0.6504456 |   0.0000000 |  -1.7357928 |  -2.468666 |  -2.2680179 |
| 50pmol      | 3           |        1.6576732 |            -3.4526216 |              1.552080 |  -2.4702967 |  -0.6505471 |        -0.8524562 |   -0.7371056 |  3.729220 |   4.679342 |    0.2920380 |         0.0000000 |    1.1969443 |   -0.6623836 |         -2.395087 |    0.6664780 |  -2.058139 |  -1.0248051 |   1.3371078 |   5.157961 |   3.997182 |   4.927047 |  0.9774672 |  1.0924818 | -0.5422253 | -1.947256 |   2.893225 |   5.804690 |  -1.1925628 |   -1.811837 |  -0.6752742 |   1.0031749 |  -2.315473 |   0.2331366 |  -0.8188381 |  -0.5723308 |  -2.056650 |  -2.4453921 |
| 50pmol      | 4           |        1.3361532 |             0.6443309 |              1.275179 |  -1.1057418 |  -1.2905885 |        -1.5849506 |   -0.6332468 |  3.345342 |   4.341111 |    0.0418239 |         0.0000000 |    1.1344349 |   -0.8056352 |         -4.298759 |    0.5579245 |  -2.058139 |  -1.0248051 |   0.9560929 |   4.778818 |   3.668827 |   4.637064 |  0.5802164 |  0.9408524 | -1.0023667 | -2.155108 |   2.591638 |   5.452341 |  -1.6387928 |   -1.429612 |   0.1904210 |   0.7490866 |  -4.231605 |  -0.1802510 |  -0.3981666 |  -1.8530176 |  -2.042691 |  -2.1323101 |

## Details

The two primary MS/MS acquisition types implemented in large scale
MS-based proteomics have unique advantages and disadvantages.
Traditional data-dependent acquisition (DDA) methods favor specificity
in MS/MS sampling over comprehensive proteome coverage. Small peptide
isolation windows (\< 3 m/z) result in MS/MS spectra that contain
fragmentation data from ideally only one peptide. This specificity
promotes clear peptide identifications but comes at the expense of added
scan time. In DDA experiments, the number of peptides that can be
selected for MS/MS is limited by instrument scan speeds and is therefore
prioritized by highest peptide abundance. Low abundance peptides are
sampled less frequently for MS/MS and this can result in variable
peptide coverage and many missing protein data across large sample
datasets.

Data-independent acquisition (DIA) methods promote comprehensive peptide
coverage over specificity by sampling many peptides for MS/MS
simultaneously. Sequential and large mass isolation windows (4-50 m/z)
are used to isolate large numbers of peptides at once for concurrent
MS/MS. This produces complicated fragmentation spectra, but these
spectra contain data on every observable peptide. A major disadvantage
with this type of acquisition is that DIA MS/MS spectra are incredibly
complex and difficult to deconvolve. Powerful and relatively new
software programs like Spectronaut are capable of successfully parsing
out which fragment ions came from each co-fragmented peptide using
custom libraries, machine learning algorithms, and precisely determined
retention times or measured ion mobility data. Because all observable
ions are sampled for MS/MS, DIA reduces missingness substantially
compared to DDA, though not entirely.

Various imputation methods have been developed to address the
missing-value issue and assign a reasonable guess of quantitative value
to proteins with missing values. So far, this package provides the
following imputation methods:

1.  [`impute.min_local()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_local.md):
    Replaces missing values with the lowest measured value for that
    protein in that condition.

2.  [`impute.min_global()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_global.md):
    Replaces missing values with the lowest measured value from any
    protein found within the entire dataset.

3.  [`impute.knn()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn.md):
    Replaces missing values using the k-nearest neighbors algorithm
    ([Troyanskaya et al. 2001](#ref-troyanskaya2001missing)).

4.  [`impute.knn_seq()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_seq.md):
    Replaces missing values using the sequential k-nearest neighbors
    algorithm ([Kim, Kim, and Yi 2004](#ref-kim2004reuse)).

5.  [`impute.knn_trunc()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_trunc.md):
    Replaces missing values using the truncated k-nearest neighbors
    algorithm ([Shah et al. 2017](#ref-shah2017distribution)).

6.  [`impute.nuc_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.nuc_norm.md):
    Replaces missing values using the nuclear-norm regularization
    ([Hastie et al. 2015](#ref-hastie2015matrix)).

7.  [`impute.mice_cart()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_cart.md):
    Replaces missing values using the classification and regression
    trees ([Breiman et al. 1984](#ref-breiman1984classification);
    [Doove, van Buuren, and Dusseldorp 2014](#ref-doove2014recursive);
    [van Buuren 2018](#ref-van2018flexible)).

8.  [`impute.mice_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_norm.md):
    Replaces missing values using the Bayesian linear regression ([Rubin
    1987](#ref-rubin1987multiple); [Schafer
    1997](#ref-schafer1997analysis); [van Buuren and Groothuis-Oudshoorn
    2011](#ref-van2011mice)).

9.  [`impute.pca_bayes()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_bayes.md):
    Replaces missing values using the Bayesian principal components
    analysis ([Oba et al. 2003](#ref-oba2003bayesian)).

10. [`impute.pca_prob()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_prob.md):
    Replaces missing values using the probabilistic principal components
    analysis ([Stacklies et al. 2007](#ref-stacklies2007pcamethods)).

Additional methods will be added later.

## Reference

[←
Previous](https://uconn-scs.github.io/msDiaLogue/articles/filtering_data_driven.md)

[Next
→](https://uconn-scs.github.io/msDiaLogue/articles/summarization.md)

Breiman, L., J. Friedman, R. A. Olshen, and C. J. Stone. 1984.
*Classification and Regression Trees*. New York, NY, USA: Routledge.

Doove, Lisa L., Stef van Buuren, and Elise Dusseldorp. 2014. “Recursive
Partitioning for Missing Data Imputation in the Presence of Interaction
Effects.” *Computational Statistics & Data Analysis* 72: 92–104.
<https://doi.org/10.1016/j.csda.2013.10.025>.

Hastie, Trevor, Rahul Mazumder, Jason D. Lee, and Reza Zadeh. 2015.
“Matrix Completion and Low-Rank SVD via Fast Alternating Least Squares.”
*Journal of Machine Learning Research* 16 (104): 3367—3402.
[http://jmlr.org/papers/v16/hastie15a.html](http://jmlr.org/papers/v16/hastie15a.md).

Kim, Ki-Yeol, Byoung-Jin Kim, and Gwan-Su Yi. 2004. “Reuse of Imputed
Data in Microarray Analysis Increases Imputation Efficiency.” *BMC
Bioinformatics* 5: 160. <https://doi.org/10.1186/1471-2105-5-160>.

Oba, Shigeyuki, Masa-aki Sato, Ichiro Takemasa, Morito Monden, Ken-ichi
Matsubara, and Shin Ishii. 2003. “A Bayesian Missing Value Estimation
Method for Gene Expression Profile Data.” *Bioinformatics* 19 (16):
2088–96. <https://doi.org/10.1093/bioinformatics/btg287>.

Rubin, Donald B. 1987. *Multiple Imputation for Nonresponse in Surveys*.
New York, NY, USA: John Wiley & Sons.

Schafer, Joseph L. 1997. *Analysis of Incomplete Multivariate Data*. New
York, NY, USA: Chapman & Hall/CRC.

Shah, Jasmit S., Shesh N. Rai, Andrew P. DeFilippis, Bradford G. Hill,
Aruni Bhatnagar, and Guy N. Brock. 2017. “Distribution Based Nearest
Neighbor Imputation for Truncated High Dimensional Data with
Applications to Pre-Clinical and Clinical Metabolomics Studies.” *BMC
Bioinformatics* 18: 114. <https://doi.org/10.1186/s12859-017-1547-6>.

Stacklies, Wolfram, Henning Redestig, Matthias Scholz, Dirk Walther, and
Joachim Selbig. 2007. “pcaMethods–a Bioconductor Package Providing PCA
Methods for Incomplete Data.” *Bioinformatics* 23 (9): 1164–67.
<https://doi.org/10.1093/bioinformatics/btm069>.

Troyanskaya, Olga, Michael Cantor, Gavin Sherlock, Pat Brown, Trevor
Hastie, Robert Tibshirani, David Botstein, and Russ B. Altman. 2001.
“Missing Value Estimation Methods for DNA Microarrays.” *Bioinformatics*
17 (6): 520–25. <https://doi.org/10.1093/bioinformatics/17.6.520>.

van Buuren, Stef. 2018. *Flexible Imputation of Missing Data*. New York,
NY, USA: Chapman & Hall/CRC.

van Buuren, Stef, and Karin Groothuis-Oudshoorn. 2011. “Mice:
Multivariate Imputation by Chained Equations in R.” *Journal of
Statistical Software* 45 (3): 1–67.
<https://doi.org/10.18637/jss.v045.i03>.
