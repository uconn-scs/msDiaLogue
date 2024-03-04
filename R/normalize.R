##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2024  Shiying Xiao, Timothy Moore and Charles Watt
## Shiying Xiao <shiying.xiao@uconn.edu>
##
## This file is part of the R package msDiaLogue.
##
## The R package msDiaLogue is free software: You can redistribute it and/or
## modify it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or any later
## version (at your option). See the GNU General Public License at
## <https://www.gnu.org/licenses/> for details.
##
## The R package wdnet is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#####################################
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
#' \item "quant": Quantile \insertCite{bolstad2003comparison}{msDiaLogue}
#' \item "median": Protein-wise Median
#' \item "mean": Protein-wise Mean
#' \item "none": None
#' }
#' 
#' @details
#' Quantile normalization is generally recommended. Mean and median normalization are
#' going to be included as popular previous methods. No normalization is not recommended.
#' Boxplots are also generated for before and after the normalization to give a visual
#' indicator of the changes.
#' 
#' @import dplyr
#' @import ggplot2
#' @importFrom limma normalizeQuantiles
#' @importFrom Rdpack reprompt
#' 
#' @returns A normalized 2d dataframe.
#' 
#' @references
#' \insertAllCited{}
#' 
#' @autoglobal
#' 
#' @export

normalize <- function(dataSet, normalizeType = "quant") {
  
  ## create a boxplot for pre-normalization
  visualize(dataSet, graphType = "normalize") +
    ggtitle("Pre-Normalization Boxplot")
  
  ## select the numerical data
  dataPoints <- t(select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate")))
  
  if (normalizeType == "quant") {
    
    normDataPoints <- limma::normalizeQuantiles(dataPoints)
    
    ## subtracts the median intensity of each protein from every value for that protein
  } else if (normalizeType == "median") {
    normDataPoints <- scale(dataPoints,
                            center = apply(dataPoints, 2, median, na.rm = TRUE),
                            scale = FALSE)
    
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
  plot <- visualize(normDataSet, graphType = "normalize") +
    ggtitle("Post-Normalization Boxplot")
  print(plot)
  
  ## return pre-processed data
  return(normDataSet)
}

