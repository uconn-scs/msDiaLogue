# Student's t-test

Perform Student's t-tests on the data.

## Usage

``` r
analyze.t(
  dataSet,
  ref = NULL,
  adjust.method = "none",
  paired = FALSE,
  pool.sd = FALSE,
  saveRes = TRUE
)
```

## Arguments

- dataSet:

  The 2d data set of data.

- ref:

  A string (default = NULL) specifying the reference condition for
  comparison. If NULL, all pairwise comparisons are performed.

- adjust.method:

  A string (default = "none") specifying the correction method for
  p-value adjustment:

  - "BH" or its alias "fdr": Benjamini and Hochberg (1995) .

  - "BY": Benjamini and Yekutieli (2001) .

  - "bonferroni": Bonferroni (1936) .

  - "hochberg": Hochberg (1988) .

  - "holm": Holm (1979) .

  - "hommel": Hommel (1988) .

  - "none": None

  See [`p.adjust`](https://rdrr.io/r/stats/p.adjust.html) for more
  details.

- paired:

  A boolean (default = FALSE) specifying whether or not to perform a
  paired test.

- pool.sd:

  A boolean (default = FALSE) specifying whether or not to use a pooled
  standard deviation.

- saveRes:

  A boolean (default = TRUE) specifying whether to save the analysis
  results to the current working directory.

## Value

A list comprising data frames for each comparison, with each data frame
containing the means of the two compared conditions for each protein,
the difference in means, and the p-values.

## References

Benjamini Y, Hochberg Y (1995). “Controlling the False Discovery Rate: A
Practical and Powerful Approach to Multiple Testing.” *Journal of the
Royal Statistical Society: Series B (Methodological)*, **57**(1),
289–300.
[doi:10.1111/j.2517-6161.1995.tb02031.x](https://doi.org/10.1111/j.2517-6161.1995.tb02031.x)
.  
  
Benjamini Y, Yekutieli D (2001). “The Control of the False Discovery
Rate in Multiple Testing under Dependency.” *The Annals of Statistics*,
**29**(4), 1165–1188.
[doi:10.1214/aos/1013699998](https://doi.org/10.1214/aos/1013699998) .  
  
Bonferroni CE (1936). “Teoria Statistica Delle Classi e Calcolo Delle
Probabilità.” *Pubblicazioni del R Istituto Superiore di Scienze
Economiche e Commerciali di Firenze*, **8**, 3–62.  
  
Hochberg Y (1988). “A Sharper Bonferroni Procedure for Multiple Tests of
Significance.” *Biometrika*, **75**(4), 800–802.
[doi:10.1093/biomet/75.4.800](https://doi.org/10.1093/biomet/75.4.800)
.  
  
Holm S (1979). “A Simple Sequentially Rejective Multiple Test
Procedure.” *Scandinavian Journal of Statistics*, **6**(2), 65–70.
<https://www.jstor.org/stable/4615733>.  
  
Hommel G (1988). “A Stagewise Rejective Multiple Test Procedure Based on
a Modified Bonferroni Test.” *Biometrika*, **75**(2), 383–386.
[doi:10.1093/biomet/75.2.383](https://doi.org/10.1093/biomet/75.2.383) .
