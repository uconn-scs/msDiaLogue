# Code for data pre-processing

require(dplyr)
require(tidyr)

#################################################
#' Loading, filtering and reformatting of MS DIA data
#' 
#' @description 
#' preprocessing() reads a .csv file, applies filtering conditions, selects columns 
#' necessary for analysis, and returns the reformated data.
#' 
#' @param fileName The name of the file containing MS data (+ the path to the file, if needed) 
#' 
#' @param filterNan A boolean (default = TRUE) specifying if observations including NaN should be omitted. 
#' 
#' @param filterUnique An integer specifying how many unique peptides are required to include a protein
#' 
#' 
#' @details 
#' The function executes the following:
#'   1. reads the file 
#'   2. if applicable, applies filters
#'   3. provides summary statistics and histogram of all values reported in the 
#'      data set
#'   4. selects columns that provide necessary information for analysis
#'   5. re-formats the data to present individual proteins as columns and groups 
#'      replicates under each protein
#'   6. stores the data as a data.frame and prints a few columns to provide a 
#'      visual example to the user.
#'      
#' @returns The function returns a 2d dataframe. 
#' 
###################################################

preprocessing <- function(fileName, filterNaN = TRUE, filterUnique = 2){
    # read in the protein quantitative csv file generated from Spectranaut
    rawData <- read.csv(fileName)
    
    #Filter Data by NaN and unique peptide count
    filteredData <- preProcessFiltering(rawData, filterNaN, filterUnique)
    
    # select columns necessary for analysis 
    selectedData <- filteredData %>% select(R.Condition, R.FileName, R.Replicate,  
                                               PG.Quantity, PG.ProteinNames)
    
    # print summary statistics for full raw data set
    cat("Summary of full data signals (raw)")
    print(summary(selectedData$PG.Quantity))
    cat("\n")
    
    # generate histogram of log2 -transformed full data set values 
    hist(log2(selectedData$PG.Quantity), main = "Histogram of Full Data Set", 
         xlab = "Log2(Data)", breaks = "Scott")
    
    # reformat data to present proteins as the columns
    # and to group replicates under each protein
    reformatedData <- selectedData %>% pivot_wider(id_cols = c(R.Condition, R.FileName, R.Replicate),
                              names_from = PG.ProteinNames, values_from = PG.Quantity)
    
    # store data in a data frame structure
    loadedData <- reformatedData %>% data.frame() 
    
    #Provide sample data for visual inspection
    cat("Example Structure of Pre-Processed Data")
    print(loadedData[,1:5])
    
    # return pre-processed data
    return(loadedData)
}







