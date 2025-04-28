##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2025  Shiying Xiao, Timothy Moore and Charles Watt
## Shiying Xiao <shiying.xiao@uconn.edu>
##
## This file is part of the R package msDiaLogue.
##
## The R package msDiaLogue is free software: You can redistribute it and/or
## modify it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or any later
## version (at your option). See the GNU General Public License at
## <https://www.gnu.org/licenses/> for details.
##
## The R package msDiaLogue is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##

################################
#### Code for data analysis ####
################################
#'
#' Student's t-test
#'
#' @description
#' Perform Student's t-tests on the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param ref A string (default = NULL) specifying the reference condition for comparison.
#' If NULL, all pairwise comparisons are performed.
#' 
#' @param adjust.method A string (default = "none") specifying the correction method for
#' p-value adjustment: \itemize{
#' \item "BH" or its alias "fdr": \insertCite{benjamini1995controlling;textual}{msDiaLogue}.
#' \item "BY": \insertCite{benjamini2001control;textual}{msDiaLogue}.
#' \item "bonferroni": \insertCite{bonferroni1936teoria;textual}{msDiaLogue}.
#' \item "hochberg": \insertCite{hochberg1988sharper;textual}{msDiaLogue}.
#' \item "holm": \insertCite{holm1979simple;textual}{msDiaLogue}.
#' \item "hommel": \insertCite{hommel1988stagewise;textual}{msDiaLogue}.
#' \item "none": None
#' }
#' See \code{\link[stats]{p.adjust}} for more details.
#' 
#' @param paired A boolean (default = FALSE) specifying whether or not to perform a paired
#' test.
#' 
#' @param pool.sd A boolean (default = FALSE) specifying whether or not to use a pooled
#' standard deviation.
#' 
#' @return
#' A list comprising data frames for each comparison, with each data frame containing
#' the means of the two compared conditions for each protein, the difference in means,
#' and the p-values. Additionally, a separate data frame called "total" summarizes
#' the results of multiple comparisons.
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

analyze.t <- function(dataSet, ref = NULL, adjust.method = "none",
                           paired = FALSE, pool.sd = FALSE) {
  
  if (is.factor(dataSet$R.Condition)) {
    conds <- levels(dataSet$R.Condition)
  } else {
    conds <- unique(as.character(dataSet$R.Condition))
  }
  
  if (is.null(ref)) {
    ## if 'ref' is not provided, perform all pairwise comparisons
    ## create a pairwise vector
    comp <- combn(conds, 2)
    compA <- comp[1,]
    compB <- comp[2,]
  } else {
    ## check for reference condition
    if (!(ref %in% conds)) {
      stop("'ref' is not in the 'R.Condition'!")
    }
    compA <- conds[conds != ref]
    compB <- rep(ref, length(compA))
  }
  
  if (paired && pool.sd) {
    stop("Pooling of standard deviation is incompatible with paired tests!")
  }
  
  xs <- select(dataSet, -c(R.Condition, R.Replicate))
  g <- dataSet$R.Condition
  
  means <- apply(xs, 2, function(x) {
    tapply(x, g, mean, na.rm = TRUE)
  })
  
  pval <- lapply(1:length(compA), function(k) {
    
    ## index of the two conditions
    indexA <- which(g == compA[k])
    indexB <- which(g == compB[k])
    
    ## the p-value of t-test
    res <- apply(xs, 2, function(x) {
      tryCatch({
        t.test(x[indexA], x[indexB], paired = paired, var.equal = pool.sd)$p.value
      }, error = function(e) {
        ## if an error is thrown, return the fold change and set the p-value to 'NA'.
        message("Data are essentially constant.")
        return(NaN)
      })
    })
    
    return(res)
  })
  
  pval <- split(p.adjust(unlist(pval), method = adjust.method),
                rep(seq_along(pval), lengths(pval)))
  
  result <- lapply(1:length(compA), function(k) {
    res <- means[c(compA[k], compB[k]),]
    res <- as.data.frame(rbind(res, res[1,] - res[2,], pval[[k]]))
    rownames(res) <- c(paste(c(compA[k], compB[k]), "mean"), "difference", "p-value")
    return(res)
  })
  names(result) <- paste0(compA, "-", compB)
  
  total <- do.call(rbind, lapply(result, `[`, c("difference", "p-value"), , drop = FALSE))
  total <- rbind(means, total)
  rownames(total) <- c(paste(conds, "mean"), as.vector(t(outer(names(result), c(": difference", ": p-value"), paste0))))
  result$total <- total
  
  ## return to the analysis result
  return(result)
}


