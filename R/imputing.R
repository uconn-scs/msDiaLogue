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
  
  
  if (imputeType == "GlobeMinVal") {
  
    #Check each protein in turn
    
    #Check each condition in turn 
    
    #if any NA's are present, find the smallest value of the existing replicates 
    
    
    
    # calculate how many values are present from each condition by protein
    dtaCounts <- dataSet %>% 
      # do not include columns that are strings
      select(!c(R.FileName, R.Replicate)) %>%
        # group by experimental condition
        group_by(R.Condition) %>% 
          # apply to every numeric function a summation of the non-NA values
          summarise(across(where(is.numeric), ~sum(!is.na(.x))))
      
  
  }
  
  if (imputeType == "GlobeMinVal") {
    # filter out the proteins that have no recorded value
    imputedDataPoints[imputedDataPoints == ""] <- NA
    # find the global smallest value in the data set
    minimumValue <- min(imputedDataPoints, na.rm = TRUE)
    # replace all NAs with the smallest value
    imputedDataPoints <- replace(imputedDataPoints, is.na(imputedDataPoints), minimumValue)
    
  }
  
  #recombine the labels and transformed data into a single data frame
  imputedData <- cbind(dataLabels, imputedDataPoints)
  
  
  # return the filtered data
  return(imputedData)
  
}




