# Code for data imputation

require(dplyr)
require(tidyr)

#################################################
#' Imputation of raw data signals
#' 
#' @description 
#' impute() applies an imputation method to the data set.
#' 
#' @param dataSet The 2d data set of experimental values 
#' 
#' @param imputeType A Boolean (default = "MinVal") specifying what imputation 
#' method to use.
#' . 
#'      
#' @returns The function returns an imputed 2d dataframe. 
#' 
#################################################



impute <- function(dataSet, imputeType = "MinVal"){
  
  imputedData <- dataSet
  
  if (imputeType == "MinVal") {
    # filter out the proteins that have no recorded value
    
    #imputedData <- replace(imputedData, is.nan(imputedData), NA)
    #imputedData <- replace(imputedData, is.null(imputedData), NA)
    imputedData[imputedData == ""] <- NA
    
    minimumValue <- min(imputedData, na.rm = TRUE)
    
    imputedData <- replace(imputedData, is.na(imputedData), minimumValue)
    
  }
  
  
  # return the filtered data
  return(imputedData)
  
}