##----------------------------------------------------------------------------------------
#'
#' Empirical Bayes moderated t-test
#' 
#' @description
#' Perform empirical Bayes moderated t-tests \insertCite{smyth2004linear}{msDiaLogue}
#' on the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param ref A string (default = NULL) specifying the reference condition for comparison.
#' If NULL, all pairwise comparisons are performed.
#' 
#' @param adjust.method A string (default = "none") specifying the correction method for
#' p-value adjustment: \itemize{
#' \item "BH" or its alias "fdr": \insertCite{benjamini1995controlling;textual}{msDiaLogue}.
#' \item "BY": \insertCite{benjamini2001control;textual}{msDiaLogue}.
#' \item "bonferroni": \insertCite{bonferroni1936teoria;textual}{msDiaLogue}.
#' \item "hochberg": \insertCite{hochberg1988sharper;textual}{msDiaLogue}.
#' \item "holm": \insertCite{holm1979simple;textual}{msDiaLogue}.
#' \item "hommel": \insertCite{hommel1988stagewise;textual}{msDiaLogue}.
#' \item "none": None
#' }
#' See \code{\link[stats]{p.adjust}} for more details.
#' 
#' @import limma
#' 
#' @return
#' A list comprising data frames for each comparison, with each data frame containing
#' the means of the two compared conditions for each protein, the difference in means,
#' and the p-values. Additionally, a separate data frame called "total" summarizes
#' the results of multiple comparisons.
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

analyze.mod_t <- function(dataSet, ref = NULL, adjust.method = "none") {
  
  if (is.factor(dataSet$R.Condition)) {
    conds <- levels(dataSet$R.Condition)
  } else {
    conds <- unique(as.character(dataSet$R.Condition))
  }
  
  if (is.null(ref)) {
    ## if 'ref' is not provided, perform all pairwise comparisons
    ## create a pairwise vector
    comp <- combn(conds, 2)
    compA <- comp[1,]
    compB <- comp[2,]
  } else {
    ## check for reference condition
    if (!(ref %in% conds)) {
      stop("'ref' is not in the 'R.Condition'!")
    }
    compA <- conds[conds != ref]
    compB <- rep(ref, length(compA))
  }
  
  xs <- select(dataSet, -c(R.Condition, R.Replicate))
  g <- dataSet$R.Condition
  
  means <- apply(xs, 2, function(x) {
    tapply(x, g, mean, na.rm = TRUE)
  })
  
  ## construct the design matrix
  model.formula <- eval(parse(text = "~ 0 + R.Condition"), envir = dataSet)
  design <- model.matrix(model.formula)
  
  ## fit linear model for each protein
  fit1 <- limma::lmFit(t(xs), design)
  
  ## construct the contrast matrix
  contrast.matrix <- limma::makeContrasts(
    contrasts = paste0("R.Condition", compA, "-R.Condition", compB), levels = design)
  
  ## compute contrasts from linear model 'fit1'
  fit2 <- limma::contrasts.fit(fit1, contrast.matrix)
  
  ## empirical Bayes statistics
  fit3 <- limma::eBayes(fit2)
  
  pval <- lapply(1:length(compA), function(k) {
    return(fit3$p.value[,k])
  })
  
  pval <- split(p.adjust(unlist(pval), method = adjust.method),
                rep(seq_along(pval), lengths(pval)))
  
  result <- lapply(1:length(compA), function(k) {
    res <- means[c(compA[k], compB[k]),]
    res <- as.data.frame(rbind(res, res[1,] - res[2,], pval[[k]]))
    rownames(res) <- c(paste(c(compA[k], compB[k]), "mean"), "difference", "p-value")
    return(res)
  })
  names(result) <- paste0(compA, "-", compB)
  
  total <- do.call(rbind, lapply(result, `[`, c("difference", "p-value"), , drop = FALSE))
  total <- rbind(means, total)
  rownames(total) <- c(paste(conds, "mean"), as.vector(t(outer(names(result), c(": difference", ": p-value"), paste0))))
  result$total <- total
  
  ## return to the analysis result
  return(result)
}


