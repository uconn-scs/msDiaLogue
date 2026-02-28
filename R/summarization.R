#######################
#### Summarization ####
#######################
#' 
#' Summarize protein intensities across conditions 
#' 
#' @description
#' Report basic summary statistics for protein across every condition.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @param saveSumm A logical value (default = TRUE) specifying whether
#' to save the summary statistics to current working directory.
#' 
#' @return
#' A summarized data frame.
#' 
#' @details
#' The column "Stat" in the generated data frame includes the following
#' statistics:
#' \itemize{
#' \item n: Number.
#' \item mean: Mean.
#' \item sd: Standard deviation.
#' \item median: Median.
#' \item trimmed: Trimmed mean with a trim of 0.1.
#' \item mad: Median absolute deviation (from the median).
#' \item min: Minimum.
#' \item max: Maximum.
#' \item range: The difference between the maximum and minimum value.
#' \item skew: Skewness.
#' \item kurtosis: Kurtosis.
#' \item se: Standard error.
#' }
#' 
#' @importFrom psych describeBy
#' 
#' @export

summarize <- function(dataSet, saveSumm = TRUE) {
  
  ## list of conditions in the data set
  conditionsList <- unique(dataSet$R.Condition)
  
  ## summarize each protein by conditions
  proteinSummary <- dataSet %>%
    select(-R.Replicate) %>%
    describeBy(group = .$R.Condition)
  
  ## if only two conditions exist, calculate the fold change automatically
  if (length(conditionsList) == 2) {
    proteinSummary[["Fold Change"]] <- (proteinSummary[[1]] - proteinSummary[[2]]) %>%
      select(-n)
    conditionsList <- c(conditionsList, "Fold Change")
  }
  
  ## combine summaries into a single data frame
  proteinSummary <- do.call(rbind, lapply(conditionsList, function(k) {
    data.frame(t(proteinSummary[[k]]), check.names = FALSE) %>%
      select(-"R.Condition") %>%
      rownames_to_column("Stat") %>%
      filter(Stat != "vars") %>%
      mutate(R.Condition = k, .before = "Stat")
  }))
  
  if (saveSumm) {
    
    ## save file to current working directory
    write.csv(proteinSummary, file = "summarize.csv", row.names = FALSE)
  } 
  
  ## return protein data summary
  return(proteinSummary)
}

