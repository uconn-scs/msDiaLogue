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

#' Create a condition-by-protein presence matrix
#' 
#' @description
#' Create a dictionary in which each unique experimental condition serves as
#' a key, mapped to the set of proteins that contain at least one observed
#' (non-NA) value under that condition.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @return
#' A data frame with one row per protein and one column per experimental
#' condition. Each entry is `TRUE` if that protein has at least one non-missing
#' value under the given condition and `FALSE` otherwise.
#' 
#' @noRd

sortcondition <- function(dataSet) {
  
  ## calculate how many values are present from each condition by protein
  dataCounts <- dataSet %>%
    ## do not include columns that are strings
    select(!R.Replicate) %>%
    ## group by experimental condition
    group_by(R.Condition) %>%
    ## apply to every numeric function a summation of the non-NA values
    summarise(across(where(is.numeric), ~sum(!is.na(.x)))) %>%
    column_to_rownames("R.Condition") %>%
    ## binarize the count results
    mutate(across(everything(), ~ifelse(.x > 0, TRUE, FALSE))) %>%
    t() %>%
    as.data.frame()
  
  return(dataCounts)
}

