# Code for data transformation
# see https://pubmed.ncbi.nlm.nih.gov/15147579/
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4373093/

library(tidyr)
library(dplyr)
library(tictoc)

#################################################
# The preprocessing() function takes as input:
#     1. A data frame containing the pre-processed data signals  
#     2. An integer specifying the base for the log transformation

# The function then executes the following:
#   1.  
#   2. 
#   3. 


# Finally, the function returns the transformed data.
#################################################


#TODO: Rewrite plotting to consist of mean vs variance plots for each protein seperately  


transform <- function(dataSet, logFold = 2){
  
      index <- dim(dataSet)[2]
  
      variance <- sapply(dataSet, var)
      meanCalc <- sapply(dataSet, mean)
      
      plot(meanCalc, variance)
      
      logFold <- 2
      
      dataSet[,3:index] <- log(dataSet[,3:index], logFold)
      
      variance <- sapply(dataSet[,3:index], var)
      meanCalc <- sapply(dataSet[,3:index], mean)
      
      plot(meanCalc, variance)

      return(dataSet)

}

dataSet <- dat


dat2 <- transform(dat,2)