##----------------------------------------------------------------------------------------
#'
#' Wilcoxon test
#' 
#' @description
#' Perform Wilcoxon tests on the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param ref A string (default = NULL) specifying the reference condition for comparison.
#' If NULL, all pairwise comparisons are performed.
#' 
#' @param adjust.method A string (default = "none") specifying the correction method for
#' p-value adjustment: \itemize{
#' \item "BH" or its alias "fdr": \insertCite{benjamini1995controlling;textual}{msDiaLogue}.
#' \item "BY": \insertCite{benjamini2001control;textual}{msDiaLogue}.
#' \item "bonferroni": \insertCite{bonferroni1936teoria;textual}{msDiaLogue}.
#' \item "hochberg": \insertCite{hochberg1988sharper;textual}{msDiaLogue}.
#' \item "holm": \insertCite{holm1979simple;textual}{msDiaLogue}.
#' \item "hommel": \insertCite{hommel1988stagewise;textual}{msDiaLogue}.
#' \item "none": None
#' }
#' See \code{\link[stats]{p.adjust}} for more details.
#' 
#' @param paired A boolean (default = FALSE) specifying whether or not to perform a paired
#' test.
#' 
#' @return
#' A list comprising data frames for each comparison, with each data frame containing
#' the means of the two compared conditions for each protein, the difference in means,
#' and the p-values. Additionally, a separate data frame called "total" summarizes
#' the results of multiple comparisons.
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

analyze.wilcox <- function(dataSet, ref = NULL, adjust.method = "none", paired = FALSE) {
  
  if (is.factor(dataSet$R.Condition)) {
    conds <- levels(dataSet$R.Condition)
  } else {
    conds <- unique(as.character(dataSet$R.Condition))
  }
  
  if (is.null(ref)) {
    ## if 'ref' is not provided, perform all pairwise comparisons
    ## create a pairwise vector
    comp <- combn(conds, 2)
    compA <- comp[1,]
    compB <- comp[2,]
  } else {
    ## check for reference condition
    if (!(ref %in% conds)) {
      stop("'ref' is not in the 'R.Condition'!")
    }
    compA <- conds[conds != ref]
    compB <- rep(ref, length(compA))
  }
  
  xs <- select(dataSet, -c(R.Condition, R.Replicate))
  g <- dataSet$R.Condition
  
  means <- apply(xs, 2, function(x) {
    tapply(x, g, mean, na.rm = TRUE)
  })
  
  pval <- lapply(1:length(compA), function(k) {
    
    ## index of the two conditions
    indexA <- which(g == compA[k])
    indexB <- which(g == compB[k])
    
    ## the p-value of t-test
    res <- apply(xs, 2, function(x) {
      wilcox.test(x[indexA], x[indexB], paired = paired)$p.value
    })
    
    return(res)
  })
  
  pval <- split(p.adjust(unlist(pval), method = adjust.method),
                rep(seq_along(pval), lengths(pval)))
  
  result <- lapply(1:length(compA), function(k) {
    res <- means[c(compA[k], compB[k]),]
    res <- as.data.frame(rbind(res, res[1,] - res[2,], pval[[k]]))
    rownames(res) <- c(paste(c(compA[k], compB[k]), "mean"), "difference", "p-value")
    return(res)
  })
  names(result) <- paste0(compA, "-", compB)
  
  total <- do.call(rbind, lapply(result, `[`, c("difference", "p-value"), , drop = FALSE))
  total <- rbind(means, total)
  rownames(total) <- c(paste(conds, "mean"), as.vector(t(outer(names(result), c(": difference", ": p-value"), paste0))))
  result$total <- total
  
  ## return to the analysis result
  return(result)
}


