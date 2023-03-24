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
#' @param imputeType A Boolean (default = "LocalMinVal") specifying what imputation 
#' method to use.
#' 
#' @param reqPercentPresent An int (default = 51) specifying the require percent of values 
#' that must be present in a given protein by condition combination for values to be imputed.
#' 
#' @details 
#' "LocalMinVal" replaces missing values with the lowest value from the protein by condition combination.
#' "GlobalMinVal" replaces missing values with the lowest overall value in the data set.
#'      
#' @returns The function returns an imputed 2d dataframe. 
#' 
#################################################



impute <- function(dataSet, imputeType = "LocalMinVal", reqPercentPresent = 51){
  
  if (imputeType == "LocalMinVal") {
  
    #Count how many replicates are present for each condition 
    numbReplicates <- as.integer(length(unique(dataSet$R.Replicate)))
    
    #count how many proteins are present 
    numbProteins <- as.integer(length(dataSet[1,]) - 3)
    
    #count how many conditions are being tested in the data set
    numbConditions <- as.integer(length(dataSet[,1]) / numbReplicates)
    
    
    #for each protein in order
    for (i in 1:numbProteins) {
      
      #for each condition in order
      for (j in 1:numbConditions){
        
        #Define the range of the data set by protein and condition
        tempRange <- as.integer((j-1)*numbReplicates + 1):as.integer(j*numbReplicates)
        
        #select and isolate the data from each protein by condition combination
        tempData <- dataSet[tempRange, i + 3]
        
        #calculate the percent of samples that are present in that protein by condition combination
        percentPresent <- sum(!is.na(tempData))/numbReplicates * 100
        
        
        # if the imputation threshold is met
        if (percentPresent >= reqPercentPresent) {
          
          #go through each replicate 
          for (k in 1:as.integer(length(tempData))){
            
            #if the value is na, then
            if (is.na(tempData[k])){
              
              #replace the value with the minimum (non-NA) value of the protein by condition combination
              tempData[k] <- min(tempData, na.rm = TRUE)
              
            }
          }
        }
        
        #save that protein by condition combination back to the 
        dataSet[tempRange, i + 3] <- tempData
        
      }
    }
    
  # save the imputed data under it's new name
  imputedData <- dataSet  
    
  }
  
  
  if (imputeType == "GlobeMinVal") {
    
    # separate the data set into labels and numerical data
    #labels consist of first 3 columns, data is everything else
    dataLabels <- dataSet[,1:3]
    imputedDataPoints <- dataSet[,4:length(dataSet[1,])]
    
    # filter out the proteins that have no recorded value
    imputedDataPoints[imputedDataPoints == ""] <- NA
    # find the global smallest value in the data set
    minimumValue <- min(imputedDataPoints, na.rm = TRUE)
    # replace all NAs with the smallest value
    imputedDataPoints <- replace(imputedDataPoints, is.na(imputedDataPoints), minimumValue)
    
    #recombine the labels and transformed data into a single data frame
    imputedData <- cbind(dataLabels, imputedDataPoints)
  
  }
  
  # return the filtered data
  return(imputedData)
  
}




