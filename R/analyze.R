# Code for data analysis

require(tidyr)
require(dplyr)


#################################################
#' Producing results of t-test
#' 
#' @description 
#' placeholder
#' 
#' @param x placeholder
#' 
#'  
#' @returns The function returns a 1d dataframe with differences of means and 
#' p-values across the two conditions.  
#' 
#################################################

tTesting <- function(x){
  
  nR <- length(x)/2
  
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


#################################################
#' Producing results for volcano plot
#' 
#' @description 
#' placeholder
#' 
#' @param x placeholder
#' 
#'  
#' @returns The function returns a 1d dataframe with differences of log2 means and 
#' t-tested p-values for every protein across the two conditions.  
#' 
#################################################

volcanoTest <- function(x){
  
      nR <- length(x)/2
  
      out <- tryCatch(
        {
      
      
      tempx <- t.test(x[1:nR],x[as.integer(nR+1):as.integer(nR*2)])
      c(log2(mean(x[1:nR]))-log2(mean(x[as.integer(nR+1):as.integer(nR*2)])), tempx$p.value) 
        },
      
      error = function(cond){
        message("data are essentially constant")
        return(1)
      }
      )
}



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
  
  #combine just the results from these conditions
  testData <- rbind(testDataA, testDataB)
  
  #separate off the labels from the data
  testDataPoints <- testData[,4:length(testData[1,])]
  
  #count the number of replicates
  nR <- length(unique(testData$R.Replicate))
  

  
  
  
  
  if (testType == "t-test"){
  #generate each result protein by protein
  statSet <- apply(testDataPoints, 2, tTesting)
  #compile as dataframe
  statSetOut <- data.frame(statSet)
  #set names for rows
  rownames(statSetOut) <- c("Difference in Means", "P-value")
  
  }
  
  
  
  if (testType == "volcano") {
  
  #generate each result protein by protein
  statSet <- apply(testDataPoints, 2, volcanoTest)
  
  #compile as dataframe
  statSetOut <- data.frame(statSet)
  
  #set names for rows
  rownames(statSetOut) <- c("Log 2 Fold Change", "P-value")
    
    
  }
  
  
  #sort output by ascending p-value
  statSetOut <- statSetOut[,order(as.matrix(statSetOut[2,]))]
  
  # return pre-processed data
  return(statSetOut)
}







