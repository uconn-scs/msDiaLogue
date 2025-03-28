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
#' Analyzing summarized data
#' 
#' @description
#' Apply a statistical test to the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param method A string (default = "t-test") specifying which statistical analysis to
#' use:
#' \enumerate{
#' \item "t-test": Student's t-test.
#' \item "mod.t-test": Empirical Bayes moderated t-test
#' \insertCite{smyth2004linear}{msDiaLogue}.
#' \item "wilcox-test": Wilcoxon test.
#' \item "MA": Output to plot an MA plot.
#' \item "PCA": Principal components analysis
#' \insertCite{pearson1901lines,hotelling1933analysis}{msDiaLogue}.
#' }
#' 
#' @param ref A string (default = NULL) specifying the reference condition for comparison.
#' If NULL, all pairwise comparisons are performed.
#' 
#' @param adjust.method A string (default = "none") specifying the correction method for
#' p-value adjustment when \code{method = "*-test"}: \itemize{
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
#' test when \code{method = "t-test"} or \code{method = "wilcox-test"}.
#' 
#' @param pool.sd A boolean (default = FALSE) specifying whether or not to use a pooled
#' standard deviation when \code{method = "t-test"}.
#' 
#' @param center A boolean (default = TRUE) indicating whether the variables should be
#' shifted to be zero centered when \code{method = "PCA"}.
#' 
#' @param scale A boolean (default = TRUE) indicating whether the variables should be
#' scaled to have unit variance before the analysis takes place when \code{method = "PCA"}.
#' 
#' @import limma
#' @importFrom stats model.matrix t.test
#' @importFrom Rdpack reprompt
#' 
#' @returns \itemize{
#' \item "t-test", "mod.t-test", "wilcox-test": A list comprising data frames for each
#' comparison, with each data frame containing the means of the two compared conditions
#' for each protein, the difference in means, and the p-values. Additionally, a separate
#' data frame called "total" summarizes the results of multiple comparisons.
#' \item "MA": A list comprising data frames for each comparison, with each data frame
#' containing the means of the two compared conditions for each protein, as well as the
#' average and difference in means.
#' \item "PCA": A list containing the standard deviations of the principal components
#' `sdev`, the matrix of variable loadings `rotation`, the centering used `center`,
#' the scaling used `scale`, and the principal component scores `x`.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @autoglobal
#' 
#' @export

analyze <- function(dataSet, method = "t-test", ref = NULL, adjust.method = "none",
                    paired = FALSE, pool.sd = FALSE,
                    center = TRUE, scale = TRUE) {
  
  conds <- levels(dataSet$R.Condition)
  
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
  
  if (grepl("test$", method)) {
    
    if (method == "t-test") {
      
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
      
    } else if (method == "mod.t-test") {
      
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
      
    } else if (method == "wilcox-test") {
      
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
    }
    
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
    
  } else if (method == "MA") {
    
    result <- lapply(1:length(compA), function(k) {
      res <- means[c(compA[k], compB[k]),]
      res <- as.data.frame(rbind(res, colMeans(res), res[1,] - res[2,]))
      rownames(res) <- c(paste(c(compA[k], compB[k]), "mean"), "A", "M")
      return(res)
    })
    
    names(result) <- paste0(compA, "-", compB)
    
  } else if (method == "PCA") {
    
    plotData <- dataSet %>%
      mutate(R.ConRep = paste0(R.Condition, "_", R.Replicate)) %>%
      remove_rownames() %>%
      column_to_rownames(var = "R.ConRep") %>%
      select(-c(R.Condition, R.Replicate))
    
    result <- prcomp(plotData, center = center, scale = scale)
    result$habillage <- dataSet$R.Condition
    
  }
  
  ## return to the analysis result
  return(result)
}

