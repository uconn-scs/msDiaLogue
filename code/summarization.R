# Code for data summary

library(tidyr)
library(dplyr)
library(tictoc)

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
 
#################################################

##TODO: Once we have a data set that includes the unique peptides column this 
## function can be written - for now it will exist as pseudo code as a guide



summarize <- function(dataSet, sortBy = "",  fileName = ""){
  

  #Calculate the mean and standard deviation for each protein in each sample 
  # Use sapply here?
  
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

print(dat2)

dat3 <- filter(dat2, 2)

