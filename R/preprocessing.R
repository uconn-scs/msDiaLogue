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

######################################
#### Code for data pre-processing ####
######################################
#'
#' Loading, filtering and reformatting of MS DIA data
#' 
#' @description
#' Read a .csv file, apply filtering conditions, select columns necessary for analysis,
#' and return the reformatted data.
#' 
#' @param fileName The name of the .csv file containing MS data (including the path to the
#' file, if needed).
#' 
#' @param dataSet The raw data set, if already loaded in R.
#' 
#' @param filterNaN A boolean (default = TRUE) specifying whether observations including
#' NaN should be omitted.
#' 
#' @param filterUnique An integer (default = 2) specifying how many number of unique
#' peptides are required to include a protein.
#' 
#' @param replaceBlank A boolean (default = TRUE) specifying whether proteins without names
#' should be be named by their accession numbers.
#' 
#' @param saveRm A boolean (default = TRUE) specifying whether to save removed data to
#' current working directory.
#' 
#' @details
#' The function executes the following:
#' \enumerate{
#' \item Reads the file.
#' \item Applies applicable filters, if necessary.
#' \item Provides summary statistics and a histogram of all values reported in the data set.
#' \item Selects columns that contain necessary information for the analysis.
#' \item Re-formats the data to present individual proteins as columns and group replicates
#' under each protein.
#' \item Stores the data as a \code{data.frame} and prints a subset of columns to provide
#' a visual example to the user.
#' }
#' 
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom utils read.csv write.csv
#' 
#' @returns A 2d dataframe.
#' 
#' @autoglobal
#' 
#' @export

preprocessing <- function(fileName,
                          dataSet = NULL,
                          filterNaN = TRUE,
                          filterUnique = 2,
                          replaceBlank = TRUE,
                          saveRm = TRUE) {
  
  if (missing(fileName)) {
    if (is.null(dataSet)) {
      stop("Either 'fileName' or 'dataSet' must be provided.")
    }
  } else {
    ## read in the protein quantitative csv file generated from Spectranaut
    dataSet <- read.csv(fileName)
  }
  
  ## generate a histogram of the log2-transformed values for full raw data set
  temp <- log2(dataSet$PG.Quantity)
  plot <- ggplot(data.frame(value = temp)) +
    geom_histogram(aes(x = value),
                   breaks = seq(floor(min(temp, na.rm = TRUE)),
                                ceiling(max(temp, na.rm = TRUE)), 1),
                   color = "black", fill = "gray") +
    scale_x_continuous(breaks = seq(floor(min(temp, na.rm = TRUE)),
                                    ceiling(max(temp, na.rm = TRUE)), 2)) +
    labs(title = "Histogram of Full Raw Data Set",
         x = expression("log"[2]*"(Data)"), y = "Frequency") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  print(plot)
  
  proteinInformation <- dataSet %>%
    select(c("PG.Genes", "PG.ProteinAccessions",
             "PG.ProteinDescriptions", "PG.ProteinNames")) %>%
    distinct()
  
  write.csv(proteinInformation, file = "full_protein_information.csv", row.names = FALSE)
  
  ## filter data by NaN and unique peptide count
  filteredData <- preProcessFiltering(dataSet, filterNaN, filterUnique, replaceBlank, saveRm)
  
  proteinInformation <- filteredData %>%
    select(c("PG.Genes", "PG.ProteinAccessions",
             "PG.ProteinDescriptions", "PG.ProteinNames")) %>%
    distinct()
  
  write.csv(proteinInformation, file = "preprocess_protein_information.csv", row.names = FALSE)
  
  ## select columns necessary for analysis
  selectedData <- filteredData %>%
    select(c(R.Condition, R.FileName, R.Replicate, PG.Quantity,
             PG.ProteinNames, PG.ProteinAccessions))
  
  ## print summary statistics for full raw data set
  cat("Summary of full data signals (raw)")
  print(summary(selectedData$PG.Quantity))
  cat("\n")
  
  ## generate a histogram of the log2-transformed values for full preprocessed data set
  temp <- log2(selectedData$PG.Quantity)
  plot <- ggplot(data.frame(value = temp)) +
    geom_histogram(aes(x = value),
                   breaks = seq(floor(min(temp, na.rm = TRUE)),
                                ceiling(max(temp, na.rm = TRUE)), 1),
                   color = "black", fill = "gray") +
    scale_x_continuous(breaks = seq(floor(min(temp, na.rm = TRUE)),
                                    ceiling(max(temp, na.rm = TRUE)), 2)) +
    labs(title = "Histogram of Full Preprocessed Data Set",
         x = expression("log"[2]*"(Data)"), y = "Frequency") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
   print(plot)
  
  ## warning catching for duplicated protein names
  reformatedData <- tryCatch({
    
    ## try to reformat the data to present proteins as the columns and
    ## to group replicates under each protein
    reformatedData <- selectedData %>% pivot_wider(
      id_cols = c(R.Condition, R.FileName, R.Replicate),
      names_from = PG.ProteinNames, values_from = PG.Quantity)
    
  }, warning = function(w) {
    
    ## if a warning is thrown for duplicated protein names being stored as list
    message(paste(
      w, "There are duplicated protein names in your data.\n",
      "Accession numbers have been used to replace duplicate names in all locations."))
    
    ## compile a database if the entries with duplicates
    warningTmp <- selectedData %>%
      dplyr::group_by(R.Condition, R.FileName, R.Replicate, PG.ProteinNames) %>%
      dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
      dplyr::filter(n > 1L)
    
    ## create a unique list of duplicated values
    duplicateName <- unique(warningTmp$PG.ProteinNames)
    
    ## for each duplicate protein, replace all instances of the name,
    ## with the accession numbers
    for (i in duplicateName) {
      selectedData <- selectedData %>%
        mutate(PG.ProteinNames = ifelse(
          PG.ProteinNames == duplicateName, PG.ProteinAccessions, PG.ProteinNames))
    }
    
    ## try to reformat the data again
    reformatedData <- selectedData %>%
      pivot_wider(id_cols = c(R.Condition, R.FileName, R.Replicate),
                  names_from = PG.ProteinNames, values_from = PG.Quantity)
    return(reformatedData)
  })
  
  ## store data in a data.frame structure
  loadedData <- data.frame(reformatedData) 
  
  ## provide sample data for visual inspection
  cat("Example Structure of Pre-Processed Data")
  print(loadedData[,1:5])
  
  ## return pre-processed data
  return(loadedData)
}

