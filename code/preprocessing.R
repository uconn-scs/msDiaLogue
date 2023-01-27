library(tidyr)
library(dplyr)
library(tictoc)

preprocessing <- function(fileName, filterNaN = TRUE){

# read in the protein quantitative csv file generated from Spectranaut
rawData <- read.csv(fileName)

# filter out the proteins that have no recorded value
naNFilteredData <- rawData %>% filter(!is.nan(PG.Quantity))

# select columns necessary for analysis 
selectedData <- naNFilteredData %>% select(R.FileName, R.Replicate,  
                                           PG.Quantity, PG.ProteinNames)

# reformat data to present proteins as the columns
# and to group replicates under each protein
reformatedData <- selectedData %>% pivot_wider(id_cols = c(R.FileName, R.Replicate),
                          names_from = PG.ProteinNames, values_from = PG.Quantity)

# store data in a data frame structure
loadedData <- reformatedData %>% data.frame() 

# clear temporary variables from the workspace
rm(list = c("rawData","naNFilteredData", "selectedData", "reformatedData"))

return(loadedData)

}


dat <- preprocessing("ProteinQuantReport.csv")
