##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2025  Shiying Xiao, Timothy Moore and Charles Watt
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
## The R package msDiaLogue is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##

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
#' @param applyto A string (default = "sample") specifying the target of normalization.
#' Options are "sample" or "row" (across rows), and "protein" or "column" (across columns).
#' 
#' @param normalizeType A string (default = "quant") specifying which type of
#' normalization to apply:
#' \itemize{
#' \item "auto": Auto scaling \insertCite{jackson1991user}{msDiaLogue}.
#' \item "level": Level scaling.
#' \item "mean": Mean centering.
#' \item "median": Median centering.
#' \item "pareto": Pareto scaling.
#' \item "quant": Quantile normalization \insertCite{bolstad2003comparison}{msDiaLogue}.
#' \item "range": Range scaling.
#' \item "vast": Variable stability (VAST) scaling. \insertCite{keun2003improved}{msDiaLogue}.
#' \item "none": None.
#' }
#' 
#' @param plot A boolean (default = TRUE) specifying whether to plot the boxplot
#' for before and after normalization.
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

normalize <- function(dataSet, applyto = "sample", normalizeType = "quant", plot = TRUE) {
  
  ## create a boxplot for pre-normalization
  if (plot) {
    plotobj <- visualize(dataSet, graphType = "normalize") +
      ggtitle("Pre-Normalization Boxplot")
    print(plotobj)
  }
  
  ## select the numerical data
  if (applyto == "sample") {
    dataPoints <- t(select(dataSet, -c(R.Condition, R.Replicate)))
  } else if (applyto == "protein") {
    dataPoints <- select(dataSet, -c(R.Condition, R.Replicate))
  }
  
  if (normalizeType == "auto") {
    
    ## auto scaling
    normDataPoints <- base::scale(dataPoints, center = TRUE, scale = TRUE)
    
  } else if (normalizeType == "level") {
    
    ## level scaling
    normDataPoints <- base::scale(dataPoints, center = TRUE,
                                  scale = apply(dataPoints, 2, mean, na.rm = TRUE))
    
  } else if (normalizeType == "mean") {
    
    ## mean centering
    normDataPoints <- scale(dataPoints, center = TRUE, scale = FALSE)
    
  } else if (normalizeType == "median") {
    
    ## median centering
    normDataPoints <- scale(dataPoints,
                            center = apply(dataPoints, 2, median, na.rm = TRUE),
                            scale = FALSE)
    
  } else if (normalizeType == "pareto") {
    
    ## Pareto scaling
    sigma <- apply(base::scale(dataPoints, center = TRUE, scale = FALSE), 2, function(col) {
      col <- col[!is.na(col)]
      sqrt(sum(col^2) / max(1L, length(col)-1L))
    })
    normDataPoints <- base::scale(dataPoints, center = TRUE, scale = sqrt(sigma))
    
  } else if (normalizeType == "quant") {
    
    ## quantile normalization
    normDataPoints <- limma::normalizeQuantiles(dataPoints)
    
  } else if (normalizeType == "range") {
    
    ## range scaling
    range_diff <- apply(dataPoints, 2, function(col) {
      res <- max(col, na.rm = TRUE) - min(col, na.rm = TRUE)
      res <- ifelse(res == 0, 1, res)
      return(res)
    })
    normDataPoints <- base::scale(dataPoints, center = TRUE, scale = range_diff)
    
  } else if (normalizeType == "vast") {
    
    ## vast scaling
    mu <- colMeans(dataPoints, na.rm = TRUE)
    sigma <- apply(base::scale(dataPoints, center = TRUE, scale = FALSE), 2, function(col) {
      col <- col[!is.na(col)]
      sqrt(sum(col^2) / max(1L, length(col)-1L))
    })
    normDataPoints <- base::scale(dataPoints, center = TRUE, scale = sigma^2/mu)
    
  } else if (normalizeType == "none") {
    
    warning("You are currently choosing NOT to normalize your data.
            This is heavily discouraged in most scientific work.
            Please be confident this is the correct choice.")
    normDataPoints <- dataPoints
    
  }
  
  ## recombine the labels and transformed data into a single data frame
  if (applyto == "sample") {
    normDataSet <- cbind(dataSet[,c("R.Condition", "R.Replicate")],
                         t(normDataPoints))
  } else if (applyto == "protein") {
    normDataSet <- cbind(dataSet[,c("R.Condition", "R.Replicate")],
                         normDataPoints)
  }
  
  ## replace the protein names
  colnames(normDataSet) <- colnames(dataSet)
  
  ## create a boxplot for post-normalization
  if (plot) {
    plotobj <- visualize(normDataSet, graphType = "normalize") +
      ggtitle("Post-Normalization Boxplot")
    print(plotobj)
  }
  
  ## return pre-processed data
  return(normDataSet)
}

