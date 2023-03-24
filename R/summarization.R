# Code for data summary

require(dplyr)
require(tidyr)

#################################################
#' Summarize protein intensities across replicates 
#' 
#' @description 
#' summarize() calculates the mean, standard deviation and replicate count for 
#' protein across every condition.
#' 
#' 
#' @param dataSet A data frame containing the data signals and labels
#' 
#' @param fileName A string which can be used to generate a csv file of the summary statistics
#' 
#' 
#' @returns The function returns a 2d summarized data frame.
#################################################


summarize <- function(dataSet, fileName = ""){
  
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
  
  #if only two samples are present, then calculate fold change automatically.
  if (sampleList == 2){
    
    foldChange <- proteinSummary[2,]/proteinSummary[1,]
    
    proteinSummary <- rbind(proteinSummary, foldChange)
    
    rowNames <- c("Condition 1", "Condition 2", "Fold Change")
    
    proteinSummary <- cbind(rowNames, proteinSummary)
    
    for (i in 2:length(proteinSummary[1,])) {
      
      print(!grepl("*_mean", colnames(proteinSummary)[i]))
      
      if (!grepl("*_mean", colnames(proteinSummary)[i])){
        
        proteinSummary[3,i] <- NA
        
      }
      
    }
                                                  
    
  }
    
  
  if (fileName != ""){
    
    #save file to current working directory as fileName 
    write.csv(proteinSummary, fileName, row.names=sampleList)
    
  } 
  
  # return protein data summary
  return(proteinSummary)
  
  
}



