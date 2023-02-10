# Code for data normalizing

require(dplyr)
require(tidyr)

#################################################
#' Normalization of preprocessed data
#' 
#' @description 
#' normalize() applies one specifyed type of normalization to a data set
#' 
#' @param dataSet The 2d data set of experimental values 
#' 
#' @param normalizeType A string (default = "Quant") specifying which type of 
#' normalization to apply: 
#' Quantile ("Quant"), 
#' Column-wise Median ("Median"), 
#' Column-wise Mean ("Mean"), 
#' or None ("None").
#' 
#' 
#' @details 
#' Quantile normalization is generally recommended. Mean and Median
#'normalization are included as popular previous methods. No normalization is not recommended. 
#'      
#' @returns The function returns a normalized 2d dataframe. 
#' 
###################################################

normalize <- function(dataSet, normalizeType = "Quant"){

  
  # Define the number of proteins that are present in data set
  index <- dim(dataSet)[2]
  
  # separate the data set into labels and numerical data
  #labels consist of first 3 columns, data is everything else
  dataLabels <- dataSet[,1:3]
  dataPoints <- dataSet[,4:index]
  
  

  if (normalizeType == "Quant"){
    
    
  }

  
  if (normalizeType == "Median"){
    
    
  }
  
  
  if (normalizeType == "Mean"){
    
    dataPoints <- scale(dataPoints, center = TRUE, scale = TRUE)
    
  }
  
  if (normalizeType == "None"){
    
    warning(" 
            You are currently choosing NOT to normalize your data. 
            This is heavily discouraged in most scientific work. 
            Please be confident this is the correct choice. ")
    
  }
  
  
  #recombine the labels and transformed data into a single data frame
  normDataSet <- cbind(dataLabels, DataPoints)
  
  # return pre-processed data
  return(normDataSet)
}