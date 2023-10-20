######################################
#### Code for data transformation ####
######################################
# @references
# \itemize{
# \item Archer, K. J., Dumur, C. I. and Ramakrishnan, V. (2004).
# "Graphical Technique for Identifying a Monotonic Variance Stabilizing Transformation for
# Absolute Gene Intensity Signals".
# \emph{BMC Bioinformatics}, 5, 60.
# \href{https://doi.org/10.1186/1471-2105-5-60}{DOI}.
# \item Kammers, K., Cole, R. N., Tiengwe, C. and Ruczinski, I. (2015).
# "Detecting Significant Changes in Protein Abundance".
# \emph{EuPA Open Proteomics}, 7, 11--19.
# \href{https://doi.org/10.1016/j.euprot.2015.02.002}{DOI}.
# }
#' 
#' Plotting a graph of mean versus variance
#' 
#' @description
#' Take a set of protein data organized by column, calculate the mean and variance of each
#' column, and then plot those statistics.
#' 
#' @param datMV A data frame containing the data signals.
#' 
#' @param title A string with the desired title for the mean-variance plot.
#' 
#' @importFrom stats var median
#' 
#' @returns An object of class \code{plot}.
#' 
#' @export

meanVariancePlot <- function(datMV, title = "") {
  
  ## calculate the mean and variance for each protein individually
  Variance <- sapply(datMV, function(x) var(x, na.rm=TRUE))
  Mean <- sapply(datMV, function(x) mean(x, na.rm=TRUE))
  
  ## plot the mean-variance relationship
  plot(Mean, Variance, main = title, xlab = "Mean", ylab = "Variance")
}


##----------------------------------------------------------------------------------------
#' 
#' Log-based transformation
#' 
#' @description
#' Apply a logarithmic transformation to the data to stabilize the variance.
#'  
#' @param dataSet A data frame containing the data signals.
#'  
#' @param logFold An integer specifying the base for the log transformation.
#' 
#' @details
#' The function executes the following:
#' \enumerate{
#' \item Plots the mean-variance relationship using \code{meanVariancePlot()}.
#' \item Log-transforms the data, using the specified base.
#' \item Plots the mean-variance relationship again for comparison.
#' }
#' 
#' @returns The transformed data.
#' 
#' @export

transform <- function(dataSet, logFold = 2) {
  
  ## define the number of proteins that are present in data set
  index <- dim(dataSet)[2]
  
  ## separate the data set into labels and numerical data
  ## labels consist of the first 2 columns, data is everything else
  dataLabels <- dataSet[,1:3]
  dataPoints <- dataSet[,4:index]
  
  ## calculate and plot a mean-variance plot 
  meanVariancePlot(dataPoints, title = "Pre-Transformation")
  
  ## take the log of the numerical data
  transDataPoints <- log(dataPoints, logFold)
  
  ## calculate and plot a mean-variance plot 
  meanVariancePlot(transDataPoints,  title = "Post-Transformation")
  
  ## recombine the labels and transformed data into a single data frame
  transDataSet <- cbind(dataLabels, transDataPoints)
  
  ## return the transformed data
  return(transDataSet)
}

