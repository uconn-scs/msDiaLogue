# Code for data filtering
library(tidyr)
library(dplyr)
library(tictoc)

#################################################
# The filtering() function takes as input:
#     1. A data frame containing the data signals and labels 
#     2. A Boolean specifying whether or not to filter out results that are NaN
#     3. An integer specifying how many unique peptides are required to include a protein

# The function then executes the following:
#   1.  filters out NaN values
#   2.  filters out proteins with an insufficient number of unique peptides

# Finally, the function returns the filtered data.
#################################################

##TODO: Once we have a data set that includes the unique peptides column the 
# specification can be added. For now, we include 


filtering <- function(dataSet, filterNaN = TRUE, filterUnique = 2){
  
  filteredData <- dataSet
  
  if (filterNaN) {
    # filter out the proteins that have no recorded value
    filteredData <- filteredData %>% filter(!is.nan(PG.Quantity ))
  }
  
  if (filterUnique == 2){
    #filter out proteins that have only 1 unique peptide
    filteredData <- filteredData %>% filter(PG.IsSingleHit == FALSE)
  }

  # return the filtered data
  return(filteredData)
  
}

rawData <- read.csv("ProteinQuantReport.csv")

filteredData <- filtering(rawData)


