##################################
#### Code for data imputation ####
##################################
#' 
#' Imputation of raw data signals
#' 
#' @description
#' Apply an imputation method to the data set.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @param imputeType A character string (default = "LocalMinVal") specifying which
#' imputation method to use:
#' \enumerate{
#' \item "LocalMinVal": replace missing values with the lowest value from the protein by
#' condition combination.
#' \item "GlobalMinVal": replace missing values with the lowest value found within the
#' entire data set.
#' \item "knn": replace missing values using the k-nearest neighbors algorithm
#' \insertCite{troyanskaya2001missing}{msDiaLogue}.
#' \item "seq-knn": replace missing values using the sequential k-nearest neighbors
#' algorithm \insertCite{kim2004reuse}{msDiaLogue}.
#' \item "trunc-knn": replace missing values using the truncated k-nearest neighbors
#' algorithm \insertCite{shah2017distribution}{msDiaLogue}.
#' \item "nuc-norm": replace missing values using the nuclear-norm regularization
#' \insertCite{hastie2015matrix}{msDiaLogue}.
#' }
#' 
#' @param reqPercentPresent A scalar (default = 0.51) specifying the required percent of
#' values that must be present in a given protein by condition combination for
#' values to be imputed for \code{imputeType = "LocalMinVal"}.
#' 
#' @param k An integer (default = 10) indicating the number of neighbors to be used in the
#' imputation when \code{imputeType} is \code{"knn"}, \code{"seq-knn"}, or
#' \code{"trunc-knn"}.
#' 
#' @param rowmax A scalar (default = 0.5) specifying the maximum percent missing data
#' allowed in any row when \code{imputeType = "knn"}. For any rows with more than
#' \code{rowmax}*100% missing are imputed using the overall mean per sample.
#' 
#' @param colmax A scalar (default = 0.8) specifying the maximum percent missing data
#' allowed in any column when \code{imputeType = "knn"}. If any column has more than
#' \code{colmax}*100% missing data, the program halts and reports an error.
#' 
#' @param maxp An integer (default = 1500) indicating the largest block of proteins
#' imputed using the k-nearest neighbors algorithm when \code{imputeType = "knn"}. Larger
#' blocks are divided by two-means clustering (recursively) prior to imputation.
#' 
#' @param rng.seed An integer (default = 362436069) specifying the seed used for the
#' random number generator for reproducibility when \code{imputeType = "knn"}.
#' 
#' @param rank.max An integer specifying the restriction on the rank of the solution for
#' \code{imputeType = "nuc-norm"}. The default is set to one less than the minimum
#' dimension of the dataset.
#' 
#' @param lambda A scalar specifying the nuclear-norm regularization parameter for
#' \code{imputeType = "nuc-norm"}. If \code{lambda = 0}, the algorithm convergence is
#' typically slower. The default is set to the maximum singular value obtained from the
#' singular value decomposition (SVD) of the dataset.
#' 
#' @param thresh A scalar (default = 1e-5) specifying the convergence threshold for
#' \code{imputeType = "nuc-norm"}, measured as the relative change in the Frobenius norm
#' between two successive estimates.
#' 
#' @param maxit An integer (default = 100) specifying the maximum number of iterations
#' before the convergence is reached for \code{imputeType = "nuc-norm"}.
#' 
#' @param final.svd A boolean (default = TRUE) specifying whether to perform a one-step
#' unregularized iteration at the final iteration, followed by soft-thresholding of the
#' singular values, resulting in hard zeros.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels, where 1 indicates the corresponding entries
#' have been imputed, and 0 indicates otherwise. Alters the return structure.
#' 
#' @importFrom impute impute.knn
#' @importFrom multiUS seqKNNimp
#' @importFrom softImpute complete softImpute
#' @importFrom Rdpack reprompt
#' 
#' @returns
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

impute <- function(dataSet,
                   imputeType = "LocalMinVal",
                   reqPercentPresent = 0.51,
                   k = 10, rowmax = 0.5, colmax = 0.8, maxp = 1500, rng.seed = 362436069,
                   rank.max = NULL, lambda = NULL, thresh = 1e-05, maxit = 100, final.svd = TRUE,
                   reportImputing = FALSE) {
  
  ## select the numerical data
  dataPoints <- shadowMatrix <- select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate"))
  
  if (imputeType == "LocalMinVal") {
    
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
        
        ## calculate the percent of samples that are present in that protein by
        ## condition combination
        percentPresent <- sum(!is.na(localData)) / numReplicates[i]
        
        ## impute missing values if the threshold is met
        if (percentPresent >= reqPercentPresent) {
          
          ## identify missing values
          missingValues <- is.na(localData)
          
          ## replace missing values with the minimum (non-NA) value of the protein by
          ## condition combination
          dataPoints[conditionIndex, j] <- replace(localData, missingValues,
                                                   min(localData, na.rm = TRUE))
        }
      }
    }
    
  } else if (imputeType == "GlobalMinVal") {
    ## replace all NAs with the global smallest value in the data set
    
    dataPoints <- replace(dataPoints, is.na(dataPoints), min(dataPoints, na.rm = TRUE))
    
  } else if (imputeType == "knn") {
    ## replace NAs using knn algorithm
    
    dataPoints <- t(impute::impute.knn(t(dataPoints), k = k,
                                       rowmax = rowmax, colmax = colmax,
                                       maxp = maxp, rng.seed = rng.seed)$data)
    
  } else if (imputeType == "seq-knn") {
    ## replace NAs using sequential knn algorithm
    
    dataPoints <- t(multiUS::seqKNNimp(t(dataPoints), k = k))
    
  } else if (imputeType == "trunc-knn") {
    ## replace NAs using truncated knn algorithm
    ## source: trunc-knn.R
    
    dataPoints <- imputeKNN(data = as.matrix(dataPoints), k = k,
                            distance = "truncation", perc = 0)
    
  } else if (imputeType == "nuc-norm") {
    ## replace NAs using nuclear-norm regularization
    
    if(is.null(rank.max)) {
      rank.max <- min(dim(dataPoints) - 1)
    }
    
    if(is.null(lambda)) {
      lambda <- svd(replace(dataPoints, is.na(dataPoints), 0))$d[1]
    }
    
    fit <- softImpute::softImpute(t(dataPoints), type = "als",
                                  rank.max = rank.max, lambda = lambda, thresh = thresh,
                                  maxit = maxit, final.svd = final.svd)
    
    dataPoints <- t(softImpute::complete(t(dataPoints), fit))
  }
  
  ## recombine the labels and imputed data
  imputedData <- cbind(select(dataSet, c("R.Condition", "R.FileName", "R.Replicate")),
                       dataPoints)
  
  if (reportImputing) {
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData,
                shadowMatrix = ifelse(is.na(shadowMatrix) & !is.na(dataPoints), 1, 0)))
  } else {
    return(imputedData)
  }
}

