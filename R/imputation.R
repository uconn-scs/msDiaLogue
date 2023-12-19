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
#' @param imputeType A string (default = "LocalMinVal") specifying which imputation
#' method to use:
#' \enumerate{
#' \item "LocalMinVal": replace missing values with the lowest value from the protein by
#' condition combination.
#' \item "GlobalMinVal": replaces missing values with the lowest value found within the
#' entire data set.
#' \item "knn": replace missing values using the k-nearest neighbors algorithm
#' (Troyanskaya et al., 2001).
#' \item "seq-knn": replace missing values using the sequential k-nearest neighbors
#' algorithm (Kim et al., 2004).
#' \item "trunc-knn": replace missing values using the truncated k-nearest neighbors
#' algorithm (Shah et al., 2017).
#' }
#' 
#' @param reqPercentPresent An numeric value (default = 0.51) specifying the required
#' percent of values that must be present in a given protein by condition combination for
#' values to be imputed when \code{imputeType = "LocalMinVal"}.
#' 
#' @param k An integer (default = 10) indicating the number of neighbors to be used in the
#' imputation when \code{imputeType} is \code{"knn"}, \code{"seq-knn"}, or
#' \code{"trunc-knn"}.
#' 
#' @param rowmax A numeric value (default = 0.5) specifying the maximum percent missing
#' data allowed in any row when \code{imputeType = "knn"}. For any rows with more than
#' \code{rowmax}*100% missing are imputed using the overall mean per sample.
#' 
#' @param colmax A numeric value (default = 0.8) specifying the maximum percent missing
#' data allowed in any column when \code{imputeType = "knn"}. If any column has more than
#' \code{colmax}*100% missing data, the program halts and reports an error.
#' 
#' @param maxp An integer (default = 1500) indicating the largest block of proteins
#' imputed using the k-nearest neighbors algorithm when \code{imputeType = "knn"}. Larger
#' blocks are divided by two-means clustering (recursively) prior to imputation.
#' 
#' @param rng.seed An integer (default = 362436069) specifying the seed used for the
#' random number generator for reproducibility when \code{imputeType = "knn"}.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels. Alters the return structure.
#' 
#' @importFrom impute impute.knn
#' @importFrom multiUS seqKNNimp
#' 
#' @returns
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @references \itemize{
#' \item Troyanskaya, O., Cantor, M., Sherlock, G., Brown, P., Hastie, T., Tibshirani, R.,
#' Botstein, D. and Altman, R. B. (2001).
#' Missing Value Estimation Methods for DNA Microarrays.
#' \emph{Bioinformatics}, 17(6), 520--525.
#' \item Kim, KY., Kim, BJ. and Yi, GS. (2004).
#' Reuse of Imputed Data in Microarray Analysis Increases Imputation Efficiency.
#' \emph{BMC Bioinformatics}, 5, 160.
#' \item Shah, J. S., Rai, S. N., DeFilippis, A. P., Hill, B. G., Bhatnagar, A. and
#' Brock, G. N. (2017).
#' Distribution Based Nearest Neighbor Imputation for Truncated High Dimensional Data with
#' Applications to Pre-Clinical and Clinical Metabolomics Studies.
#' \emph{BMC Bioinformatics}, 18, 114.
#' }
#' 
#' @export

impute <- function(dataSet,
                   imputeType = "LocalMinVal",
                   reqPercentPresent = 0.51,
                   k = 10, rowmax = 0.5, colmax = 0.8, maxp = 1500, rng.seed = 362436069,
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

