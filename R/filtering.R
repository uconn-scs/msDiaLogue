# Code for data filtering

require(dplyr)
require(tidyr)

#################################################
#' Filtering of raw data signals
#' 
#' @description 
#' filtering() applies a series of filtering steps to the data set
#' 
#' @param dataSet The 2d data set of experimental values 
#' 
#' @param filterNaN A Boolean (default = TRUE) specifying whether or not proteins
#' with NaN values should be removed from the data set.
#' 
#' @param filterUnique An integer (default = 2) specifying whether or not proteins
#' with less than the default number of unique peptides should be removed from
#' the data set.
#' 
#' @details 
#' All forms of filtering are recommended for most use cases. 
#'      
#' @returns The function returns a filtered 2d dataframe. 
#' 
#################################################

##TODO: Once we have a data set that includes the unique peptides column the 
# specification can be added. For now, we include only peptides that have at least 2.


filtering <- function(dataSet, filterNaN = TRUE, filterUnique = 2){
  
  filteredData <- dataSet
  
  if (filterNaN) {
    # filter out the proteins that have no recorded value
    filteredData <- filteredData %>% filter(!is.nan(PG.Quantity ))
  }
  
  if (filterUnique == 2){
    #filter out proteins that have only 1 unique peptide
    filteredData <- filteredData %>% filter(PG.IsSingleHit == FALSE)
  }

  # return the filtered data
  return(filteredData)
  
}




