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
#' @param show_labels A boolean (default = TRUE) specifying whether protein names are
#' shown in the visualization.
#' 
#' @import dplyr
#' @importFrom visdat vis_miss
#' 
#' @returns A 2d dataframe with the number and percent of missing data for every protein.
#' 
#' @export

dataMissing <- function(dataSet, show_labels = TRUE) {
  dataMissing <- select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate"))
  if (show_labels == TRUE) {
    plot <- visdat::vis_miss(dataMissing)
  } else {
    plotData <- dataMissing
    colnames(plotData) <- sprintf("%0*d", nchar(ncol(dataMissing)), 1:ncol(dataMissing))
    plot <- visdat::vis_miss(plotData) +
      ggplot2::scale_x_discrete(labels = element_blank())
  }
  print(plot)
  result <- data.frame(n_miss = colSums(is.na(dataMissing)))
  result$pct_miss <- result$n_miss/sum(result$n_miss)*100
  return(as.data.frame(t(result)))
}

