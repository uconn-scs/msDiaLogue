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

#' Compiling data on a single protein from each step in the process
#' 
#' @description
#' Summarize the steps performed on the data for one protein.
#' 
#' @param proteinName A string identifying the protein of interest.
#' 
#' @param dataSetList A list of data frames, the order dictates the order of presentation.
#' 
#' @details \code{proteinName} must match the labels in the data sets exactly.
#' 
#' @returns A 2d dataframe, with the protein data at each step present in the \code{dataSetList}.
#' 
#' @autoglobal
#' 
#' @export

pullProteinPath <- function(proteinName, dataSetList) {
  
  proteinPath <- cbind(dataSetList[[1]][c("R.Condition", "R.Replicate")],
                       sapply(dataSetList, function(mat) mat[[proteinName]]))
  
  ## return the path of data for this protein
  return(proteinPath)
}

