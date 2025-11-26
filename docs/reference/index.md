# Package index

## Preprocessing

- [`preprocessing()`](https://uconn-scs.github.io/msDiaLogue/reference/preprocessing.md)
  : Loading, filtering and reformatting of MS DIA data from Spectronaut
- [`preprocessing_scaffold()`](https://uconn-scs.github.io/msDiaLogue/reference/preprocessing_scaffold.md)
  : Loading and reformatting of MS data from Scaffold

## Transformation

- [`transform()`](https://uconn-scs.github.io/msDiaLogue/reference/transform.md)
  : Transformation

## Filtering

- [`filterNA()`](https://uconn-scs.github.io/msDiaLogue/reference/filterNA.md)
  : Filtering NA's post-imputation
- [`filterOutIn()`](https://uconn-scs.github.io/msDiaLogue/reference/filterOutIn.md)
  : Filtering proteins or contaminants

## Normalization

- [`normalize()`](https://uconn-scs.github.io/msDiaLogue/reference/normalize.md)
  : Normalization of preprocessed data

## Imputation

- [`impute.knn()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn.md)
  : Imputation by the k-nearest neighbors algorithm
- [`impute.knn_seq()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_seq.md)
  : Imputation by the k-nearest neighbors algorithm
- [`impute.knn_trunc()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_trunc.md)
  : Imputation by the truncated k-nearest neighbors algorithm
- [`impute.mice_cart()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_cart.md)
  : Imputation by classification and regression trees
- [`impute.mice_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_norm.md)
  : Imputation by Bayesian linear regression
- [`impute.min_global()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_global.md)
  : Imputation by the global minimum
- [`impute.min_local()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_local.md)
  : Imputation by the local minimum
- [`impute.nuc_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.nuc_norm.md)
  : Imputation by the nuclear-norm regularization
- [`impute.pca_bayes()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_bayes.md)
  : Imputation by Bayesian principal components analysis
- [`impute.pca_prob()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_prob.md)
  : Imputation by probabilistic principal components analysis

## Summarization

- [`summarize()`](https://uconn-scs.github.io/msDiaLogue/reference/summarize.md)
  : Summarize protein intensities across conditions

## Analysis

- [`analyze.ma()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.ma.md)
  : MA: fold change versus average abundance
- [`analyze.mod_t()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.mod_t.md)
  : Empirical Bayes moderated t-test
- [`analyze.pca()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.pca.md)
  : PCA: principal component analysis
- [`analyze.plsda()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.plsda.md)
  : PLS-DA: partial least squares discriminant analysis
- [`analyze.t()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.t.md)
  : Student's t-test
- [`analyze.wilcox()`](https://uconn-scs.github.io/msDiaLogue/reference/analyze.wilcox.md)
  : Wilcoxon test

## Visualization

- [`visualize.biplot()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.biplot.md)
  : Biplot of score (individuals) and loading (variables)
- [`visualize.boxplot()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.boxplot.md)
  : Boxplot
- [`visualize.heatmap()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.heatmap.md)
  : Heatmap
- [`visualize.loading()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.loading.md)
  : Loading plot / graph of variables
- [`visualize.ma()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.ma.md)
  : MA plot: plots fold change versus average abundance
- [`visualize.rank()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.rank.md)
  : Rank abundance distribution plot (Whittaker plot)
- [`visualize.score()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.score.md)
  : Score plot / graph of individuals
- [`visualize.scree()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.scree.md)
  : Scree plot
- [`visualize.test()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.test.md)
  : Histograms of fold changes and p-values from test results
- [`visualize.upset()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.upset.md)
  : UpSet plot
- [`visualize.venn()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.venn.md)
  : Venn diagram
- [`visualize.vip()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.vip.md)
  : VIP scores plot
- [`visualize.volcano()`](https://uconn-scs.github.io/msDiaLogue/reference/visualize.volcano.md)
  : Volcano plot

## Other useful

- [`dataMissing()`](https://uconn-scs.github.io/msDiaLogue/reference/dataMissing.md)
  : Counting missing data
- [`pullProteinPath()`](https://uconn-scs.github.io/msDiaLogue/reference/pullProteinPath.md)
  : Compiling data on a single protein from each step in the process
- [`trimFASTA()`](https://uconn-scs.github.io/msDiaLogue/reference/trimFASTA.md)
  : Trimming down a protein FASTA file to certain proteins
