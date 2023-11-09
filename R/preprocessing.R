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
#' @importFrom utils read.csv
#' 
#' @returns A 2d dataframe.
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
  
  ## filter data by NaN and unique peptide count
  filteredData <- preProcessFiltering(dataSet, filterNaN, filterUnique, replaceBlank, saveRm)
  
  ## select columns necessary for analysis
  selectedData <- filteredData %>%
    select(c(R.Condition, R.FileName, R.Replicate, PG.Quantity,
             PG.ProteinNames, PG.ProteinAccessions))
  
  ## print summary statistics for full raw data set
  cat("Summary of full data signals (raw)")
  print(summary(selectedData$PG.Quantity))
  cat("\n")
  
  ## generate a histogram of the log2-transformed values for full data set
  ggplot(data.frame(value = log2(selectedData$PG.Quantity))) +
    geom_histogram(aes(x = value),
                   breaks = seq(floor(min(log2(selectedData$PG.Quantity))),
                                ceiling(max(log2(selectedData$PG.Quantity))), 1),
                   color = "black", fill = "gray") +
    scale_x_continuous(breaks = seq(floor(min(log2(selectedData$PG.Quantity))),
                                    ceiling(max(log2(selectedData$PG.Quantity))), 2)) +
    labs(title = "Histogram of Full Data Set",
         x = expression("log"[2]*"(Data)"), y = "Frequency") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  
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

