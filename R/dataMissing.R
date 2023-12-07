########################################
#### Code for counting missing data ####
########################################
#' 
#' Counting missing data
#' 
#' @description
#' Calculate the count of missing data.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @import dplyr
#' @importFrom visdat vis_miss
#' 
#' @returns A 2d dataframe with the number and percent of missing data for every protein.
#' 
#' @export

dataMissing <- function(dataSet) {
  dataMissing <- select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate"))
  plot <- visdat::vis_miss(dataMissing)
  print(plot)
  result <- data.frame(n_miss = colSums(is.na(dataMissing)))
  result$pct_miss <- result$n_miss/sum(result$n_miss)*100
  return(result)
}

