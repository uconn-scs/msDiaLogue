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
#### Code for data pre-processing ####
######################################
#'
#' Extract the first name from a semicolon-separated names
#'
#' @description
#' Take a character vector. If an element contains multiple names separated by semicolons
#' (e.g., "A;B;C"), only the first name is kept and annotated with the number of
#' additional names (e.g., "A (+2)"). Single names (e.g., "A") are returned unchanged.
#'
#' @param vecName A character vector, with elements possibly containing multiple names
#' separated by semicolons.
#'
#' @return A character vector of the same length as \code{vecName}, with either the
#' original name (if only one) or the first name followed by the count of additional names.
#'
#' @noRd

firstName <- function(vecName) {
  sapply(vecName, function(element) {
    parts <- unlist(strsplit(element, ";", fixed = TRUE))
    if (length(parts) > 1) {
      paste0(parts[1], " (+", length(parts)-1, ")")
    } else {
      element
    }
  })
}


##----------------------------------------------------------------------------------------
#'
#' Loading, filtering and reformatting of MS DIA data from Spectronaut
#' 
#' @description
#' Read a data file from Spectronaut, apply filtering conditions, select columns necessary
#' for analysis, and return the reformatted data.
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
#' \item Stores the data as a \code{data.frame} and prints the levels of condition and
#' replicate to the user.
#' }
#' 
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom utils read.csv write.csv
#' 
#' @return
#' A 2d dataframe.
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
  
  ## keep only the first entry of protein names and accessions
  dataSet <- dataSet %>%
    mutate(PG.ProteinName = firstName(PG.ProteinNames),
           PG.ProteinAccession = firstName(PG.ProteinAccessions))
  
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
  
  ## filter data by NaN and unique peptide count
  filteredData <- preProcessFiltering(dataSet, filterNaN, filterUnique, replaceBlank, saveRm)
  
  proteinInformation <- filteredData %>%
    select(PG.Genes, PG.ProteinAccession, PG.ProteinAccessions, PG.ProteinDescriptions, PG.ProteinName, PG.ProteinNames) %>%
    distinct()
  
  write.csv(proteinInformation, file = "preprocess_protein_information.csv", row.names = FALSE)
  
  ## select columns necessary for analysis
  selectedData <- filteredData %>%
    mutate(R.Condition = factor(as.character(R.Condition), levels = unique(as.character(R.Condition))),
           R.Replicate = factor(as.character(R.Replicate), levels = unique(as.character(R.Replicate)))) %>%
    select(R.Condition, R.Replicate, PG.Quantity, PG.ProteinName, PG.ProteinAccession)
  
  ## print summary statistics for full raw data set
  cat("Summary of Full Data Signals (Raw):\n")
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
      id_cols = c(R.Condition, R.Replicate),
      names_from = PG.ProteinName, values_from = PG.Quantity)
    
  }, warning = function(w) {
    
    ## if a warning is thrown for duplicated protein names being stored as list
    message(paste(
      w, "There are duplicated protein names in your data.\n",
      "Accession numbers have been used to replace duplicate names in all locations."))
    
    ## compile a database if the entries with duplicates
    warningTmp <- selectedData %>%
      dplyr::group_by(R.Condition, R.Replicate, PG.ProteinName) %>%
      dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
      dplyr::filter(n > 1L)
    
    ## create a unique list of duplicated values
    duplicateName <- unique(warningTmp$PG.ProteinName)
    
    ## for each duplicate protein, replace all instances of the name,
    ## with the accession numbers
    for (i in duplicateName) {
      selectedData <- selectedData %>%
        mutate(PG.ProteinName = ifelse(
          PG.ProteinName == i, PG.ProteinAccession, PG.ProteinName))
    }
    
    ## try to reformat the data again
    reformatedData <- selectedData %>%
      pivot_wider(id_cols = c(R.Condition, R.Replicate),
                  names_from = PG.ProteinName, values_from = PG.Quantity)
    return(reformatedData)
  })
  
  ## store data in a data.frame structure
  result <- as.data.frame(reformatedData)
  
  ## print levels of condition and replicate
  cat("Levels of Condition:", levels(result$R.Condition), "\n")
  cat("Levels of Replicate:", levels(result$R.Replicate), "\n")
  cat("\n")
  
  ## return pre-processed data
  return(result)
}


##----------------------------------------------------------------------------------------
#' 
#' Loading and reformatting of MS data from Scaffold
#' 
#' @description
#' Read a data file from Scaffold, select columns necessary for analysis, and return the
#' reformatted data.
#' 
#' @param fileName The name of the .xls file containing MS data (including the path to the
#' file, if needed).
#' 
#' @param dataSet The raw data set, if already loaded in R.
#' 
#' @param zeroNA A boolean (default = TRUE) specifying whether 0's should be converted to
#' NA's.
#' 
#' @param oneNA A boolean (default = TRUE) specifying whether 1's should be converted to
#' NA's.
#' 
#' @details
#' The function executes the following:
#' \enumerate{
#' \item Reads the file.
#' \item Provides summary statistics and a histogram of all values reported in the data set.
#' \item Selects columns that contain necessary information for the analysis.
#' \item Re-formats the data to present individual proteins as columns and group replicates
#' under each protein.
#' \item Stores the data as a \code{data.frame} and prints the levels of condition and
#' replicate to the user.
#' }
#' 
#' @importFrom readxl read_excel
#' @importFrom purrr discard map
#' 
#' @return
#' \itemize{
#' \item If the data contains columns for Gene Ontology (GO) annotation terms,
#' the function returns a list containing both the preprocessed 2d dataframe and a list of
#' GO terms.
#' \item If no GO annotation columns are present, the function returns only the
#' preprocessed 2d dataframe.
#' }
#' 
#' @autoglobal
#' 
#' @export

