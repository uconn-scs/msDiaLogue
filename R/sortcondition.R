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

#' Creating a keyed list of conditions to the list of proteins that are present
#' 
#' @description
#' Create a keyed dictionary, where every unique experimental condition is the label for
#' a list of every protein that has a value for that condition.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @import dplyr
#' @importFrom stats setNames
#' @importFrom tibble column_to_rownames
#' 
#' @returns A list of lists.
#' 
#' @autoglobal
#' 
#' @export

sortcondition <- function(dataSet) {
  
  ## calculate how many values are present from each condition by protein
  dataCounts <- dataSet %>%
    ## do not include columns that are strings
    select(!R.Replicate) %>%
    ## group by experimental condition
    group_by(R.Condition) %>%
    ## apply to every numeric function a summation of the non-NA values
    summarise(across(where(is.numeric), ~sum(!is.na(.x)))) %>%
    column_to_rownames("R.Condition")
  
  ## create the keyed dictionary
  conditionProteinDict <- setNames(apply(dataCounts, 1, function(row) {
    names(row[row > 0])
  }, simplify = FALSE), rownames(dataCounts))
  
  ## return the keyed dictionary
  return(conditionProteinDict)
}

