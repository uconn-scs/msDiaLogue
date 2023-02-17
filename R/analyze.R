# Code for data analysis

require(tidyr)
require(dplyr)

#################################################
#' Analyzing summarized data
#' 
#' @description 
#' analyze() applies a statistical test to the data.
#' 
#' @param summaryData The 2d data set of data 
#' 
#' @param testType A string (default = "t-test") specifying which 
#' statistical test to use.
#' 
#' @param conditions A list of length 2, composed of integers, specifying 
#' which conditions to compare
#'  
#' @returns The function returns a 2d dataframe with differences of means and 
#' p-values for every protein across the two conditions.  
#' 
#################################################

analyze <- function(dataSet, conditions, testType = "t-test"){
  
  #select two conditions
  testDataA <- dataSet[grep(toString(conditions[1]) , dataSet$R.Condition), ]
  testDataB <- dataSet[grep(toString(conditions[2]) , dataSet$R.Condition), ]
  
  testData <- rbind(testDataA, testDataB)

  testDataPoints <- testData[,4:length(testData[1,])]
  
  nR <- length(unique(testData$R.Replicate))
  
  tTesting <- function(x){
    
    out <- tryCatch(
      {
        tempx <- t.test(x[1:nR],x[as.integer(nR+1):as.integer(nR*2)])
        c(mean(x[1:nR])-mean(x[as.integer(nR+1):as.integer(nR*2)]), tempx$p.value) 
      },
      
      error = function(cond){
        message("data are essentially constant")
        return(1)
      }
    )
  }
  
  
  statSet <- apply(testDataPoints, 2, tTesting)
  
  statSetOut <- data.frame(statSet)
  
  rownames(statSetOut) <- c("Difference in Means", "P-value")
  
  statSetOut <- statSetOut[,order(as.matrix(statSetOut[2,]))]
  
  # return pre-processed data
  return(statSetOut)
}







