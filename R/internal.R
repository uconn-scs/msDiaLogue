##################
#### Internal ####
##################
#'
#' Extract the first name from semicolon-separated names
#'
#' @description
#' Take a character vector whose elements may contain multiple names separated
#' by semicolons. For each element, retain the first name and annotate it with
#' the number of additional names (e.g., "A;B;C" becomes "A (+2)").
#' If \code{marker} is provided and any separated name contains the marker,
#' include the marker in the annotation unless the retained first name already
#' contains it (e.g., "A;CON__B;C" becomes "A (+2, CON__)").
#'
#' @param vecName A character vector whose elements may contain multiple names
#' separated by semicolons.
#'
#' @param marker An optional character string (default = NULL) used to identify
#' specially marked names. If any separated name contains \code{marker},
#' the marker is included in the annotation unless it is already present in
#' the retained first name.
#'
#' @return
#' A character vector of the same length as \code{vecName}.
#'
#' @noRd

firstName <- function(vecName, marker = NULL) {
  sapply(vecName, function(element) {
    parts <- trimws(unlist(strsplit(element, ";", fixed = TRUE)))
    first <- parts[1]
    hasMarker <- !is.null(marker) &&
      any(grepl(marker, parts, fixed = TRUE), na.rm = TRUE)
    firstHasMarker <- !is.null(marker) && !is.na(first) &&
      grepl(marker, first, fixed = TRUE)
    if (length(parts) > 1) {
      annotation <- length(parts) - 1
      if (hasMarker && !firstHasMarker) {
        annotation <- sprintf("%d, %s", annotation, marker)
      }
      sprintf("%s (+%s)", first, annotation)
    } else {
      first
    }
  })
}

##------------------------------------------------------------------------------
#' 
#' Plot histogram of log2-transformed data
#' 
#' @description
#' Generate a histogram of log2-transformed protein abundance values.
#' 
#' @param x A numeric vector containing the data signals.
#' 
#' @param title A character string specifying the plot title.
#' 
#' @return
#' An object of class \code{plot}.
#' 
#' @noRd

histPlot <- function(x, title = "") {
  x <- log2(x)
  ggplot(data.frame(value = x)) +
    geom_histogram(aes(x = value),
                   breaks = seq(floor(min(x, na.rm = TRUE)),
                                ceiling(max(x, na.rm = TRUE)), 1),
                   color = "black", fill = "gray") +
    scale_x_continuous(breaks = seq(floor(min(x, na.rm = TRUE)),
                                    ceiling(max(x, na.rm = TRUE)), 2)) +
    labs(title = title, x = expression("log"[2]*"(Data)"), y = "Frequency") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
}

##------------------------------------------------------------------------------
#' 
#' Plot a graph of mean versus variance
#' 
#' @description
#' Take a set of protein data organized by column, calculate the mean and
#' variance of each column, and then plot those statistics.
#' 
#' @param datMV A data frame containing the data signals.
#' 
#' @param title A character string specifying the plot title.
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

