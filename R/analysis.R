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
#' @param conditions A string specifying which two conditions to compare. This argument
#' only works when there are more than two conditions in \code{dataSet}.
#' 
#' @param testType A string (default = "t-test") specifying which statistical test to use:
#' \enumerate{
#' \item "t-test": unequal variance t-test.
#' \item "mod.t-test": moderated t-test (Smyth, 2004).
#' \item "MA": output to plot an MA plot.
#' }
#' 
#' @import dplyr
#' @import limma
#' @importFrom stats model.matrix
#' @importFrom tibble rownames_to_column
#' 
#' @returns A 2d dataframe includes the following information: \itemize{
#' \item "t-test" or "mod.t-test": The differences in means and P-values for each protein
#' between the two conditions. Note that the differences are calculated by subtracting the
#' mean of the second condition from the mean of the first condition (Condition 1 -
#' Condition 2).
#' \item "MA": Protein-wise averages within each condition.
#' }
#' 
#' @references
#' Smyth, Gordon K. (2004).
#' Linear Models and Empirical Bayes Methods for Assessing Differential Expression in
#' Microarray Experiments.
#' \emph{Statistical Applications in Genetics and Molecular Biology}, 3(1).
#' 
#' @export

analyze <- function(dataSet, conditions, testType = "t-test") {
  
  ## check for exactly two conditions
  if (missing(conditions)) {
    conditions <- unique(dataSet$R.Condition)
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
      select(filteredData, -c("R.Condition", "R.FileName", "R.Replicate")), 2,
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
    conditions <- factor(filteredData$R.Condition, labels = LETTERS[1:2])
    design <- model.matrix(~ 0 + conditions)
    
    ## fit linear model for each protein
    fit1 <- limma::lmFit(
      t(select(filteredData, -c("R.Condition", "R.FileName", "R.Replicate"))), design)
    
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
      summarise(across(-c("R.FileName", "R.Replicate"), mean)) %>%
      column_to_rownames("R.Condition")
    
  }
  
  ## return to the analysis result
  return(result)
}

