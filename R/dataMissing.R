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
##

########################################
#### Code for counting missing data ####
########################################
#' 
#' Counting missing data
#' 
#' @description
#' Calculate and plot the missingness.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @param plot A boolean (default = FALSE) specifying whether to plot the missingness.
#' 
#' @param show_labels A boolean (default = TRUE) specifying whether protein names are
#' shown in the visualization when \code{plot = TRUE}.
#' 
#' @import dplyr
#' @import ggplot2
#' @importFrom visdat vis_miss
#' 
#' @returns A 2d dataframe including:
#' \itemize{
#' \item "count_miss": The count of missing values for each protein.
#' \item "pct-miss": The percentage of missing values for each protein.
#' \item "pct_total_miss": The percentage of missing values for each protein relative to
#' the total missing values in the entire dataset.
#' }
#' 
#' @autoglobal
#' 
#' @export

dataMissing <- function(dataSet, plot = FALSE, show_labels = TRUE) {
  dataMissing <- select(dataSet, -c(R.Condition, R.Replicate))
  if (plot == TRUE) {
    if (show_labels == TRUE) {
      plot <- visdat::vis_miss(dataMissing)
    } else {
      plotData <- dataMissing
      colnames(plotData) <- sprintf("%0*d", nchar(ncol(dataMissing)), 1:ncol(dataMissing))
      plot <- visdat::vis_miss(plotData) +
        ggplot2::scale_x_discrete(labels = element_blank())
    }
    print(plot)
  }
  
  count_miss <- colSums(is.na(dataMissing))
  result <- data.frame(count_miss,
                       pct_miss = count_miss/nrow(dataMissing)*100,
                       pct_total_miss = count_miss/sum(count_miss)*100)
  return(as.data.frame(t(result)))
}

