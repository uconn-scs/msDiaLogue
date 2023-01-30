# Code for data filtering

library(tidyr)
library(dplyr)
library(tictoc)

#################################################
# The filtering() function takes as input:
#     1. A data frame containing the data signals and labels 
#     2. An integer specifying the required number of unique peptides

# The function then executes the following:
#   1.  
#   2.  
#   3.   
#   4.  
#   5. 

# Finally, the function returns the filtered data.
#################################################

##TODO: Once we have a data set that includes the unique peptides column this 
  ## function can be written - for now it will exist as pseudo code as a guide



filter <- function(dataSet, numberRequiredPeptides = 2){
  
  #Find indexes of proteins that don't pass filter  
  
  #Generate list of protein names that didn't pass the filter 
  
  #Print list
  
  #Remove samples that do not pass the filter

  # return the filtered data
  return(filteredDataSet)
  
}

dat2 <- read.csv("temp.csv")

dat3 <- filter(dat2, 2)


