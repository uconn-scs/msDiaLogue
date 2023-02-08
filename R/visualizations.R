# Code for visualizations
#################################################
# The visualizations() function takes as input:
#     1.   
#     2. 

# The function then executes the following:
#   1. creates a volcano plot 
#   2.  
#   3.  

#################################################



visualize <- function(dataSet, logFold = 2){
  
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






