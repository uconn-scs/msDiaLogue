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

######################################
#### Code for data transformation ####
######################################
# @references
# \itemize{
# \item Archer, K. J., Dumur, C. I. and Ramakrishnan, V. (2004).
# "Graphical Technique for Identifying a Monotonic Variance Stabilizing Transformation for
# Absolute Gene Intensity Signals".
# \emph{BMC Bioinformatics}, 5, 60.
# \href{https://doi.org/10.1186/1471-2105-5-60}{DOI}.
# \item Kammers, K., Cole, R. N., Tiengwe, C. and Ruczinski, I. (2015).
# "Detecting Significant Changes in Protein Abundance".
# \emph{EuPA Open Proteomics}, 7, 11--19.
# \href{https://doi.org/10.1016/j.euprot.2015.02.002}{DOI}.
# }
#' 
#' Plotting a graph of mean versus variance
#' 
#' @description
#' Take a set of protein data organized by column, calculate the mean and variance of each
#' column, and then plot those statistics.
#' 
#' @param datMV A data frame containing the data signals.
#' 
#' @param title A string with the desired title for the mean-variance plot.
#' 
#' @return
#' An object of class \code{plot}.
#' 
#' @autoglobal
#' 
#' @noRd

meanVarPlot <- function(datMV, title = "") {
  
  ## calculate the mean and variance for each protein individually
  plotData <- data.frame(t(sapply(datMV, function(x) {
    c(Mean = mean(x, na.rm = TRUE), Variance = var(x, na.rm = TRUE))
  })))
  
  ## plot the mean-variance relationship
  ggplot(plotData, aes(Mean, Variance)) +
    geom_point() +
    labs(title = title) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
}


##----------------------------------------------------------------------------------------
#' 
#' Transformation
#' 
#' @description
#' Apply a transformation to the data to stabilize the variance.
#'  
#' @param dataSet A data frame containing the data signals.
#' 
#' @param method A string (default = "log") specifying the method to be used for the
#' transformation:
#' \enumerate{
#' \item "log": Logarithm transformation.
#' \item "root": Root transformation.
#' }
#'  
#' @param logFold An integer (default = 2) specifying the base for the log transformation
#' when \code{method = "log"}.
#' 
#' @param root An integer (default = 2) specifying the degree of the root for the root
#' transformation when \code{method = "root"}. For example, set it to 2 for square root or
#' 3 for cube root.
#' 
#' @details
#' The function executes the following:
#' \enumerate{
#' \item Plots the mean-variance relationship.
#' \item Transforms the data.
#' \item Plots the mean-variance relationship again for comparison.
#' }
#' 
#' @return
#' The transformed data.
#' 
#' @export

transform <- function(dataSet, method = "log", logFold = 2, root = 2) {
  
  ## organize the data for transformation
  dataPoints <- dataSet %>%
    select(-c(R.Condition, R.Replicate))
  
  ## calculate and plot a mean-variance plot 
  plotPre <- meanVarPlot(dataPoints, title = "Pre-Transformation")
  print(plotPre)
  
  ## take the log of the numerical data
  if (method == "log") {
    transDataPoints <- log(dataPoints, logFold)
  } else if (method == "root") {
    transDataPoints <- dataPoints^(1/root)
  }
  
  ## calculate and plot a mean-variance plot 
  plotPost <- meanVarPlot(transDataPoints,  title = "Post-Transformation")
  print(plotPost)
  
  ## recombine the labels and transformed data into a single data frame
  transDataSet <- cbind(dataSet[,c("R.Condition", "R.Replicate")], transDataPoints)
  
  ## return the transformed data
  return(transDataSet)
}

