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
#' 
#' @details 
#' "MinVal" replaces missing values with the lowest global value
#' . 
#'      
#' @returns The function returns an imputed 2d dataframe. 
#' 
#################################################



impute <- function(dataSet, imputeType = "MinVal"){
  
  # separate the data set into labels and numerical data
  #labels consist of first 3 columns, data is everything else
  dataLabels <- dataSet[,1:3]
  imputedDataPoints <- dataSet[,4:length(dataSet[1,])]
  
  
  if (imputeType == "MinVal") {
    # filter out the proteins that have no recorded value
    
    #imputedData <- replace(imputedData, is.nan(imputedData), NA)
    #imputedData <- replace(imputedData, is.null(imputedData), NA)
    imputedDataPoints[imputedDataPoints == ""] <- NA
    
    minimumValue <- min(imputedDataPoints, na.rm = TRUE)
    
    imputedDataPoints <- replace(imputedDataPoints, is.na(imputedDataPoints), minimumValue)
    
  }
  
  #recombine the labels and transformed data into a single data frame
  imputedData <- cbind(dataLabels, imputedDataPoints)
  
  
  # return the filtered data
  return(imputedData)
  
}




