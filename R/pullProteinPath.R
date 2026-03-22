#' 
#' Compiling data on a single protein from each step in the process
#' 
#' @description
#' Summarize the steps performed on the data for one protein.
#' 
#' @param listName A character vector specifying
#' proteins for exact matching.
#' 
#' @param regexName A character vector specifying
#' proteins for regular expression pattern matching.
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
#' @param dataSetList A list of data frames, the order dictates the order of
#' presentation.
#' 
#' @return
#' A data frame, with the protein data at each step present
#' in the \code{dataSetList}.
#' 
#' @export

pullProteinPath <- function(listName = c(), regexName = c(), by = NULL,
                            dataSetList) {
  
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
  unionIndex <- union(listIndex, regexIndex)
  unionName <- information[unionIndex, IDcol]
  
  proteinPath <- do.call(rbind, lapply(unionName, function(name) {
    cbind(dataSetList[[1]][c("R.Condition", "R.Replicate")],
          name,
          sapply(dataSetList, function(data) data[[name]] %||% NA))
  }))
  
  colnames(proteinPath)[colnames(proteinPath) == "name"] <- by
  
  result <- merge(information[unionIndex,], proteinPath,
                  by = by, sort = TRUE)
  
  return(result)
}

