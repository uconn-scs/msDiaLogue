# msDiaLogue 0.0.6
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15706003.svg)](https://doi.org/10.5281/zenodo.15706003)


* Analysis:
  * Separate all options into individual functions `analyze.*()`.
  * Add`analyze.plsda()`.
  * Rewrite `analyze.pca()` and `analyze.plsda()` to improve clarity.

* Visualization:
  * Separate all options into individual functions `visualize.*()`.
  * Add `visualize.rank()`.
  * Rename `visualize.ind()` to `visualize.score()` to ensure compatibility with
    PLS-DA and any other future analyses that include scores.
  * Rename `visualize.var()` to `visualize.loading()` to ensure compatibility
    with PLS-DA and any other future analyses that include loadings.
  * Add `visualize.vip()`.

* Vignette:
  * Separate usage template into individual modules.
  * Add an FAQ section.

* Add NEWS.


# msDiaLogue 0.0.5
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15663360.svg)](https://doi.org/10.5281/zenodo.15663360)


* `preProcessFiltering()`: Intended for internal use only.

* `preprocessing_scaffold()`:
  * Make it compatible with the scaffold files containing GO information.
  * Add arguments `zeroNA` and `oneNA` to replace 0s and 1s with NAs.
  * Make it compatible with data without AlternateID. <br><br>

* `transform()`: Add root transformation.

* `normalize()`:
  * Add argument `plot`.
  * Add scaling and centering. <br><br>

* `impute.*()`:
  * Add the "R.Condition" and "R.Replicate" columns to the shadow matrix.
  * Use NA to represent missing values in both the pre- and post-imputation data. <br><br>

* `analyze()`:
  * Make it capable of performing multiple comparisons and reconstruct the
    result structure.
  * Add Wilcoxon test (`method = "wilcox-test"`).
  * Add PCA (`method = "PCA"`; seperate PCA into analyze and visualize).
  * Add argument `adjust.method`. <br><br>

* `visualize()`:
  * MA: Change the labels for the x and y axes; remove the title;
    change 'significant' in the legend to 'regulation';
    make it compatible with the whole result list.
  * normalize: Remove the title.
  * test: Make it compatible with the whole result list.
  * Venn: Add the argument `saveVenn` to save the data in the Venn plot.
  * volcano: Make it compatible with the whole result list.
  * PCA_ind and PCA_biplot: Remove the 'a' marker from the scatter in the legend. <br><br>

* Other:
  * `dataMissing()`: Add arguments `sort_miss`, `show_pct_legend`, and
    `show_pct_col`.
  * `pullProteinPath()`: Add arguments `listName`, `regexName`, and `by`. <br><br>

* vignette:
  * Change the note block border color to a paler red.
  * Add the instructions for addressing installation issues.
  * Add instructions for Bioconductor package installation.
  * Add cust_vis.
  * Update the example data.


# msDiaLogue 0.0.4


* For imputation, separate all options into individual functions,
  add `impute.mice_cart()`, `impute.mice_norm()`, `impute.pca_bayes()` and
  `impute.pca_prob()`.

* Use autoglobal.

* `preprocessing()`: add the hist for raw data; fix colnames.

* `filterOutIN()`: fix regex.

* `visualize()`: fix the point shape in the legend (ggrepel).

* `analyze()`: fix the factor level consistent with the input.

* Rewrite `trimFASTA()`.

* Drop R.FileName in all functions.

* Add `preprocessing_scaffold()`.

* Revise `filterProtein()` to make it compatible with Scaffold.

* Add note css.


# msDiaLogue 0.0.3


* For `impute()`, add options for `"knn"`,  `"seq-knn"`, `"trunc-knn"` and
  `"nuc-norm"`.

* Add `filterProtein()`.

* For `visualize()`, add support for `"Upset"`.


# msDiaLogue 0.0.2


* Add moderated t-test in `analyze()`.

* `dataMissing()`: Calculate the count of missing data.

* Revise `normalize()` to ensure compatibility with missing values (NAs) during
  the normalization process before proceeding with imputation.

* Revise `summarize()` to create a comprehensive descriptive summary.

* Rewrite `visualize()` and add some `graphType` related to PCA.

* Update and smooth the entire package.

* Build the website.


# msDiaLogue 0.0.1


* First release of the package.