preprocessing_scaffold <- function(fileName, dataSet = NULL, zeroNA = TRUE, oneNA = TRUE) {
  
  if (missing(fileName)) {
    if (is.null(dataSet)) {
      stop("Either 'fileName' or 'dataSet' must be provided.")
    }
  } else {
    ## read in the protein quantitative csv file generated from Scaffold
    dataSet <- suppressWarnings(readxl::read_excel(fileName, col_names = FALSE))
  }
  
  header_row <- which(dataSet[[1]] == "#")
  colnames(dataSet) <- dataSet[header_row,]
  dataSet <- select(dataSet, -"#")
  noGO_col <- which(!is.na(dataSet[1,]))
  
  dataSet <- dataSet %>%
    slice(-(1:header_row)) %>%
    slice(-n()) %>%
    rename(ProteinDescriptions = names(.)[3])
  
  colnames(dataSet) <- gsub(" ", "", colnames(dataSet))
  
  # dataSet <- dataSet %>%
  #   mutate(AccessionNumber = paste0("00", AccessionNumber))
  
  infoColName <- c("Visible?", "Starred?",
                   "ProteinDescriptions", "AccessionNumber", "AlternateID",
                   "MolecularWeight", "ProteinGroupingAmbiguity",
                   if (header_row != 1) {"Taxonomy"})
  
  if (header_row != 1) {
    noGO_col <- c(which(infoColName %in% colnames(dataSet)), noGO_col)
  }
  
  proteinInformation <- dataSet %>%
    select(any_of(infoColName)) %>%
    distinct()
  
  write.csv(proteinInformation, file = "preprocess_protein_information.csv",
            row.names = FALSE, na = "")
  
  ## select columns necessary for analysis
  selectedData <- dataSet[,noGO_col] %>%
    select(-any_of(infoColName[infoColName != "AccessionNumber"])) %>%
    mutate(across(-AccessionNumber, ~as.numeric(replace(., . == "Missing Value", NA)))) %>%
    pivot_longer(-AccessionNumber, names_to = "ConditionReplicate", values_to = "Quantity") %>%
    # gather(ConditionReplicate, Quantity, -AccessionNumber) %>%
    mutate(R.Condition = sub("^(?:.*_)?([^_]+)[-_][^_]+$", "\\1", ConditionReplicate),
           R.Replicate = sub(".+[-_](.+)$", "\\1", ConditionReplicate)) %>%
    select(R.Condition, R.Replicate, AccessionNumber, Quantity)
  
  if (zeroNA) {
    selectedData$Quantity[selectedData$Quantity == 0] <- NA
  }
  
  if (oneNA) {
    selectedData$Quantity[selectedData$Quantity == 1] <- NA
  }
  
  if (header_row != 1) {
    GOterm <- dataSet[,-noGO_col] %>%
      mutate(AccessionNumber = dataSet$AccessionNumber, .before = 1) %>%
      filter(rowSums(!is.na(.[-1])) != 0) %>%
      split(.$AccessionNumber) %>%
      purrr::map(~ .x %>%
                   select(-AccessionNumber) %>%
                   purrr::discard(is.na) %>%
                   as.list())
      # pivot_longer(cols = -AccessionNumber, values_drop_na = TRUE,
      #              names_to = "Ontology", values_to = "Name")
  }
  
  ## reformat the data to present proteins as the columns and
  ## to group replicates under each protein
  reformatedData <- selectedData %>%
    pivot_wider(id_cols = c(R.Condition, R.Replicate),
                names_from = AccessionNumber, values_from = Quantity)
  # spread(AccessionNumber, Quantity)
  
  ## generate a histogram of the log2-transformed values for full data set
  ## note: the Scaffold is a preprocessed data report.
  temp <- reformatedData %>%
    select(-c("R.Condition", "R.Replicate")) %>%
    unlist() %>%
    as.vector() %>%
    log2()
  plot <- ggplot(data.frame(value = temp)) +
    geom_histogram(aes(x = value),
                   breaks = seq(floor(min(temp, na.rm = TRUE)),
                                ceiling(max(temp, na.rm = TRUE)), 1),
                   color = "black", fill = "gray") +
    scale_x_continuous(breaks = seq(floor(min(temp, na.rm = TRUE)),
                                    ceiling(max(temp, na.rm = TRUE)), 2)) +
    labs(title = "Histogram of Full Data Set",
         x = expression("log"[2]*"(Data)"), y = "Frequency") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  print(plot)
  
  ## print summary statistics for full data set
  cat("Summary of Full Data Signals:\n")
  print(summary(selectedData$Quantity))
  cat("\n")
  
  ## store data in a data.frame structure
  result <- as.data.frame(reformatedData)
  
  ## print levels of condition and replicate
  cat("Levels of Condition:", unique(result$R.Condition), "\n")
  cat("Levels of Replicate:", unique(result$R.Replicate), "\n")
  cat("\n")
  
  if (header_row != 1) {
    result <- list(data = result, GOterm = GOterm)
  }
  
  ## return imported data
  return(result)
}

