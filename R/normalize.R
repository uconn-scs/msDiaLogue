###################################
#### Code for data normalizing ####
###################################
#' 
#' Normalization of preprocessed data
#' 
#' @description 
#' Apply a specified type of normalization to a data set.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @param normalizeType A string (default = "Quant") specifying which type of
#' normalization to apply:
#' \enumerate{
#' \item Quantile ("Quant")
#' \item Column-wise Median ("Median")
#' \item Column-wise Mean ("Mean")
#' \item None ("None")
#' }
#' 
#' @details
#' Quantile normalization is generally recommended. Mean and Median normalization are
#' going to be included as popular previous methods. No normalization is not recommended.
#' Boxplots are also generated for before and after the normalization to give a visual
#' indicator of the changes.
#' 
#' @returns A normalized 2d dataframe.
#' 
#' @export

normalize <- function(dataSet, normalizeType = "Quant") {
  
  ## create a boxplot for pre-normalization
  visualize(dataSet, graphType = "normalize", conditionLabels = "Pre -")
  
  ## separate the data set into labels and numerical data
  ## labels consist of the first 3 columns, data is everything else
  dataLabels <- dataSet[,1:3]
  dataPoints <- dataSet[,4:length(dataSet[1,])]
  
  dataPoints <- t(dataPoints)
  
  ## define the number of proteins that are present in the data set
  index <- length(dataPoints[1,])
  
  if (normalizeType == "Quant") {
    ## TODO: update quantile normalization to handle ties.
    
    ## create a database of the original locations
    orderSet <- apply(dataPoints, 2, order)
    
    ## sort each column and average the values across the new rows
    temp <-  data.frame(apply(dataPoints, 2, sort))
    rowAverages <- apply(temp, 1, mean)
    
    ## create a data set of just the row averages repeated for each protein
    fullAverages <- matrix(rep(rowAverages, index), ncol = index)
    
    ## reorder the values into their original locations
    normDataPoints = c()
    
    ## repeat the process for each protein
    for (i in 1:index) {
      
      ## create a new data frame by combining data points for a single protein with
      ## a list from 1 to n
      temp <- data.frame(cbind(fullAverages[,i], orderSet[,i]))
      
      ## sort the new data frame by the protein values
      reOrderI <- arrange(temp, X2)[,1]
      
      ## record the data points locations
      normDataPoints <- cbind(normDataPoints, reOrderI)
    }
  
    ## subtracts the median intensity of each protein from every value for that protein
  } else if (normalizeType == "Median") {
    normDataPoints <- scale(dataPoints, center = apply(dataPoints, 2, median), scale = FALSE)
    
    ## subtracts the average intensity of each protein from every value for that protein
  } else if (normalizeType == "Mean") {
    normDataPoints <- scale(dataPoints, center = TRUE, scale = FALSE)
    
    ## throws a warning for missing normalization, which may introduce errors
  } else if (normalizeType == "None") {
    warning("You are currently choosing NOT to normalize your data.
            This is heavily discouraged in most scientific work.
            Please be confident this is the correct choice.")
    
    normDataPoints <- dataPoints
  }
  
  normDataPoints <- t(normDataPoints)
  
  ## recombine the labels and transformed data into a single data frame
  normDataSet <- cbind(dataLabels, normDataPoints)
  
  ## replace the protein names
  colnames(normDataSet) <- colnames(dataSet)
  
  ## replace the sample names
  rownames(normDataSet) <- rownames(dataSet)
  
  ## create a boxplot for post-normalization
  visualize(normDataSet, graphType = "normalize", conditionLabels = "Post -")
  
  ## return pre-processed data
  return(normDataSet)
}

