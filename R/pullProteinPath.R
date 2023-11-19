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
#' @export

pullProteinPath <- function(proteinName, dataSetList) {
  
  proteinPath <- cbind(dataSetList[[1]][c("R.Condition", "R.FileName", "R.Replicate")],
                       sapply(dataSetList, function(mat) mat[[proteinName]]))
  
  ## return the path of data for this protein
  return(proteinPath)
}

