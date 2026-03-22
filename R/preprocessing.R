#######################
#### Preprocessing ####
#######################
#'
#' Loading, filtering and reformatting of MS DIA data from Spectronaut
#' 
#' @description
#' Read a data file from Spectronaut, apply filtering conditions, select columns
#' necessary for analysis, and return the reformatted data.
#' 
#' @param fileName The name of the .csv file containing MS data
#' (including the path to the file, if needed).
#' 
#' @param dataSet The raw data set, if already loaded in R.
#' 
#' @param filterNaN A logical value (default = TRUE) specifying whether
#' proteins with NaN should be removed.
#' 
#' @param filterUnique An integer (default = 2) specifying the minimum number of
#' unique peptides required for a protein to be retained in the data set.
#' 
#' @param replaceBlank A logical value (default = TRUE) specifying whether
#' proteins without names should be be named by their accession numbers.
#' 
#' @param saveRm A logical value (default = TRUE) specifying whether
#' to save removed data to current working directory.
#' 
#' @return
#' A preprocessed data frame.
#' 
#' @details
#' The function executes the following:
#' \enumerate{
#' \item Reads the file.
#' \item Applies applicable filters, if necessary.
#' \item Provides summary statistics and a histogram of all values reported
#' in the data set.
#' \item Selects columns that contain necessary information for the analysis.
#' \item Re-formats the data to present individual proteins as columns and
#' group replicates under each protein.
#' \item Stores the data as a \code{data.frame} and prints the levels of
#' condition and replicate to the user.
#' }
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
  
  ## histogram of full raw data
  plotPre <- histPlot(dataSet$PG.Quantity,
                      title = "Histogram of Raw Data Set")
  print(plotPre)
  
  ## filter data
  filteredData <- dataSet
  
  ## filter out the proteins that have no recorded value
  if (filterNaN) {
    if (saveRm) {
      removedData <- filteredData %>%
        filter(is.nan(PG.Quantity))
      write.csv(removedData, file = "preprocess_filterNaN.csv", row.names = FALSE)
    }
    filteredData <- filteredData %>%
      filter(!is.nan(PG.Quantity))
  }
  
  ## filter out proteins with less than 'filterUnique' unique peptides
  if (filterUnique >= 2) {
    if (saveRm) {
      removedData <- filteredData %>%
        filter(PG.NrOfStrippedSequencesIdentified < filterUnique)
      write.csv(removedData, file = "preprocess_filterUnique.csv", row.names = FALSE)
    }
    filteredData <- filteredData %>%
      filter(PG.NrOfStrippedSequencesIdentified >= filterUnique)
  }
  
  ## replace blank protein name entries with their accession numbers
  if (replaceBlank) {
    filteredData <- filteredData %>%
      mutate(PG.ProteinName = if_else(is.na(PG.ProteinName) | PG.ProteinName == "",
                                      PG.ProteinAccession, PG.ProteinName))
  }
  
  proteinInformation <- filteredData %>%
    select(PG.Genes, PG.ProteinAccession, PG.ProteinAccessions,
           PG.ProteinDescriptions, PG.ProteinName, PG.ProteinNames) %>%
    distinct()
  
  ID <- proteinInformation$PG.ProteinName
  duplicateName <- unique(ID[duplicated(ID)])
  
  ## warning catching for duplicated protein names
  if (length(duplicateName) > 0) {
    message("There are duplicated `PG.ProteinName` in the data: ",
            paste(duplicateName, collapse = ", "),
            ".\nAccession numbers have been used to replace duplicate `PG.ProteinName` in all locations.")
    
    idx <- filteredData$PG.ProteinName %in% duplicateName
    filteredData$PG.ProteinName[idx] <- filteredData$PG.ProteinAccession[idx]
    # filteredData <- filteredData %>%
    #   mutate(PG.ProteinName = if_else(PG.ProteinName %in% duplicateName,
    #                                   PG.ProteinAccession, PG.ProteinName))
    
    proteinInformation <- filteredData %>%
      select(PG.Genes, PG.ProteinAccession, PG.ProteinAccessions,
             PG.ProteinDescriptions, PG.ProteinName, PG.ProteinNames) %>%
      distinct()
    
    if (any(duplicated(proteinInformation$PG.ProteinName))) {
      stop("`PG.ProteinName` is still not unique after replacing duplicated names with accession numbers.")
    }
  }
  
  write.csv(proteinInformation, file = "preprocess_protein_information.csv", row.names = FALSE)
  
  ## select columns necessary for analysis
  selectedData <- filteredData %>%
    mutate(R.Condition = factor(as.character(R.Condition),
                                levels = unique(as.character(R.Condition))),
           R.Replicate = factor(as.character(R.Replicate),
                                levels = unique(as.character(R.Replicate)))) %>%
    select(R.Condition, R.Replicate, PG.Quantity, PG.ProteinName, PG.ProteinAccession)
  
  ## print summary statistics
  cat("Summary of Preprocessed Data Signals:\n")
  print(summary(selectedData$PG.Quantity))
  cat("\n")
  
  ## histogram of preprocessed data
  plotPost <- histPlot(selectedData$PG.Quantity,
                       title = "Histogram of Preprocessed Data Set")
  print(plotPost)
  
  ## reformat the data to present proteins as the columns and
  ## to group replicates under each protein
  reformattedData <- selectedData %>%
    pivot_wider(id_cols = c(R.Condition, R.Replicate),
                names_from = PG.ProteinName, values_from = PG.Quantity)
  
  ## store data in a data.frame structure
  result <- as.data.frame(reformattedData)
  
  ## print levels of condition and replicate
  cat("Levels of Condition:", paste(levels(result$R.Condition), collapse = ", "), "\n")
  cat("Levels of Replicate:", paste(levels(result$R.Replicate), collapse = ", "), "\n")
  cat("\n")
  
  ## return pre-processed data
  return(result)
}

##------------------------------------------------------------------------------
#' 
#' Loading and reformatting of MS data from Scaffold
#' 
#' @description
#' Read a data file from Scaffold, select columns necessary for analysis, and
#' return the reformatted data.
#' 
#' @param fileName The name of the .xls file containing MS data
#' (including the path to the file, if needed).
#' 
#' @param dataSet The raw data set, if already loaded in R.
#' 
#' @param zeroNA A logical value (default = TRUE) specifying whether 0's
#' should be converted to NA's.
#' 
#' @param oneNA A logical value (default = TRUE) specifying whether 1's
#' should be converted to NA's.
#' 
#' @return
#' \itemize{
#' \item If the data contains columns for Gene Ontology (GO) annotation terms,
#' the function returns a list containing both a preprocessed data frame and
#' a list of GO terms.
#' \item If no GO annotation columns are present, the function returns only
#' a preprocessed data frame.
#' }
#' 
#' @details
#' The function executes the following:
#' \enumerate{
#' \item Reads the file.
#' \item Provides summary statistics and a histogram of all values reported
#' in the data set.
#' \item Selects columns that contain necessary information for the analysis.
#' \item Re-formats the data to present individual proteins as columns and
#' group replicates under each protein.
#' \item Stores the data as a \code{data.frame} and prints the levels of
#' condition and replicate to the user.
#' }
#' 
#' @importFrom readxl read_excel
#' @importFrom purrr discard map
#' 
#' @autoglobal
#' 
#' @export

preprocessing_scaffold <- function(fileName, dataSet = NULL,
                                   zeroNA = TRUE, oneNA = TRUE) {
  
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