##----------------------------------------------------------------------------------------
#'
#' MA: fold change versus average abundance
#' 
#' @description
#' Compute the fold change (M) and average abundance (A) values from the data for MA plots.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param ref A string (default = NULL) specifying the reference condition for comparison.
#' If NULL, all pairwise comparisons are performed.
#' 
#' @return
#' A list comprising data frames for each comparison, with each data frame containing
#' the means of the two compared conditions for each protein, as well as the average and
#' difference in means.
#' 
#' @export

analyze.ma <- function(dataSet, ref = NULL) {
  
  if (is.factor(dataSet$R.Condition)) {
    conds <- levels(dataSet$R.Condition)
  } else {
    conds <- unique(as.character(dataSet$R.Condition))
  }
  
  if (is.null(ref)) {
    ## if 'ref' is not provided, perform all pairwise comparisons
    ## create a pairwise vector
    comp <- combn(conds, 2)
    compA <- comp[1,]
    compB <- comp[2,]
  } else {
    ## check for reference condition
    if (!(ref %in% conds)) {
      stop("'ref' is not in the 'R.Condition'!")
    }
    compA <- conds[conds != ref]
    compB <- rep(ref, length(compA))
  }
  
  xs <- select(dataSet, -c(R.Condition, R.Replicate))
  g <- dataSet$R.Condition
  
  means <- apply(xs, 2, function(x) {
    tapply(x, g, mean, na.rm = TRUE)
  })
  
  result <- lapply(1:length(compA), function(k) {
    res <- means[c(compA[k], compB[k]),]
    res <- as.data.frame(rbind(res, colMeans(res), res[1,] - res[2,]))
    rownames(res) <- c(paste(c(compA[k], compB[k]), "mean"), "A", "M")
    return(res)
  })
  names(result) <- paste0(compA, "-", compB)
  
  ## return to the analysis result
  return(result)
}


##----------------------------------------------------------------------------------------
#'
#' PCA: principal component analysis
#' 
#' @description
#' Perform a principal component analysis
#' \insertCite{pearson1901lines,hotelling1933analysis}{msDiaLogue} on the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param center A boolean (default = TRUE) indicating whether the variables should be
#' shifted to be zero centered.
#' 
#' @param scale A boolean (default = TRUE) indicating whether the variables should be
#' scaled to have unit variance before the analysis takes place.
#' 
#' @return
#' A list containing the following components: \describe{
#' \item{sdev}{The standard deviations of the principal components.}
#' \item{loadings}{The matrix of variable loadings.}
#' \item{scores}{The principal component scores.}
#' \item{center}{The centering used.}
#' \item{scale}{The scaling used.}
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

analyze.pca <- function(dataSet, center = TRUE, scale = TRUE) {
  
  plotData <- dataSet %>%
    mutate(R.ConRep = paste0(R.Condition, "_", R.Replicate)) %>%
    column_to_rownames(var = "R.ConRep") %>%
    select(-c(R.Condition, R.Replicate))
  
  result <- prcomp(plotData, center = center, scale = scale)
  result <- list(sdev = result$sdev, loadings = result$rotation, scores = result$x,
                 center = result$center, scale = result$scale)
  class(result) <- "pca"
  return(result)
}


