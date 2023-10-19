################################
#### Code for data analysis ####
################################
#' 
#' Producing results of t-test
#' 
#' @description
#' Produce output (difference of means, and P-value) for visual inspection or for external
#' use.
#' 
#' @param x A 1d dataframe, where data from the first condition are listed first, and data
#' from the second condition are listed second.
#' 
#' @param lengthA An integer specifying the number of the data points in \code{x} are from
#' the first condition.
#' 
#' @importFrom stats t.test
#' 
#' @returns A list of length 2 with the difference of means and the P-values from a t-test
#' for the protein across two conditions.

tTesting <- function(x, lengthA) {
  
  out <- tryCatch({
    
    ## run a t.test on the data
    tempx <- t.test(x[1:lengthA], x[as.integer(lengthA+1):as.integer(length(x))])
    
    ## combine the difference in means and the P-value to a list
    c(mean(x[1:lengthA])-mean(x[as.integer(lengthA+1):as.integer(length(x))]), tempx$p.value)
    
  }, error = function(cond) {
    
    ## if an error is thrown, catch it and print that the data are constant to keep the
    ## program from ending.
    message("data are essentially constant")
    
    return(1)
  })
}


##----------------------------------------------------------------------------------------
#' 
#' Producing results for a volcano plot
#' 
#' @description
#' Produce output (fold change, and P-value) for a volcano plot.
#' 
#' @param x A 1d dataframe, where data from the first condition are listed first, and data
#' from the second condition are listed second.
#' 
#' @param lengthA An integer specifying the number of the data points in \code{x} are from
#' the first condition.
#' 
#' @details
#' If the means between the two conditions are the same, t.test throws an error, which is
#' caught and printed to the user to make sure the program keeps running.
#' 
#' WARNING: Currently, the function does not apply any further transformation. The data
#' must undergo a log2 transformation in a previous step before being used here.
#' 
#' @importFrom stats t.test
#' 
#' @returns A list of length 2 with the difference of means and the P-values from a t-test
#' for the protein across two conditions.

volcanoTest <- function(x, lengthA) {
  
  out <- tryCatch({
    
    ## run a t.test on the data
    tempx <- t.test(x[1:lengthA], x[as.integer(lengthA+1):as.integer(length(x))])
    
    ## combine the difference in means and the P-value to a list
    c(mean(x[1:lengthA])-mean(x[as.integer(lengthA+1):as.integer(length(x))]), tempx$p.value) 
    
  }, error = function(cond) {
    
    ## if an error is thrown, catch it and print that the data are constant to keep the
    ## program from ending.
    message("data are essentially constant")
    
    return(1)
  })
}


##----------------------------------------------------------------------------------------
#' 
#' Analyzing summarized data
#' 
#' @description
#' Apply a statistical test to the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param conditions A list of length 2, composed of integers, specifying which conditions
#' to compare.
#' 
#' @param testType A string (default = "t-test") specifying which statistical test to use:
#' \enumerate{
#' \item "t-test": unequal variance t-test.
#' \item "volcano": output to plot a volcano plot.
#' \item "MA": output to plot an MA plot.
#' }
#' 
#' @returns A 2d dataframe with differences of means and P-values for every protein across
#' the two conditions, sorted in ascending order by P-value.
#' 
#' @export

analyze <- function(dataSet, conditions, testType = "t-test") {
  
  ## check if only two conditions have been given
  if (length(conditions) != 2) {
    warning("This analysis can only be performed on 2 conditions at a time.
            Please select exactly 2 conditions to compare.
            Alternatively, please consider using ANOVA.")
    break
  }
  
  ## select two conditions
  ## the messy "grep and paste" functions ensure that only exact matches are found
  testDataA <- dataSet[grep(paste(
    paste("^",toString(conditions[1]),sep = ""), "$", sep = "" ), dataSet$R.Condition), ]
  testDataB <- dataSet[grep(paste(
    paste("^",toString(conditions[2]),sep = ""), "$", sep = "" ), dataSet$R.Condition), ]
  
  ## combine only the results from these conditions
  testData <- rbind(testDataA, testDataB)
  
  ## separate the labels from the data
  testDataPoints <- testData[,4:length(testData[1,])]
  
  nRepA <- length(testDataA[,1])
  
  if (testType == "t-test") {
    
    ## generate each result protein by protein
    statSet <- apply(testDataPoints, 2, tTesting, lengthA = nRepA)
    
    ## compile as a dataframe
    statSetOut <- data.frame(statSet)
    
    ## set names for the rows
    rownames(statSetOut) <- c("Difference in Means", "P-value")
    
    ## sort the output by ascending P-value
    statSetOut <- statSetOut[,order(as.matrix(statSetOut[2,]))]
    
  } else if (testType == "volcano") {
    
    ## generate each result protein by protein
    statSet <- apply(testDataPoints, 2, volcanoTest, lengthA = nRepA)
    
    ## compile as a dataframe
    statSetOut <- data.frame(statSet)
    
    ## set names for the rows
    rownames(statSetOut) <- c("Log Fold Change", "P-value")
    
    ## sort the output by ascending P-value
    statSetOut <- statSetOut[,order(as.matrix(statSetOut[2,]))]
    
  } else if (testType == "MA") {
    
    ## find the average of each condition individually
    statSetOutA <- apply(testDataA[,4:length(testDataA[1,])], MARGIN = 2, FUN = mean)
    statSetOutB <- apply(testDataB[,4:length(testDataB[1,])], MARGIN = 2, FUN = mean)
    
    ## combine into one data set
    statSetOut <- rbind(statSetOutA, statSetOutB)
    
    ## set names for rows to the condition names
    rownames(statSetOut) <- conditions
    
    ## compile as a dataframe
    statSetOut <- data.frame(statSetOut)
  }
  
  ## return pre-processed data
  return(statSetOut)
}

