# Code for data analysis

require(tidyr)
require(dplyr)


#################################################
#' Producing results of t-test
#' 
#' @description 
#' This function produces output (difference of means, and P value) for visual
#' inspection or for external use.  
#' 
#' @param x The function takes a parameter x, a 1d dataframe, where the first 
#' half of the data are from the first condition, and the second half are 
#' from the second condition.
#' 
#' @returns The function returns a list of length 2 with the difference of means and 
#' the t-tested p-values for the protein across two conditions. 
#' 
#################################################

tTesting <- function(x){
  
  # calculate the number of replicates - assumes they are equal
  nR <- length(x)/2
  
  out <- tryCatch(
    {
      #run a t.test on the data
      tempx <- t.test(x[1:nR],x[as.integer(nR+1):as.integer(nR*2)])
      #combine the difference in means and the p-value to a list
      c(mean(x[1:nR])-mean(x[as.integer(nR+1):as.integer(nR*2)]), tempx$p.value) 
    },
    
    # if an error is thrown, catch it and print that the data are constant to
    #keep the program from ending.
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
#' This function produces output (fold change, and P value) for a volcano plot. 
#' 
#' @param x The function takes a parameter x, a 1d dataframe, where the first 
#' half of the data are from the first condition, and the second half are 
#' from the second condition.
#' 
#' @details 
#' If the means between the two conditions are the same, t.test throws an error, 
#' which is caught and printed to the user to make sure the program keeps running
#' 
#' WARNING: currently, the function does not apply a further transformation. 
#' The data must be log 2 transformed in a previous step to be transformed here. 
#'  
#' @returns The function returns a list of length 2 with the difference of means and 
#' the t-tested p-values for the protein across two conditions.  
#' 
#################################################

volcanoTest <- function(x){
  
     # calculate the number of replicates - assumes they are equal  
      nR <- length(x)/2
  
      out <- tryCatch(
        {
      
      #run a t.test on the data
      tempx <- t.test(x[1:nR],x[as.integer(nR+1):as.integer(nR*2)])
      #combine the difference in means and the p-value to a list
      c(mean(x[1:nR])-mean(x[as.integer(nR+1):as.integer(nR*2)]), tempx$p.value) 
        },
      
      # if an error is thrown, catch it and print that the data are constant to
      #keep the program from ending.
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
#' p-values for every protein across the two conditions. The dataframe is sorted
#' by ascending p-value.  
#' 
#################################################

analyze <- function(dataSet, conditions, testType = "t-test"){
  
  
  #check if only two conditions have been given 
  if (length(conditions)!= 2 ){
    
    warning("This analysis can only be performed on 2 conditions at a time. 
            Please select exactly 2 conditions to compare.
            Alternatively, please consider using ANOVA.")
    
  }
  
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
  rownames(statSetOut) <- c("Log Fold Change", "P-value")
    
    
  }
  
  
  #sort output by ascending p-value
  statSetOut <- statSetOut[,order(as.matrix(statSetOut[2,]))]
  
  # return pre-processed data
  return(statSetOut)
}







