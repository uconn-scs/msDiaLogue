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

##################################
#### Code for data imputation ####
##################################
#' 
#' Imputation by the global minimum
#' 
#' @description
#' Apply imputation to the dataset by the minimum measured value from any protein found
#' within the entire dataset.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @export

impute.min_global <- function(dataSet, reportImputing = FALSE) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace all NAs with the global smallest value in the data set
  dataPoints <- replace(dataPoints, is.na(dataPoints), min(dataPoints, na.rm = TRUE))
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[,c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by the local minimum
#' 
#' @description
#' Apply imputation to the dataset by the minimum measured value for that protein in that
#' condition.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @export

impute.min_local <- function(dataSet, reportImputing = FALSE) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## number of proteins in the data set
  numProteins <- ncol(dataPoints)
  
  ## create a frequency table for conditions
  frq <- table(dataSet$R.Condition)
  
  ## list of conditions in the data set
  conditionsList <- names(frq)
  
  ## number of conditions in the data set
  numConditions <- length(conditionsList)
  
  ## number of replicates for each condition in the data set
  numReplicates <- as.vector(frq)
  
  ## loop over proteins
  for (j in 1:numProteins) {
    
    ## loop over conditions
    for (i in 1:numConditions) {
      
      ## condition for subsetting the data
      conditionIndex <- dataSet$R.Condition == conditionsList[i]
      
      ## select and isolate the data from each protein by condition combination
      localData <- dataPoints[conditionIndex, j]
      
      ## identify missing values
      missingValues <- is.na(localData)
      
      ## replace missing values with the minimum (non-NA) value of the protein by
      ## condition combination
      dataPoints[conditionIndex, j] <- replace(localData, missingValues,
                                               min(localData, na.rm = TRUE))
    }
  }
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[,c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by the k-nearest neighbors algorithm
#' 
#' @description
#' Apply imputation to the dataset by the k-nearest neighbors algorithm
#' \insertCite{troyanskaya2001missing}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param k An integer (default = 10) indicating the number of neighbors to be used in the
#' imputation.
#' 
#' @param rowmax A scalar (default = 0.5) specifying the maximum percent missing data
#' allowed in any row. For any rows with more than \code{rowmax}*100% missing are imputed
#' using the overall mean per sample.
#' 
#' @param colmax A scalar (default = 0.8) specifying the maximum percent missing data
#' allowed in any column. If any column has more than \code{colmax}*100% missing data, the
#' program halts and reports an error.
#' 
#' @param maxp An integer (default = 1500) indicating the largest block of proteins
#' imputed using the k-nearest neighbors algorithm. Larger blocks are divided by two-means
#' clustering (recursively) prior to imputation.
#' 
#' @param seed An integer (default = 362436069) specifying the seed used for the
#' random number generator for reproducibility.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom impute impute.knn
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.knn <- function(dataSet, reportImputing = FALSE,
                       k = 10, rowmax = 0.5, colmax = 0.8, maxp = 1500, seed = 362436069) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using knn algorithm
  dataPoints <- t(impute::impute.knn(t(dataPoints), k = k,
                                     rowmax = rowmax, colmax = colmax,
                                     maxp = maxp, rng.seed = seed)$data)
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[,c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by the k-nearest neighbors algorithm
#' 
#' @description
#' Apply imputation to the dataset by the sequential k-nearest neighbors algorithm
#' \insertCite{kim2004reuse}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param k An integer (default = 10) indicating the number of neighbors to be used in the
#' imputation.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom multiUS seqKNNimp
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.knn_seq <- function(dataSet, reportImputing = FALSE,
                           k = 10) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using sequential knn algorithm
  dataPoints <- t(multiUS::seqKNNimp(t(dataPoints), k = k))
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by the truncated k-nearest neighbors algorithm
#' 
#' @description
#' Apply imputation to the dataset by the truncated k-nearest neighbors algorithm
#' \insertCite{shah2017distribution}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param k An integer (default = 10) indicating the number of neighbors to be used in the
#' imputation.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.knn_trunc <- function(dataSet, reportImputing = FALSE,
                             k = 10) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using truncated knn algorithm
  ## source: trunc-knn.R
  dataPoints <- imputeKNN(data = as.matrix(dataPoints), k = k,
                          distance = "truncation", perc = 0)
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by the nuclear-norm regularization
#' 
#' @description
#' Apply imputation to the dataset by the nuclear-norm regularization
#' \insertCite{hastie2015matrix}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param rank.max An integer specifying the restriction on the rank of the solution. The
#' default is set to one less than the minimum dimension of the dataset.
#' 
#' @param lambda A scalar specifying the nuclear-norm regularization parameter. If
#' \code{lambda = 0}, the algorithm convergence is typically slower. The default is set to
#' the maximum singular value obtained from the singular value decomposition (SVD) of the
#' dataset.
#' 
#' @param thresh A scalar (default = 1e-5) specifying the convergence threshold, measured
#' as the relative change in the Frobenius norm between two successive estimates.
#' 
#' @param maxit An integer (default = 100) specifying the maximum number of iterations
#' before the convergence is reached.
#' 
#' @param final.svd A boolean (default = TRUE) specifying whether to perform a one-step
#' unregularized iteration at the final iteration, followed by soft-thresholding of the
#' singular values, resulting in hard zeros.
#' 
#' @param seed An integer (default = 362436069) specifying the seed used for the
#' random number generator for reproducibility.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom softImpute complete softImpute
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.nuc_norm <- function(dataSet, reportImputing = FALSE,
                            rank.max = NULL, lambda = NULL, thresh = 1e-05, maxit = 100,
                            final.svd = TRUE, seed = 362436069) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using nuclear-norm regularization
  if(is.null(rank.max)) {
    rank.max <- min(dim(dataPoints) - 1)
  }
  
  if(is.null(lambda)) {
    lambda <- svd(replace(dataPoints, is.na(dataPoints), 0))$d[1]
  }
  
  set.seed(seed)
  
  fit <- softImpute::softImpute(t(dataPoints), type = "als",
                                rank.max = rank.max, lambda = lambda, thresh = thresh,
                                maxit = maxit, final.svd = final.svd)
  
  dataPoints <- t(softImpute::complete(t(dataPoints), fit))
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by Bayesian linear regression
#' 
#' @description
#' Apply imputation to the dataset by Bayesian linear regression
#' \insertCite{rubin1987multiple,schafer1997analysis,van2011mice}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param m An integer (default = 5) specifying the number of multiple imputations.
#' 
#' @param seed An integer (default = 362436069) specifying the seed used for the random
#' number generator for reproducibility.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom mice complete mice
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.mice_norm <- function(dataSet, reportImputing = FALSE,
                             m = 5, seed = 362436069) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using Bayesian linear regression
  dataPoints <- mice(dataPoints, m = m, seed = seed, method = "norm", printFlag = FALSE)
  dataPoints <- Reduce(`+`, mice::complete(dataPoints, "all")) / m
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by classification and regression trees
#' 
#' @description
#' Apply imputation to the dataset by classification and regression trees
#' \insertCite{breiman1984classification,doove2014recursive,van2018flexible}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param m An integer (default = 5) specifying the number of multiple imputations.
#' 
#' @param seed An integer (default = 362436069) specifying the seed used for the random
#' number generator for reproducibility.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom mice complete mice
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.mice_cart <- function(dataSet, reportImputing = FALSE,
                             m = 5, seed = 362436069) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using classification and regression trees
  dataPoints <- mice(dataPoints, m = m, seed = seed, method = "cart", printFlag = FALSE)
  dataPoints <- Reduce(`+`, mice::complete(dataPoints, "all")) / m
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by Bayesian principal components analysis
#' 
#' @description
#' Apply imputation to the dataset by Bayesian principal components analysis
#' \insertCite{oba2003bayesian}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param nPcs An integer specifying the number of principal components to calculate. The
#' default is set to the minimum between the number of samples and the number of proteins.
#' 
#' @param maxSteps An integer (default = 100) specifying the maximum number of estimation
#' steps.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom pcaMethods completeObs pca
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.pca_bayes <- function(dataSet, reportImputing = FALSE,
                             nPcs = NULL, maxSteps = 100) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using Bayesian principal components analysis
  dataPoints <- pcaMethods::pca(dataPoints, method = "bpca", verbose = FALSE,
                                nPcs = ifelse(is.null(nPcs), min(dim(dataPoints)), nPcs),
                                maxSteps = maxSteps)
  dataPoints <- pcaMethods::completeObs(dataPoints)
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}


##----------------------------------------------------------------------------------------
#'
#' Imputation by probabilistic principal components analysis
#' 
#' @description
#' Apply imputation to the dataset by probabilistic principal components analysis
#' \insertCite{stacklies2007pcamethods}{msDiaLogue}.
#' 
#' @param dataSet The 2d dataset of experimental values.
#' 
#' @param nPcs An integer specifying the number of principal components to calculate. The
#' default is set to the minimum between the number of samples and the number of proteins.
#' 
#' @param maxIterations An integer (default = 1000) specifying the maximum number of
#' allowed iterations.
#' 
#' @param seed An integer (default = 362436069) specifying the seed used for the random
#' number generator for reproducibility.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom pcaMethods completeObs pca
#' 
#' @return
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export

impute.pca_prob <- function(dataSet, reportImputing = FALSE,
                            nPcs = NULL, maxIterations = 1000, seed = 362436069) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c(R.Condition, R.Replicate))
  
  ## replace NAs using Bayesian principal components analysis
  dataPoints <- pcaMethods::pca(dataPoints, method = "ppca", verbose = FALSE,
                                nPcs = ifelse(is.null(nPcs), min(dim(dataPoints)), nPcs),
                                maxIterations = maxIterations, seed = seed)
  dataPoints <- pcaMethods::completeObs(dataPoints)
  
  ## recombine the labels and imputed data
  imputedData <- cbind(dataSet[, c("R.Condition", "R.Replicate")], dataPoints)
  
  if (reportImputing) {
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    shadowMatrix[is.na(shadowMatrix) & !is.na(dataPoints)] <- 1
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = cbind(dataSet[,c("R.Condition", "R.Replicate")], shadowMatrix)))
  } else {
    return(imputedData)
  }
}

