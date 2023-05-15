#################################################
#' Compiling data on a single protein from each step in the process
#' 
#' @description 
#' pullProteinPath summarizes the steps that have been performed on the data for one protein. 
#'
#' @param proteinName A String identifying the protein of interest. 
#' 
#' @param dataSetList A list of data frames, the order dictates the order of presentation 
#' 
#' @details 
#' proteinName must match the labels in the data sets exactly.    
#'      
#' @returns The function returns a 2d dataframe, with the protein data at each step present in the dataSetList 
#' 
#################################################
#' @export
pullProteinPath <- function(proteinName, dataSetList){
  
  #label the data frame
  proteinPath <- dataSetList[[1]][1:3]
  
  #for each provided data set
  for (i in 1:length(dataSetList)){
    
    #pull out the name of the type of data
    dataLabel <- names(dataSetList)[i]
    
    #select the correct protein data 
    selectTemp <- dataSetList[[i]] %>% select(proteinName)
  
    #label the correct protein data with the data type
    names(selectTemp) <- dataLabel

    #add the labeled data to the data frame
    proteinPath <- cbind(proteinPath, selectTemp)
    
  }
  
  #return the path of data for this protein
  return(proteinPath)
  
  
}
