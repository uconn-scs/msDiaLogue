# Code for data analysis



#################################################
#' Analyzing summarized data
#' 
#' @description 
#' analyze() applies a statistical test to the data.
#' 
#' @param summaryData The 2d data set of data 
#' 
#' @param testType A string (default = "t-test") specifying which 
#' statistical test to use.
#' 
#' @param conditions A list of length 2, composed of integers, specifying 
#' which conditions to compare
#'  
#' @returns The function returns a 2d dataframe with differences of means and 
#' p-values for every protein across the two conditions.  
#' 
#################################################



analyze <- function(dataSet ){

  
  #select two conditions
  
  #stack replicates into list
  
  #use apply() to run t-test for each one. t.test(y1,y2)
  
  
  
  # return pre-processed data
  return(dataSummary)
}







