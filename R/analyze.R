##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2024  Shiying Xiao, Timothy Moore and Charles Watt
## Shiying Xiao <shiying.xiao@uconn.edu>
##
## This file is part of the R package msDiaLogue.
##
## The R package msDiaLogue is free software: You can redistribute it and/or
## modify it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or any later
## version (at your option). See the GNU General Public License at
## <https://www.gnu.org/licenses/> for details.
##
## The R package msDiaLogue is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##

################################
#### Code for data analysis ####
################################
#' 
#' Analyzing summarized data
#' 
#' @description
#' Apply a statistical test to the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param conditions A string specifying which two conditions to compare. The order is
#' important, as the second condition serves as the reference for comparison. When there
#' are two conditions in \code{dataSet} and this argument is not specified, the
#' \code{conditions} will automatically be selected by sorting the unique values
#' alphabetically and in ascending order.
#' 
#' @param testType A string (default = "t-test") specifying which statistical test to use:
#' \enumerate{
#' \item "t-test": Unequal variance t-test.
#' \item "mod.t-test": Moderated t-test \insertCite{smyth2004linear}{msDiaLogue}.
#' \item "MA": Output to plot an MA plot.
#' }
#' 
#' @details
#' The second condition serves as the reference for comparison. \itemize{
#' \item "t-test" and "mod.t-test": The differences are calculated by subtracting
#' the mean of the second condition from the mean of the first condition (Condition 1 -
#' Condition 2).
#' \item "MA": The rows are ordered by \code{conditions}. Specifically, the first row
#' corresponds to the protein-wise average of the first condition, and the second row
#' corresponds to the second condition.
#' }
#' 
#' @import dplyr
#' @import limma
#' @importFrom stats model.matrix t.test
#' @importFrom tibble column_to_rownames
#' @importFrom Rdpack reprompt
#' 
#' @returns A 2d dataframe includes the following information: \itemize{
#' \item "t-test" or "mod.t-test": The differences in means and P-values for each protein
#' between the two conditions.
#' \item "MA": Protein-wise averages within each condition.
#' }
#' 
#' @references
#' \insertAllCited{}
#' 
#' @autoglobal
#' 
#' @export

analyze <- function(dataSet, conditions, testType = "t-test") {
  
  ## check for exactly two conditions
  if (missing(conditions)) {
    conditions <- sort(unique(dataSet$R.Condition))
    if (length(conditions) != 2) {
      stop("Please provide exactly two conditions for comparison.")
    }
  } else if (length(conditions) != 2) {
    stop("This analysis can only be performed on two conditions at a time.
         Please select exactly two conditions to compare.
         Alternatively, please consider using ANOVA.")
  }
  
  ## filter data set by the conditions
  filteredData <- dataSet %>%
    filter(R.Condition %in% conditions) %>%
    arrange(R.Condition, R.Replicate)
  
  if (testType == "t-test") {
    
    ## index of the two conditions
    indexA <- which(filteredData$R.Condition == conditions[1])
    indexB <- which(filteredData$R.Condition == conditions[2])
    
    ## the difference in means (log fold change for volcano) and the P-value of t-test
    result <- as.data.frame(apply(
      select(filteredData, -c(R.Condition, R.Replicate)), 2,
      function(x) {
        tryCatch(
          c("Difference" = mean(x[indexA])-mean(x[indexB]),
            "P-value" = t.test(x[indexA], x[indexB])$p.value),
          
          ## if an error is thrown, return the fold change and set the P-value to 'NA'.
          error = function(e) {
            message("Data are essentially constant.")
            c("Difference" = mean(x[indexA])-mean(x[indexB]), "P-value" = NA)
          }
        )
      }
    ))
    
  } else if (testType == "mod.t-test") {
    
    ## construct the design matrix
    conditions <- factor(filteredData$R.Condition, levels = conditions, labels = LETTERS[1:2])
    design <- model.matrix(~ 0 + conditions)
    
    ## fit linear model for each protein
    fit1 <- limma::lmFit(
      t(select(filteredData, -c(R.Condition, R.Replicate))), design)
    
    ## construct the contrast matrix
    cont.matrix <- limma::makeContrasts("conditionsA - conditionsB", levels = design)
    
    ## compute contrasts from linear model 'fit1'
    fit2 <- limma::contrasts.fit(fit1, cont.matrix)
    
    ## empirical Bayes statistics
    fit3 <- limma::eBayes(fit2)
    
    result <- as.data.frame(t(cbind(fit3$coefficients, fit3$p.value)))
    rownames(result) <- c("Difference", "P-value")
    
  } else if (testType == "MA") {
    
    ## the average of each condition individually
    result <- filteredData %>%
      group_by(R.Condition) %>%
      summarise(across(-c("R.Replicate"), mean)) %>%
      arrange(factor(R.Condition, levels = conditions)) %>%
      column_to_rownames("R.Condition")
      
  }
  
  ## return to the analysis result
  return(result)
}

