# Code for data transformation
# see https://pubmed.ncbi.nlm.nih.gov/15147579/
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4373093/

require(dplyr)
require(tidyr)

#################################################
#' Plotting a Mean vs. Variance graph
#'
#' @description 
#' meanVariancePlot() takes a set of protein data organized by column, calculates 
#' the mean and variance of each column and that plots those statistics.
#'
#' @param datMV A data frame containing the data signals  
#' @param title A string with the desired title for the mean-variance plot  
#' 
#' 
#' @returns The function does not return anything. 
#' 

#################################################

meanVariancePlot <- function(datMV, title = ""){
  
  #calculate the mean and variance for each protein individually
  variance <- sapply(datMV, var)
  meanCalc <- sapply(datMV, mean)
  
  #Plot the mean-variance relationship
  plot(meanCalc, variance, main = title, xlab = "Mean", ylab = "Variance")
  
}

#################################################
#' Log based Transformation 
#' 
#' 
#'  @description 
#'  placeholder
#' 
#'  @param dataSet A data frame containing the data signals  
#'  @param  logFold An integer specifying the base for the log transformation
#'  
#'  
#'  @details 
#'  The function executes the following:
#'   1.  Plots the mean-variance relationship (using meanVariancePlot())
#'   3.  Transforms the data 
#'   3.  Plots the mean-variance relationship again for comparison
#'   @returns The function returns the transformed data.

#################################################




transform <- function(dataSet, logFold = 2){
    
      # Define the number of proteins that are present in data set
      index <- dim(dataSet)[2]
      
      # separate the data set into labels and numerical data
      #labels consist of first 2 columns, data is everything else
      dataLabels <- dataSet[,1:3]
      dataPoints <- dataSet[,4:index]
      
      #calculate and plot a mean variance plot 
      meanVariancePlot(dataPoints, title = "Pre-Transformation")
      
      #take the log of the numerical data
      transDataPoints <- log(dataPoints, logFold)
      
      #calculate and plot a mean variance plot 
      meanVariancePlot(transDataPoints,  title = "Post-Transformation")
      
      #recombine the labels and transformed data into a single data frame
      transDataSet <- cbind(dataLabels, transDataPoints)
      
      # return the transformed data
      return(transDataSet)

}


