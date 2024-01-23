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
#' @param saveSumm A boolean (default = TRUE) specifying whether to save the summary
#' statistics to current working directory.
#' 
#' @details
#' The column 'Stat' in the generated data.frame includes the following statistics:
#' \itemize{
#' \item n: number.
#' \item mean: mean.
#' \item sd: standard deviation.
#' \item median: median.
#' \item trimmed: trimmed mean with a trim of 0.1.
#' \item mad: median absolute deviation (from the median).
#' \item min: minimum.
#' \item max: maximum.
#' \item range: the difference between the maximum and minimum value.
#' \item skew: skewness.
#' \item kurtosis: kurtosis.
#' \item se: standard error.
#' }
#' 
#' @import dplyr
#' @importFrom psych describeBy
#' @importFrom tibble rownames_to_column
#' 
#' @returns A 2d summarized data frame.
#' 
#' @export

summarize <- function(dataSet, saveSumm = TRUE) {
  
  ## list of conditions in the data set
  conditionsList <- unique(dataSet$R.Condition)
  
  ## summarize each protein by conditions
  proteinSummary <- dataSet %>%
    select(-c(R.FileName, R.Replicate)) %>%
    describeBy(group = .$R.Condition)
  
  ## if only two conditions exist, calculate the fold change automatically
  if (length(conditionsList) == 2) {
    proteinSummary[["Fold Change"]] <- (proteinSummary[[2]] - proteinSummary[[1]]) %>%
      select(-n)
    conditionsList <- c(conditionsList, "Fold Change")
  }
  
  ## combine summaries into a single data frame
  proteinSummary <- do.call(rbind, lapply(conditionsList, function(k) {
    data.frame(t(proteinSummary[[k]])) %>%
      select(-"R.Condition") %>%
      rownames_to_column("Stat") %>%
      filter(Stat != "vars") %>%
      mutate(Condition = k, .before = "Stat")
  }))
  
  if (saveSumm) {
    
    ## save file to current working directory
    write.csv(proteinSummary, file = "summarize_data.csv", row.names = FALSE)
  } 
  
  ## return protein data summary
  return(proteinSummary)
}

