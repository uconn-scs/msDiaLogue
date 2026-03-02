# Changelog

## msDiaLogue 0.0.6

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15706003.svg)](https://doi.org/10.5281/zenodo.15706003)

- Analysis:
  - Separate all options into individual functions `analyze.*()`.
  - Add[`analyze.plsda()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md).
  - Rewrite
    [`analyze.pca()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.pca.md)
    and
    [`analyze.plsda()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md)
    to improve clarity.
- Visualization:
  - Separate all options into individual functions `visualize.*()`.
  - Add
    [`visualize.rank()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.rank.md).
  - Rename `visualize.ind()` to
    [`visualize.score()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.score.md)
    to ensure compatibility with PLS-DA and any other future analyses
    that include scores.
  - Rename `visualize.var()` to
    [`visualize.loading()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.loading.md)
    to ensure compatibility with PLS-DA and any other future analyses
    that include loadings.
  - Add
    [`visualize.vip()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.vip.md).
- Vignette:
  - Separate usage template into individual modules.
  - Add an FAQ section.
- Add NEWS.

## msDiaLogue 0.0.5

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15663360.svg)](https://doi.org/10.5281/zenodo.15663360)

- `preProcessFiltering()`: Intended for internal use only.

- [`preprocessing_scaffold()`](https://uconn-scs.github.io/msDiaLogue/reference/preprocessing_scaffold.md):

  - Make it compatible with the scaffold files containing GO
    information.
  - Add arguments `zeroNA` and `oneNA` to replace 0s and 1s with NAs.
  - Make it compatible with data without AlternateID.  
      

- [`transform()`](https://uconn-scs.github.io/msDiaLogue/reference/transform.md):
  Add root transformation.

- [`normalize()`](https://uconn-scs.github.io/msDiaLogue/reference/normalize.md):

  - Add argument `plot`.
  - Add scaling and centering.  
      

- `impute.*()`:

  - Add the “R.Condition” and “R.Replicate” columns to the shadow
    matrix.
  - Use NA to represent missing values in both the pre- and
    post-imputation data.  
      

- `analyze()`:

  - Make it capable of performing multiple comparisons and reconstruct
    the result structure.
  - Add Wilcoxon test (`method = "wilcox-test"`).
  - Add PCA (`method = "PCA"`; seperate PCA into analyze and visualize).
  - Add argument `adjust.method`.  
      

- `visualize()`:

  - MA: Change the labels for the x and y axes; remove the title; change
    ‘significant’ in the legend to ‘regulation’; make it compatible with
    the whole result list.
  - normalize: Remove the title.
  - test: Make it compatible with the whole result list.
  - Venn: Add the argument `saveVenn` to save the data in the Venn plot.
  - volcano: Make it compatible with the whole result list.
  - PCA_ind and PCA_biplot: Remove the ‘a’ marker from the scatter in
    the legend.  
      

- Other:

  - `dataMissing()`: Add arguments `sort_miss`, `show_pct_legend`, and
    `show_pct_col`.
  - [`pullProteinPath()`](https://uconn-scs.github.io/msDiaLogue/reference/pullProteinPath.md):
    Add arguments `listName`, `regexName`, and `by`.  
      

- vignette:

  - Change the note block border color to a paler red.
  - Add the instructions for addressing installation issues.
  - Add instructions for Bioconductor package installation.
  - Add cust_vis.
  - Update the example data.

## msDiaLogue 0.0.4

- For imputation, separate all options into individual functions, add
  [`impute.mice_cart()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_cart.md),
  [`impute.mice_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_norm.md),
  [`impute.pca_bayes()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_bayes.md)
  and
  [`impute.pca_prob()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_prob.md).

- Use autoglobal.

- [`preprocessing()`](https://uconn-scs.github.io/msDiaLogue/reference/preprocessing.md):
  add the hist for raw data; fix colnames.

- `filterOutIN()`: fix regex.

- `visualize()`: fix the point shape in the legend (ggrepel).

- `analyze()`: fix the factor level consistent with the input.

- Rewrite
  [`trimFASTA()`](https://uconn-scs.github.io/msDiaLogue/reference/trimFASTA.md).

- Drop R.FileName in all functions.

- Add
  [`preprocessing_scaffold()`](https://uconn-scs.github.io/msDiaLogue/reference/preprocessing_scaffold.md).

- Revise `filterProtein()` to make it compatible with Scaffold.

- Add note css.

## msDiaLogue 0.0.3

- For `impute()`, add options for `"knn"`, `"seq-knn"`, `"trunc-knn"`
  and `"nuc-norm"`.

- Add `filterProtein()`.

- For `visualize()`, add support for `"Upset"`.

## msDiaLogue 0.0.2

- Add moderated t-test in `analyze()`.

- `dataMissing()`: Calculate the count of missing data.

- Revise
  [`normalize()`](https://uconn-scs.github.io/msDiaLogue/reference/normalize.md)
  to ensure compatibility with missing values (NAs) during the
  normalization process before proceeding with imputation.

- Revise
  [`summarize()`](https://uconn-scs.github.io/msDiaLogue/reference/summarize.md)
  to create a comprehensive descriptive summary.

- Rewrite `visualize()` and add some `graphType` related to PCA.

- Update and smooth the entire package.

- Build the website.

## msDiaLogue 0.0.1

- First release of the package.
