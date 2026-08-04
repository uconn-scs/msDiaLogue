# Imputation

## Preliminary

``` r

## load R package
library(msDiaLogue)
## preprocessing
fileName <- "../inst/extdata/Spectronaut_HeLa6Mix_Data.csv"
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
|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 100fmol | 1 | 0.7110886 | 1.6974365 | 1.8672903 | -1.4647051 | -1.1828195 | -2.1839064 | -2.1163940 | 3.390533 | 3.925004 | -0.7955644 | 0.5275957 | 0.3054453 | -1.5384555 | -1.563866 | 0.2786759 | -2.238805 | -0.7218126 | 0.5172853 | 4.980386 | 3.891424 | 4.645080 | -0.6444628 | 0.0000000 | -1.1003773 | -2.304353 | 2.127338 | 4.699935 | -3.1345122 | -2.193699 | 0.5966224 | 1.0753304 | -2.247059 | 0.2553331 | 0.0802151 | -2.1575204 | -2.246770 | -1.9203595 |
| 100fmol | 2 | 1.3291690 | 2.6191023 | 0.2493124 | -0.6658141 | -0.4511877 | -1.7915185 | -1.2163618 | 3.935406 | 4.461227 | -0.2469202 | 0.7448112 | 0.8368538 | -1.3356925 | -1.357357 | 0.6040186 | -1.568828 | -0.3830931 | 0.8214865 | 5.296860 | 4.200130 | 5.274795 | -0.2342312 | 0.9189694 | -0.7390658 | -2.615207 | 2.164203 | 5.273847 | -2.2260264 | -1.074713 | 0.4511319 | 1.0829802 | -2.317359 | 0.6376646 | -0.9225421 | -2.3979322 | 0.000000 | -1.4317308 |
| 100fmol | 3 | 0.4784339 | 2.2448068 | 1.1199920 | -2.0149419 | -0.8627000 | -3.1172331 | -1.0047353 | 3.104257 | 4.058083 | -0.6125153 | 0.0695863 | 0.0071198 | -1.7427644 | -2.126324 | 0.6218682 | -2.407292 | -1.7721382 | 0.3807319 | 5.021505 | 3.578761 | 4.620371 | -0.7612994 | 0.2686105 | -1.8078448 | -3.131526 | 1.874052 | 4.639424 | -3.3182372 | -1.715975 | 0.1425211 | 0.2593672 | -3.000622 | 0.8892680 | -1.2914442 | -2.7601984 | -2.469142 | -2.2558682 |
| 100fmol | 4 | 1.0695424 | 2.2061044 | 1.2396459 | -1.0910666 | -0.5499771 | -3.2366723 | -1.1506536 | 3.789528 | 4.195285 | 0.0169672 | 0.8080643 | 0.5332284 | -1.7427644 | -1.892344 | -0.0006345 | -1.544881 | -0.9761583 | 0.6503640 | 4.969877 | 4.052809 | 4.685813 | -0.9551142 | 0.7754941 | -1.1961556 | -2.503414 | 2.297533 | 4.940889 | -3.3253722 | -1.637636 | -0.7734746 | 0.9995338 | -3.181040 | 0.1210060 | -1.1082717 | -2.4850279 | -2.304152 | -1.7864377 |
| 200fmol | 1 | 1.2374451 | 2.7597767 | 1.5223831 | -1.0458613 | -2.1179882 | -2.3004893 | -1.4490356 | 4.904306 | 4.866936 | -0.3222491 | 0.8683913 | 0.6935989 | -1.2434857 | -1.125694 | 1.1592071 | -1.436832 | -1.0569094 | 0.6455738 | 6.162104 | 5.166465 | 6.004221 | -0.6358849 | 1.2291929 | -0.5202384 | -2.348306 | 2.404777 | 5.359378 | -2.8684507 | -1.660118 | 0.6409212 | 1.5345147 | -2.176700 | -0.8247065 | -0.5620090 | -1.4195158 | -2.092036 | -0.5999810 |
| 200fmol | 2 | 1.0835077 | 2.5061290 | 1.5437753 | -1.0458613 | -0.6451406 | -2.2891161 | -1.4490356 | 4.602911 | 4.780947 | -0.1192622 | 0.5369436 | 0.6935989 | -1.1033534 | -1.347294 | 0.5904082 | -2.069211 | -0.7825705 | 0.7998727 | 6.035927 | 4.858498 | 6.077079 | -0.1157688 | 0.7494304 | -0.6849393 | -2.373287 | 2.218135 | 5.298451 | -3.4430880 | -1.495177 | 0.6330298 | -0.0504002 | -2.547260 | 0.0504002 | -0.8831795 | -2.2754926 | -2.169899 | -2.5736366 |
| 200fmol | 3 | 1.1895154 | -0.7610814 | 1.4827675 | -0.8782181 | -0.2278802 | -2.6460631 | -0.4371524 | 4.602658 | 5.324737 | -0.0945005 | 1.1912667 | 0.9555801 | -1.2270376 | -1.805385 | 0.6127170 | -2.003841 | -0.2808755 | 0.6251033 | 6.177903 | 5.332350 | 6.077462 | -0.6677980 | 0.5516635 | -0.8818061 | -2.631290 | 2.405737 | 5.368524 | -3.4036282 | -2.442303 | 0.8779300 | 1.5244318 | -2.543026 | 0.3252309 | -0.2958292 | -1.0326304 | -2.281109 | -2.0634390 |
| 200fmol | 4 | 1.3414509 | -0.7141775 | 2.1097733 | -0.5132050 | -0.8907703 | -2.5064949 | -0.7084750 | 5.104710 | 4.936069 | 0.0185604 | 0.6527368 | 1.2622077 | -0.7415416 | -2.490006 | 0.9681441 | -1.818448 | -1.0569094 | 1.0922337 | 6.831663 | 5.361835 | 6.256076 | -0.0211462 | 1.0564532 | -0.8429453 | -2.350769 | 2.858331 | 5.788169 | -3.3014491 | -1.301171 | 0.6632118 | 1.6762101 | -2.053225 | 0.1098565 | -0.2265231 | -1.4185097 | -1.715035 | -0.4337676 |
| 50fmol | 1 | 1.1006904 | 0.0128438 | -1.6818749 | -1.3067518 | -0.7490562 | 0.2825328 | -1.5975565 | 3.812621 | 4.337253 | -0.0128438 | 0.6400481 | 1.2359921 | -1.0547978 | -1.679806 | 0.0489373 | -1.896376 | -0.8121651 | 1.0352351 | 4.910162 | 3.725298 | 4.783498 | 2.2656960 | 1.0479490 | -1.0774637 | -1.972683 | 2.784651 | 5.295658 | 0.4053746 | -2.197920 | -0.7162235 | -0.3212160 | -2.701866 | -0.5696866 | -3.6395447 | -1.4537604 | -4.659186 | -1.9331960 |
| 50fmol | 2 | 1.5961351 | -3.3201971 | 1.5598933 | -0.4403285 | -0.4868333 | -0.9743640 | -0.4967305 | 3.965407 | 4.704723 | 0.1790180 | 0.0539524 | 0.9962309 | -0.7435314 | -1.952132 | 0.9180740 | -1.739766 | -0.5142051 | 1.3431911 | 5.038411 | 3.933687 | 5.021220 | 0.6437576 | 1.0479490 | -0.3051809 | -1.452492 | 3.208565 | 5.677698 | -1.1063367 | -1.668382 | -0.7162235 | 1.3191634 | -2.135900 | 0.4473614 | 0.0000000 | -1.8044113 | -2.489725 | -2.3514462 |
| 50fmol | 3 | 1.9377582 | -3.3201971 | 1.9463231 | -2.1765737 | -0.4435426 | -0.6520978 | -0.5861618 | 3.755350 | 4.947876 | 0.4559941 | 0.0539524 | 1.4776452 | -0.6557229 | -2.603859 | 0.9301517 | -1.896376 | -1.1704237 | 1.3669372 | 5.336210 | 3.913673 | 5.294049 | 1.4423886 | 1.4440220 | -0.3495777 | -1.969386 | 3.203846 | 5.970880 | -1.0907178 | -1.818956 | -0.5219278 | 1.0772742 | -2.176159 | 0.2540670 | -0.3787774 | -0.3780465 | -1.704975 | -2.6241451 |
| 50fmol | 4 | 1.3727502 | 0.6804921 | 1.1415255 | -0.8947602 | -1.1117833 | -1.7312115 | -0.5159772 | 3.571163 | 4.404044 | -0.0128438 | 0.2248967 | 1.2113819 | -0.5418374 | -4.284571 | 0.6442855 | -1.781268 | -1.1704237 | 1.1056057 | 5.000695 | 3.593565 | 4.840452 | 0.5947847 | 1.2220923 | -1.0774637 | -1.972683 | 2.850284 | 5.785555 | -1.2210747 | -1.299660 | 0.0000000 | 0.8876834 | -4.067901 | -0.0686141 | -0.1821314 | -1.5731591 | -1.983371 | -2.0406905 |

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
    algorithm ([Kim et al. 2004](#ref-kim2004reuse)).

5.  [`impute.knn_trunc()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_trunc.md):
    Replaces missing values using the truncated k-nearest neighbors
    algorithm ([Shah et al. 2017](#ref-shah2017distribution)).

6.  [`impute.nuc_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.nuc_norm.md):
    Replaces missing values using the nuclear-norm regularization
    ([Hastie et al. 2015](#ref-hastie2015matrix)).

7.  [`impute.mice_cart()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_cart.md):
    Replaces missing values using the classification and regression
    trees ([Breiman et al. 1984](#ref-breiman1984classification); [Doove
    et al. 2014](#ref-doove2014recursive); [van Buuren
    2018](#ref-van2018flexible)).

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
*Classification and Regression Trees*. Routledge.

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
John Wiley & Sons.

Schafer, Joseph L. 1997. *Analysis of Incomplete Multivariate Data*.
Chapman & Hall/CRC.

Shah, Jasmit S., Shesh N. Rai, Andrew P. DeFilippis, Bradford G. Hill,
Aruni Bhatnagar, and Guy N. Brock. 2017. “Distribution Based Nearest
Neighbor Imputation for Truncated High Dimensional Data with
Applications to Pre-Clinical and Clinical Metabolomics Studies.” *BMC
Bioinformatics* 18: 114. <https://doi.org/10.1186/s12859-017-1547-6>.

Stacklies, Wolfram, Henning Redestig, Matthias Scholz, Dirk Walther, and
Joachim Selbig. 2007. “pcaMethods–a Bioconductor Package Providing PCA
Methods for Incomplete Data.” *Bioinformatics* 23 (9): 1164–67.
<https://doi.org/10.1093/bioinformatics/btm069>.

Troyanskaya, Olga, Michael Cantor, Gavin Sherlock, et al. 2001. “Missing
Value Estimation Methods for DNA Microarrays.” *Bioinformatics* 17 (6):
520–25. <https://doi.org/10.1093/bioinformatics/17.6.520>.

van Buuren, Stef. 2018. *Flexible Imputation of Missing Data*. Chapman &
Hall/CRC.

van Buuren, Stef, and Karin Groothuis-Oudshoorn. 2011. “Mice:
Multivariate Imputation by Chained Equations in R.” *Journal of
Statistical Software* 45 (3): 1–67.
<https://doi.org/10.18637/jss.v045.i03>.
