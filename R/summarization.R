# Code for data summary
#################################################
# The summarization() function takes as input:
#     1. A data frame containing the data signals and labels 
#     2. A string specify sort type, if any 
#     3. A string specifying if the table should be printed, and providing the file name 

# The function then executes the following:
#   1.  
#   2.  
#   3.   
#   4.  
#   5. Produces (/saves) a table of protein mean, standard deviation and N.
 

# Finally, the function returns the summarized data.
#################################################


summarize <- function(dataSet, sortBy = "",  fileName = ""){
  
  #Calculate the mean,  standard deviation and sample count for each protein in each sample 
  
  # create a list of all protein names in the data   
  proteinList <- names(dataSet)[-c(1:3)][1:10]
  
  #create a list of all samples in the data
  sampleList <- unique(dataSet$R.Condition)
  
  
  #group all of the data by sample number  
  sampleGrouping <- dataSet %>% group_by(R.Condition) 
  
  #define the list of functions that will be applied to each protein at 
  funcList <- list(mean = ~mean(., na.rm = TRUE), 
                          sd = ~sd(., na.rm = TRUE), 
                          n = ~sum(!is.na(.)))
  
  #summarize each protein by sample dataset with the 3 functions defined above
  proteinSummary <- sampleGrouping %>% summarize_at(c(proteinList), funcList) 
  
  #sort the summary so that values for each protein are sequential
  proteinSummary <- proteinSummary %>% select(starts_with(proteinList))
    
  
  if (sortBy == "Average"){
    
    # Sort from left to right by highest average 
    
  } 
  
  if (sortBy == "SD"){
    
    # Sort from left to right by lowest standard deviation
    
  } 
  
  if (fileName != ""){
    
    #save file to current working directory as fileName 
    write.csv(proteinSummary, fileName, row.names=sampleList)
    
  } 
  
  
  # return protein data summary
  return(proteinSummary)
  
  
}



