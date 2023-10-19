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
  
  if (imputeType == "LocalMinVal") {
    
    conditionsList <- unique(dataSet$R.Condition)
    
    ## create a shadow matrix for counting missing
    shadowMatrix <- dataSet
    
    ## empty the shadow matrix of data while retaining its structure
    shadowMatrix[,4:length(shadowMatrix[1,])] <- 0
    
    ## count how many conditions are present for the data set
    numbConditions <- as.integer(length(conditionsList))
    
    ## count how many proteins are present
    numbProteins <- as.integer(length(dataSet[1,]) - 3)
    
    ## count how many replicates are present for each condition in the data set
    numbReplicates <- c()
    
    for (j in 1:numbConditions) {
      numbReplicates[j] <- as.integer(
        dim(dataSet[dataSet$R.Condition == toString(conditionsList[j]),])[1])
    }
    
    ## for each protein in order
    for (i in 1:numbProteins) {
      
      ## for each condition in order
      for (j in 1:numbConditions) {
        
        ## select and isolate the data from each protein by condition combination
        tempData <- dataSet[dataSet$R.Condition == toString(conditionsList[j]), i + 3]
        
        ## calculate the percentage of samples that are present in that protein by
        ## condition combination
        percentPresent <- sum(!is.na(tempData))/numbReplicates[j] * 100
        
        # if the imputation threshold is met
        if (percentPresent >= reqPercentPresent) {
          
          ## go through each replicate
          for (k in 1:as.integer(length(tempData))) {
            
            ## if the value is NA
            if (is.na(tempData[k])) {
              
              ## replace the value with the minimum (non-NA) value of the protein by
              ## condition combination
              tempData[k] <- min(tempData, na.rm = TRUE)
              
              ## record that a value was imputed in the shadow matrix
              shadowMatrix[j, i + 3] <- 1
            }
          }
        }
        
        ## save that protein by condition combination back to the data set
        dataSet[dataSet$R.Condition == toString(conditionsList[j]), i + 3] <- tempData
      }
    }
    
    ## save the imputed data under its new name
    imputedData <- dataSet
    
  } else if (imputeType == "GlobalMinVal") {
    
    ## separate the data set into labels and numerical data
    ## labels consist of the first 3 columns, data is everything else
    dataLabels <- dataSet[,1:3]
    imputedDataPoints <- dataSet[,4:length(dataSet[1,])]
    
    ## filter out the proteins that have no recorded value
    imputedDataPoints[imputedDataPoints == ""] <- NA
    
    ## create a shadow matrix to record imputations
    shadowMatrix <- dataSet
    
    ## set all blanks equal to NA
    shadowMatrix[shadowMatrix == ""] <- NA
    
    ## make all values equal to 0, since they will not be imputed
    shadowMatrix[!is.na(shadowMatrix)] <- 0
    
    ## make all NAs equal to 1, since they will all be imputed in GlobalMinVal
    shadowMatrix[is.na(shadowMatrix)] <- 1
    
    ## find the global smallest value in the data set
    minimumValue <- min(imputedDataPoints, na.rm = TRUE)
    
    ## replace all NAs with the smallest value
    imputedDataPoints <- replace(imputedDataPoints, is.na(imputedDataPoints), minimumValue)
    
    ## recombine the labels and transformed data into a single data frame
    imputedData <- cbind(dataLabels, imputedDataPoints)
  }
  
  if (reportImputing) {
    
    ## return the filtered data
    return(list(data.frame(imputedData), data.frame(shadowMatrix)))
    
  } else {
    return(data.frame(imputedData))
  }
}

