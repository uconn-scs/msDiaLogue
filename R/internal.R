##################
#### Internal ####
##################
#'
#' Extract the first name from a semicolon-separated names
#'
#' @description
#' Take a character vector. If an element contains multiple names separated by
#' semicolons (e.g., "A;B;C"), only the first name is kept and annotated with
#' the number of additional names (e.g., "A (+2)"). Single names (e.g., "A")
#' are returned unchanged.
#'
#' @param vecName A character vector, with elements possibly containing multiple
#' names separated by semicolons.
#'
#' @return
#' A character vector of the same length as \code{vecName}, with either
#' the original name (if only one) or the first name followed by the count of
#' additional names.
#'
#' @noRd

firstName <- function(vecName) {
  sapply(vecName, function(element) {
    parts <- unlist(strsplit(element, ";", fixed = TRUE))
    if (length(parts) > 1) {
      paste0(parts[1], " (+", length(parts)-1, ")")
    } else {
      element
    }
  })
}

##------------------------------------------------------------------------------
#' 
#' Plotting a graph of mean versus variance
#' 
#' @description
#' Take a set of protein data organized by column, calculate the mean and
#' variance of each column, and then plot those statistics.
#' 
#' @param datMV A data frame containing the data signals.
#' 
#' @param title A character string with the desired title for the mean-variance
#' plot.
#' 
#' @return
#' An object of class \code{plot}.
#' 
#' @autoglobal
#' 
#' @noRd

meanVarPlot <- function(datMV, title = "") {
  
  ## calculate the mean and variance for each protein individually
  plotData <- data.frame(t(sapply(datMV, function(x) {
    c(Mean = mean(x, na.rm = TRUE), Variance = var(x, na.rm = TRUE))
  })))
  
  ## plot the mean-variance relationship
  ggplot(plotData, aes(Mean, Variance)) +
    geom_point() +
    labs(title = title) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
}

##------------------------------------------------------------------------------
#' 
#' Create a condition-by-protein presence matrix
#' 
#' @description
#' Create a dictionary in which each unique experimental condition serves as
#' a key, mapped to the set of proteins that contain at least one observed
#' (non-NA) value under that condition.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @return
#' A data frame with one row per protein and one column per experimental
#' condition. Each entry is `TRUE` if that protein has at least one non-missing
#' value under the given condition and `FALSE` otherwise.
#' 
#' @noRd

sortcondition <- function(dataSet) {
  
  ## calculate how many values are present from each condition by protein
  dataCounts <- dataSet %>%
    ## do not include columns that are strings
    select(!R.Replicate) %>%
    ## group by experimental condition
    group_by(R.Condition) %>%
    ## apply to every numeric function a summation of the non-NA values
    summarise(across(where(is.numeric), ~sum(!is.na(.x)))) %>%
    column_to_rownames("R.Condition") %>%
    ## binarize the count results
    mutate(across(everything(), ~ifelse(.x > 0, TRUE, FALSE))) %>%
    t() %>%
    as.data.frame()
  
  return(dataCounts)
}

