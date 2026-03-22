###################
#### Filtering ####
###################
#'
#' Filter proteins by list or pattern
#' 
#' @description
#' Apply a series of filtering steps to the data set.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @param listName A character vector specifying
#' proteins for exact matching to select or remove.
#' 
#' @param regexName A character vector specifying
#' proteins for regular expression pattern matching to select or remove.
#' 
#' @param by A character string (default = "PG.ProteinName" for Spectronaut,
#' default = "AccessionNumber" for Scaffold) specifying
#' the information to which \code{listName} and/or \code{regexName} filter
#' is applied. Allowable options include:
#' \itemize{
#' \item For Spectronaut: "PG.Genes", "PG.ProteinAccession",
#' "PG.ProteinDescriptions", and "PG.ProteinName".
#' \item For Scaffold: "ProteinDescriptions", "AccessionNumber", and
#' "AlternateID".
#' }
#' 
#' @param removeList A logical value (default = TRUE) specifying whether
#' the list of proteins should be removed or selected.
#' \itemize{
#' \item TRUE: Remove the list of proteins from the data set.
#' \item FALSE: Remove all proteins not in the list from the data set.
#' }
#' 
#' @param saveRm A logical value (default = TRUE) specifying whether
#' to save removed data to current working directory.
#' This option only works when \code{removeList = TRUE}.
#' 
#' @return
#' A filtered data frame.
#' 
#' @details
#' If both \code{listName} and \code{regexName} are provided, the proteins
#' selected or removed will be the union of those specified in \code{listName}
#' and those matching the regex pattern in \code{regexName}.
#' 
#' @export

filterOutIn <- function(dataSet,
                        listName = c(),
                        regexName = c(),
                        by = NULL,
                        removeList = TRUE,
                        saveRm = TRUE) {
  
  ## relabel the data frame
  filteredData <- dataSet %>%
    select(-c(R.Condition, R.Replicate))
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- "Visible?" %in% colnames(information)
  IDcol <- if (scaffoldCheck) "AccessionNumber" else "PG.ProteinName"
  by <- if (is.null(by)) IDcol else by
  
  ## only list filter if listName is present
  if (length(listName) != 0) {
    listIndex <- which(information[[by]] %in% listName)
  } else {
    listIndex <- NULL
  }
  
  ## only regex filter if regexName is present
  if (length(regexName) != 0) {
    regexIndex <- grep(paste(regexName, collapse = "|"), information[[by]])
  } else {
    regexIndex <- NULL
  }
  
  ## combine protein names from list and regex filters
  unionIndex <- sort(union(listIndex, regexIndex))
  unionName <- information[unionIndex, IDcol]
  
  ## create a dataframe of the data of proteins
  unionData <- dataSet %>%
    select(any_of(c("R.Condition", "R.Replicate", unionName)))
  
  ## if contaminants are being removed
  if (removeList == TRUE) {
    
    ## save removed data to current working directory
    if (saveRm) {
      unionData_long <- unionData %>%
        pivot_longer(-c("R.Condition", "R.Replicate"), names_to = IDcol, values_to = "PG.Quantity") %>%
        left_join(information, by = IDcol) %>%
        arrange(match(.data[[IDcol]], unionName), R.Condition)
      write.xlsx(list(unionData, unionData_long), file = "filterOutIn.xlsx")
    }
    
    ## remove all of the contaminants if they are present
    filteredData <- dataSet %>% select(-any_of(unionName))
    
    ## if certain proteins are being selected
  } else if (removeList == FALSE) {
    
    ## select only proteins of interest
    filteredData <- unionData
  }
  
  ## return the filtered data
  return(filteredData)
}

##------------------------------------------------------------------------------
#' 
#' Filter proteins by non-missing proportion
#' 
#' @description
#' Remove proteins with NA values.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @param minProp A numeric value (default = 0.51) specifying the minimum
#' non-missing proportion required for a protein to be retained.
#' 
#' @param by A character string (default = "cond") specifying
#' how coverage is evaluated.
#' \itemize{
#' \item \code{"cond"}: The non-missing proportion for a protein must be
#' at least \code{minProp} within each condition. Proteins failing in any
#' condition are filtered out. 
#' \item \code{"all"}: The overall non-missing proportion across all samples
#' must be at least \code{minProp}.
#' }
#' 
#' @param saveRm A logical value (default = TRUE) specifying whether
#' to save removed data to current working directory.
#' 
#' @return
#' A filtered data frame.
#' 
#' @export

filterNA <- function(dataSet, minProp = 0.51, by = "cond", saveRm = TRUE) {
  
  ## 0/1 non-missing indicator: 1 present, 0 missing
  prot_cols <- setdiff(names(dataSet), c("R.Condition", "R.Replicate"))
  nonmissing01 <- dataSet[, prot_cols, drop = FALSE] %>%
    as.matrix() %>%
    is.na() %>%
    (\(x) !x)() * 1
  cond <- dataSet$R.Condition
  
  if (by == "cond") {
    ## non-missing counts per condition x protein
    nonmissing_n <- rowsum(nonmissing01, group = cond, reorder = FALSE)
    ## samples per condition
    n_per_cond <- as.integer(table(cond))
    ## non-missing proportion per condition x protein
    prop_nonmissing <- sweep(nonmissing_n, 1, n_per_cond, "/")
    keep <- colSums(prop_nonmissing < minProp) == 0
  } else {
    keep <- (colMeans(nonmissing01) >= minProp)
  }
  
  keep_proteins <- prot_cols[keep]
  filteredData <- dataSet[, c("R.Condition", "R.Replicate", keep_proteins), drop = FALSE]
  
  if (saveRm) {
    
    drop_proteins <- prot_cols[!keep]
    removedData <- dataSet[, c("R.Condition", "R.Replicate", drop_proteins), drop = FALSE]
    
    information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
    scaffoldCheck <- any(colnames(information) == "Visible?")
    IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
    
    ## save removed data to current working directory
    removedData_long <- removedData %>%
      pivot_longer(-c("R.Condition", "R.Replicate"), names_to = IDcol, values_to = "PG.Quantity") %>%
      left_join(information, by = IDcol)
    
    write.xlsx(list(removedData, removedData_long), file = "filterNA.xlsx")
    
  }
  
  ## return the filtered data
  return(filteredData)
}

