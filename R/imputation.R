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
#' }
#' 
#' @param reqPercentPresent An integer (default = 51) specifying the required percentage
#' of values that must be present in a given protein by condition combination for values
#' to be imputed.
#' 
#' @param reportImputing A boolean (default = FALSE) specifying whether to provide a
#' shadow data frame with imputed data labels. Alters the return structure.
#' 
#' @returns
#' \itemize{
#' \item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
#' \item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
#' dataframe and a shadow matrix showing which proteins by replicate were imputed.
#' }
#' 
#' @export

impute <- function(dataSet,
                   imputeType = "LocalMinVal",
                   reqPercentPresent = 51,
                   reportImputing = FALSE) {
  
  ## select the numerical data
  dataPoints <- select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate"))
  
  if (imputeType == "LocalMinVal") {
    
    ## create a shadow matrix to log the imputed locations
    shadowMatrix <- array(0, dim = dim(dataPoints),
                          dimnames = list(NULL, colnames(dataPoints)))
    
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
        
        ## calculate the percentage of samples that are present in that protein by
        ## condition combination
        percentPresent <- sum(!is.na(localData)) / numReplicates[i] * 100
        
        ## impute missing values if the threshold is met
        if (percentPresent >= reqPercentPresent) {
          
          ## identify missing values
          missingValues <- is.na(localData)
          
          ## record that a value was imputed in the shadow matrix
          shadowMatrix[conditionIndex, j][missingValues] <- 1
          
          ## replace missing values with the minimum (non-NA) value of the protein by
          ## condition combination
          dataPoints[conditionIndex, j] <- replace(localData, missingValues,
                                                   min(localData, na.rm = TRUE))
        }
      }
    }
    
  } else if (imputeType == "GlobalMinVal") {
    
    ## create a shadow matrix to log the imputed locations
    shadowMatrix <- ifelse(is.na(dataPoints), 1, 0)
    
    ## replace all NAs with the global smallest value in the data set
    dataPoints <- replace(dataPoints, is.na(dataPoints), min(dataPoints, na.rm = TRUE))
    
  }
  
  ## recombine the labels and imputed data
  imputedData <- cbind(select(dataSet, c("R.Condition", "R.FileName", "R.Replicate")),
                       dataPoints)
  
  if (reportImputing) {
    ## return the imputed data and the shadow matrix
    return(list(imputedData = imputedData, shadowMatrix = shadowMatrix))
  } else {
    return(imputedData)
  }
}

