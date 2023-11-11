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
#' @param normalizeType A string (default = "quant") specifying which type of
#' normalization to apply:
#' \enumerate{
#' \item Quantile ("quant")
#' \item Column-wise Median ("median")
#' \item Column-wise Mean ("mean")
#' \item None ("none")
#' }
#' 
#' @details
#' Quantile normalization is generally recommended. Mean and median normalization are
#' going to be included as popular previous methods. No normalization is not recommended.
#' Boxplots are also generated for before and after the normalization to give a visual
#' indicator of the changes.
#' 
#' @import dplyr
#' 
#' @returns A normalized 2d dataframe.
#' 
#' @export

normalize <- function(dataSet, normalizeType = "quant") {
  
  ## create a boxplot for pre-normalization
  visualize(dataSet, graphType = "normalize") +
    ggtitle("Pre-Normalization Boxplot")
  
  ## select the numerical data
  dataPoints <- t(select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate")))
  
  if (normalizeType == "quant") {
    
    ## create a ranking database for the original data
    rankSet <- apply(dataPoints, 2, rank, ties.method = "min")
    
    ## sort each column
    sortSet <- apply(dataPoints, 2, sort)
    
    ## calculate row-wise averages of the sorted data
    rowAverages <- rowMeans(sortSet)
    
    ## Rank the rowAverages using the ranking database
    normDataPoints <- apply(rankSet, 2, function(k) {rowAverages[k]})
  
    ## subtracts the median intensity of each protein from every value for that protein
  } else if (normalizeType == "median") {
    normDataPoints <- scale(dataPoints, center = apply(dataPoints, 2, median), scale = FALSE)
    
    ## subtracts the average intensity of each protein from every value for that protein
  } else if (normalizeType == "mean") {
    normDataPoints <- scale(dataPoints, center = TRUE, scale = FALSE)
    
    ## throws a warning for missing normalization, which may introduce errors
  } else if (normalizeType == "none") {
    warning("You are currently choosing NOT to normalize your data.
            This is heavily discouraged in most scientific work.
            Please be confident this is the correct choice.")
    
    normDataPoints <- dataPoints
  }
  
  ## recombine the labels and transformed data into a single data frame
  normDataSet <- cbind(dataSet[,c("R.Condition", "R.FileName", "R.Replicate")],
                       t(normDataPoints))
  
  ## replace the protein names
  colnames(normDataSet) <- colnames(dataSet)
  
  ## create a boxplot for post-normalization
  visualize(normDataSet, graphType = "normalize") +
    ggtitle("Post-Normalization Boxplot")
  
  ## return pre-processed data
  return(normDataSet)
}

