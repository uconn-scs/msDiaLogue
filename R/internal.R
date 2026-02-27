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

