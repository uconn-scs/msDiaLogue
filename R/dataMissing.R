########################################
#### Code for counting missing data ####
########################################
#' 
#' Counting missing data
#' 
#' @description
#' Calculate and plot the missingness.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @param plot A boolean (default = FALSE) specifying whether to plot the missingness.
#' 
#' @param show_labels A boolean (default = TRUE) specifying whether protein names are
#' shown in the visualization when \code{plot = TRUE}.
#' 
#' @import dplyr
#' @import ggplot2
#' @importFrom visdat vis_miss
#' 
#' @returns A 2d dataframe including:
#' \itemize{
#' \item "count_miss": The count of missing values for each protein.
#' \item "pct-miss": The percentage of missing values for each protein.
#' \item "pct_total_miss": The percentage of missing values for each protein relative to
#' the total missing values in the entire dataset.
#' }
#' 
#' @autoglobal
#' 
#' @export

dataMissing <- function(dataSet, plot = FALSE, show_labels = TRUE) {
  dataMissing <- select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate"))
  if (plot == TRUE) {
    if (show_labels == TRUE) {
      plot <- visdat::vis_miss(dataMissing)
    } else {
      plotData <- dataMissing
      colnames(plotData) <- sprintf("%0*d", nchar(ncol(dataMissing)), 1:ncol(dataMissing))
      plot <- visdat::vis_miss(plotData) +
        ggplot2::scale_x_discrete(labels = element_blank())
    }
    print(plot)
  }
  
  count_miss <- colSums(is.na(dataMissing))
  result <- data.frame(count_miss,
                       pct_miss = count_miss/nrow(dataMissing)*100,
                       pct_total_miss = count_miss/sum(count_miss)*100)
  return(as.data.frame(t(result)))
}

