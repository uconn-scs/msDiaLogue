# Code for data transformation
# see https://pubmed.ncbi.nlm.nih.gov/15147579/
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4373093/

require(tidyr)
require(dplyr)
require(tictoc)

#################################################
# The transformation() function takes as input:
#     1. A data frame containing the pre-processed data signals  
#     2. An integer specifying the base for the log transformation

# The function then executes the following:
#   1.  Separate label columns from data columns
#   2.  Plot the mean-variance relationship (using a subfunction)
#   3.  Transform the data 
#   4.  Plot the mean-variance relationship again for comparison
#   5.  Recombine the labels and transformed data 

# Finally, the function returns the transformed data.
#################################################

meanVariancePlot <- function(datMV, title = ""){
  
  #calculate the mean and variance for each protein individually
  variance <- sapply(datMV, var)
  meanCalc <- sapply(datMV, mean)
  
  #Plot the mean-variance relationship
  plot(meanCalc, variance, main = title, xlab = "Mean", ylab = "Variance")
  
}

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

dat2 <- transform(dat,2)
