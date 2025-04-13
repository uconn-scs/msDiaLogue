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

###############################
#### Code for data summary ####
###############################
#' 
#' Summarize protein intensities across conditions 
#' 
#' @description
#' Calculate the mean, standard deviation, and replicate count for protein across every
#' condition.
#' 
#' @param dataSet A data frame containing the data signals and labels.
#' 
#' @param saveSumm A boolean (default = TRUE) specifying whether to save the summary
#' statistics to current working directory.
#' 
#' @details
#' The column 'Stat' in the generated data.frame includes the following statistics:
#' \itemize{
#' \item n: Number.
#' \item mean: Mean.
#' \item sd: Standard deviation.
#' \item median: Median.
#' \item trimmed: Trimmed mean with a trim of 0.1.
#' \item mad: Median absolute deviation (from the median).
#' \item min: Minimum.
#' \item max: Maximum.
#' \item range: The difference between the maximum and minimum value.
#' \item skew: Skewness.
#' \item kurtosis: Kurtosis.
#' \item se: Standard error.
#' }
#' 
#' @importFrom psych describeBy
#' 
#' @returns A 2d summarized data frame.
#' 
#' @export

summarize <- function(dataSet, saveSumm = TRUE) {
  
  ## list of conditions in the data set
  conditionsList <- unique(dataSet$R.Condition)
  
  ## summarize each protein by conditions
  proteinSummary <- dataSet %>%
    select(-R.Replicate) %>%
    describeBy(group = .$R.Condition)
  
  ## if only two conditions exist, calculate the fold change automatically
  if (length(conditionsList) == 2) {
    proteinSummary[["Fold Change"]] <- (proteinSummary[[1]] - proteinSummary[[2]]) %>%
      select(-n)
    conditionsList <- c(conditionsList, "Fold Change")
  }
  
  ## combine summaries into a single data frame
  proteinSummary <- do.call(rbind, lapply(conditionsList, function(k) {
    data.frame(t(proteinSummary[[k]])) %>%
      select(-"R.Condition") %>%
      rownames_to_column("Stat") %>%
      filter(Stat != "vars") %>%
      mutate(Condition = k, .before = "Stat")
  }))
  
  if (saveSumm) {
    
    ## save file to current working directory
    write.csv(proteinSummary, file = "summarize_data.csv", row.names = FALSE)
  } 
  
  ## return protein data summary
  return(proteinSummary)
}