##----------------------------------------------------------------------------------------
#'
#' PLS-DA: partial least squares discriminant analysis
#' 
#' @description
#' Perform a partial least squares discriminant analysis on the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param method A character string (default = "kernelpls") specifying the multivariate
#' regression method to be used: \itemize{
#' \item "kernelpls": Kernel algorithm \insertCite{dayal1997improved}{msDiaLogue}.
#' \item "widekernelpls": Wide kernel algorithm \insertCite{rannar1994pls}{msDiaLogue}.
#' \item "simpls": SIMPLS  algorithm \insertCite{dejong1993simpls}{msDiaLogue}.
#' \item "oscorespls": NIPALS algorithm (classical orthogonal scores algorithm) \insertCite{martens1989multivariate}{msDiaLogue}.
#' }
#' 
#' @param ncomp An integer specifying the number of components to include in the model.
#' Defaults to min(n-1, p).
#' 
#' @param center A boolean (default = TRUE) indicating whether the variables should be
#' shifted to be zero centered.
#' 
#' @param scale A boolean (default = FALSE) indicating whether the variables should be
#' scaled to have unit variance before the analysis takes place.
#' 
#' @return
#' A list containing the following components: \describe{
#' \item{coefficients}{An array of regression coefficients for \code{ncomp} components.
#' The dimensions are c(nvar, npred, \code{ncomp}), where nvar is the number of variables
#' X (proteins) and npred is the number of predicted variables Y (conditions).}
#' \item{scores}{A matrix of scores.}
#' \item{vips}{A matrix of variable importance in projection (VIP) scores.}
#' \item{loadings}{A matrix of loadings.}
#' \item{loading.weights}{A matrix of loading weights.}
#' \item{Xvar}{A vector with the amount of X-variance explained by each component.}
#' \item{Xtotvar}{Total variance in X.}
#' \item{ncomp}{The number of components.}
#' \item{method}{The method used to fit the model.}
#' \item{center}{Indicates whether centering was applied to the model.}
#' \item{scale}{The scaling used.}
#' \item{model}{The model frame.}
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

analyze.plsda <- function(dataSet, method = "kernelpls", ncomp,
                          center = TRUE, scale = FALSE) {
  model.formula <- eval(parse(text = "~ 0 + R.Condition"), envir = dataSet)
  y <- model.matrix(model.formula)
  colnames(y) <- gsub("^R.Condition", "", colnames(y))
  xs <- as.matrix(select(dataSet, -c(R.Condition, R.Replicate)))
  if (missing(ncomp)) {
    ncomp <- min(nrow(xs)-1, ncol(xs))
  }
  result <- pls::plsr(y ~ xs, method = method, ncomp = ncomp, center = center, scale = scale)
  if (is.null(result$scale)) {
    result$scale <- FALSE
  }
  SS <- c(result$Yloadings)[1:ncomp]^2 * colSums(result$scores^2)
  Wnorm2 <- colSums(result$loading.weights^2)
  SSW <- sweep(result$loading.weights^2, 2, SS/Wnorm2, "*")
  vips <- t(sqrt(nrow(SSW) * apply(SSW, 1, cumsum) / cumsum(SS)))
  
  class(result$scores) <- NULL
  class(result$loadings) <- NULL
  class(result$loading.weights) <- NULL
  class(result$model) <- NULL
  rownames(result$scores) <- paste0(dataSet$R.Condition, "_", dataSet$R.Replicate)
  result <- list(coefficients = result$coefficients, scores = result$scores, vips = vips,
                 loadings = result$loadings, loading.weights = result$loading.weights,
                 Xvar = result$Xvar, Xtotvar = result$Xtotvar,
                 ncomp = result$ncomp, method = result$method,
                 center = result$center, scale = result$scale, model = result$model)
  class(result) <- "plsda"
  return(result)
}

