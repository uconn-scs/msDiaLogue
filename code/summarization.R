# Code for data summary

require(tidyr)
require(dplyr)
require(tictoc)

#################################################
# The summarization() function takes as input:
#     1. A data frame containing the data signals and labels 
#     2. A string specify sort type, if any 
#     3. A boolean specifying if the table should be printed 

# The function then executes the following:
#   1.  
#   2.  
#   3.   
#   4.  
#   5. Produces (/saves) a table of protein mean and standard deviation.
 

# Finally, the function returns the summarized data.
#################################################


summarize <- function(dataSet, sortBy = "",  fileName = ""){
  

  #Calculate the mean and standard deviation for each protein in each sample 
    
  # There's got to be a method for using tidyr here, but I can't find it yet. 
  
  nestedData <- dataSet %>%
    group_by(R.Condition) %>%
    nest()
  
  if (sortBy == "Average"){
    
    # Sort from left to right by highest average 
    
  } 
  
  if (sortBy == "SD"){
    
    # Sort from left to right by lowest standard deviation
    
  } 
  
  if (fileName != ""){
    
    #save file to current working directory as fileName 
    
  } 
  
  
  # print data table
  
  
  
  
}

dat2 <- read.csv("temp.csv")

dat3 <- filter(dat2, 2)

