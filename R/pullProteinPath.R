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
## The R package msDiaLogue is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##

#' Compiling data on a single protein from each step in the process
#' 
#' @description
#' Summarize the steps performed on the data for one protein.
#' 
#' @param listName A character vector identifying the proteins of interest.
#' 
#' @param regexName A character vector specifying the proteins for regular expression
#' pattern matching.
#' 
#' @param dataSetList A list of data frames, the order dictates the order of presentation.
#' 
#' @param proteinInformation The name of the .csv file containing protein information data
#' (including the path to the file, if needed). This file is automatically generated by
#' the function \code{\link[msDiaLogue]{preprocessing}}.
#' 
#' @returns A 2d dataframe, with the protein data at each step present in the \code{dataSetList}.
#' 
#' @autoglobal
#' 
#' @export

pullProteinPath <- function(listName = NULL, regexName = NULL, dataSetList,
                            proteinInformation = "preprocess_protein_information.csv") {
  
  allnames <- colnames(dataSetList[[1]])[!colnames(dataSetList[[1]]) %in% c("R.Condition", "R.Replicate")]
  
  ## only list filter if listName is present
  if (!is.null(listName)) {
    listName <- allnames[which(allnames %in% listName)]
  }
  
  ## only regex filter if regexName is present
  if (!is.null(regexName)) {
    regexName <- grep(paste(regexName, collapse = "|"), allnames, value = TRUE)
  }
  
  ## combine protein names from list and regex filters
  unionName <- union(listName, regexName)
  
  proteinPath <- do.call(rbind, lapply(unionName, function(name) {
    cbind(dataSetList[[1]][c("R.Condition", "R.Replicate")],
          Protein = name,
          sapply(dataSetList, function(data) data[[name]]))
  }))
  
  if (!is.null(proteinInformation)) {
    proteinInformation <- read.csv(proteinInformation)
    proteinPath <- merge(proteinPath, proteinInformation,
                         by.x = "Protein", by.y = "PG.ProteinNames", sort = FALSE)
  }
  
  ## return the path of data for this protein
  return(proteinPath)
}

