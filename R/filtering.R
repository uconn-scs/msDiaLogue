# Code for data filtering

require(dplyr)
require(tidyr)

#################################################
#' Filtering of raw data signals
#' 
#' @description 
#' filtering() applies a series of filtering steps to the data set
#' 
#' @param dataSet The 2d data set of experimental values 
#' 
#' @param filterNaN A Boolean (default = TRUE) specifying whether or not proteins
#' with NaN values should be removed from the data set.
#' 
#' @param filterUnique An integer (default = 2) specifying whether or not proteins
#' with less than the default number of unique peptides should be removed from
#' the data set.
#' 
#' @details 
#' All forms of filtering are recommended for most use cases. 
#'      
#' @returns The function returns a filtered 2d dataframe. 
#' 
#################################################

##TODO: Once we have a data set that includes the unique peptides column the 
# specification can be added. For now, we include only peptides that have at least 2.

#' @export
preProcessFiltering <- function(dataSet, filterNaN = TRUE, filterUnique = 2, filterBlank = TRUE){
  
  filteredData <- dataSet
  
  if (filterNaN) {
    # filter out the proteins that have no recorded value
    filteredData <- filteredData %>% filter(!is.nan(PG.Quantity ))
  }
  
  if (filterUnique >= 2){
    #filter out proteins that have only 1 unique peptide
    filteredData <- filteredData %>% filter(PG.NrOfStrippedSequencesIdentified >= filterUnique)
  }

  if (filterBlank){
    #filter out proteins that have only 1 unique peptide
    filteredData <- filteredData %>% filter(PG.ProteinNames != "")
  }
  
  
  # return the filtered data
  return(filteredData)
  
}

#################################################
#' Filtering proteins or contaminants
#' 
#' @description 
#' filterOutIn() applies a series of filtering steps to the data set
#' 
#' @param dataSet The 2d data set of experimental values 
#' 
#' @param removeList A Boolean specifying whether entries
#' in the following list should be removed or selected.
#' "TRUE" will remove the list of proteins from the data set. 
#' "FALSE will remove all proteins not in the list from the data set.
#' 
#' @param listName A list of proteins or contaminants to select or to remove
#' 
#' @details 
#' If contaminants are removed, a .csv file is created with the removed data.  
#'      
#' @returns The function returns a filtered 2d dataframe. 
#' 
#################################################
#' @export
filterOutIn <- function(dataSet, removeList, listName ){
  
  #relabel the data frame
  filteredData <- dataSet
  
  #If contaminants are being removed
  if (removeList == TRUE){
    
    #create a dataframe of the removed data
    removedData <- filteredData %>% select(any_of(listName))
    
    #save removed data to current working directory as fileName 
    write.csv(removedData, "filtered_out_data.csv")
    
    #remove all of the contaminants if they are present
    filteredData <- filteredData %>% select(-any_of(listName))
    
  }

  #If certain proteins are being selected
  if (removeList == FALSE){
    
    
    #create list of datalabels
    dataLabels <- c("R.Condition", "R.FileName", "R.Replicate")
    
    #add datalabels to listName to make sure data structure is maintained
    listName <- c(dataLabels, listName)
    
    #select only proteins of interest
    filteredData <- filteredData %>% select(all_of(listName))
    
  }
  
  #return the filtered data 
  return(filteredData)
  
  
}

#################################################
#' Filtering NA's post-imputation
#' 
#' @description 
#' filterNA() removes all proteins from the data
#' 
#' @param dataSet The 2d data set of experimental values 
#' 
#' @details 
#' If proteins that don't meet the imputation requirement are removed, 
#' a .csv file is created with the removed data.  
#'      
#' @returns The function returns a filtered 2d dataframe. 
#' 
#################################################
#' @export
filterNA <- function(dataSet){
  
  #relabel the data frame
  filteredData <- dataSet
    
    #create a dataframe of the removed data
    removedData <- filteredData %>% 
                              select_if(function(x) any(is.na(x)))
    
    #add label columns back into data table
    removedData <- bind_cols(dataSet[,1:3], removedData)
    
    #save removed data to current working directory as fileName 
    write.csv(removedData, "filtered_NA_data.csv")
    
    #remove all of the contaminants if they are present
    filteredData <- filteredData %>% select_if(function(x) !any(is.na(x)))
    
  
  #return the filtered data 
  return(filteredData)
  
  
}


