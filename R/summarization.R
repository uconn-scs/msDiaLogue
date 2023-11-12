###############################
#### Code for data summary ####
###############################
#' 
#' Summarize protein intensities across conditions 
#' 
#' @description
#' Calculate the mean, standard deviation, and replicate count for protein across every
#' condition.
#' 
#' @param dataSet A data frame containing the data signals and labels.
#' 
#' @param digits An integer (default = 2) indicating the number of decimal places.
#' 
#' @param saveSumm A boolean (default = TRUE) specifying whether to save the summary
#' statistics to current working directory.
#' 
#' A string which can be used to generate a csv file of the summary
#' statistics.
#' 
#' @import dplyr
#' @importFrom psych describeBy
#' @importFrom tibble rownames_to_column
#' 
#' @returns A 2d summarized data frame.
#' 
#' @export

summarize <- function(dataSet, digits = 2, saveSumm = TRUE) {
  
  ## list of conditions in the data set
  conditionsList <- unique(dataSet$R.Condition)
  
  ## summarize each protein by conditions
  proteinSummary <- dataSet %>%
    select(-c(R.FileName, R.Replicate)) %>%
    describeBy(group = .$R.Condition, digits = digits)
  
  ## if only two conditions exist, calculate the fold change automatically
  if (length(conditionsList) == 2) {
    proteinSummary[["Fold Change"]] <- (proteinSummary[[2]] - proteinSummary[[1]]) %>%
      select(-n)
    conditionsList <- c(conditionsList, "Fold Change")
  }
  
  ## combine summaries into a single data frame
  proteinSummary <- do.call(rbind, lapply(conditionsList, function(k) {
    data.frame(t(proteinSummary[[k]])) %>%
      select(-"R.Condition.") %>%
      rownames_to_column("Stat") %>%
      filter(Stat != "vars") %>%
      mutate(Condition = k, .before = "Stat")
  }))
  
  if (saveSumm) {
    
    ## save file to current working directory
    write.csv(proteinSummary, file = "summarize_data.csv")
  } 
  
  ## return protein data summary
  return(proteinSummary)
}

