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
#' \item "mod.t-test": moderated t-test.
#' \item "volcano": output to plot a volcano plot.
#' \item "MA": output to plot an MA plot.
#' }
#' 
#' @import dplyr
#' @import limma
#' @importFrom stats model.matrix
#' @importFrom tibble rownames_to_column
#' 
#' @returns A 2d dataframe with differences of means and P-values for every protein across
#' the two conditions.
#' 
#' @export

analyze <- function(dataSet, conditions, testType = "t-test") {
  
  ## check for exactly two conditions
  if (missing(conditions)) {
    conditions <- unique(dataSet$R.Condition)
    stopifnot(
      "Please provide exactly two conditions for comparison." =
        length(conditions) == 2
    )
  } else {
    stopifnot(
      "This analysis can only be performed on two conditions at a time.
      Please select exactly two conditions to compare.
      Alternatively, please consider using ANOVA." =
        length(conditions) == 2
    )
  }
  
  ## filter data set by the conditions
  filteredData <- dataSet %>%
    filter(R.Condition %in% conditions) %>%
    arrange(R.Condition, R.Replicate)
  
  if (testType %in% c("t-test", "volcano")) {
    
    ## index of the two conditions
    indexA <- which(filteredData$R.Condition == conditions[1])
    indexB <- which(filteredData$R.Condition == conditions[2])
    
    result <- tryCatch({
      ## the difference in means (log fold change for volcano) and the P-value of t-test
      as.data.frame(apply(
        select(filteredData, -c("R.Condition", "R.FileName", "R.Replicate")),
        2, function(x) {
          c(mean(x[indexA])-mean(x[indexB]), t.test(x[indexA], x[indexB])$p.value)
        }
      ))
      
    }, error = function(cond) {
      ## if an error is thrown, catch it and print that the data are constant to keep the
      ## program from ending.
      message("Data are essentially constant.")
      return(1)
    })
    
    rownames(result) <- c(ifelse(testType == "t-test",
                                 "Difference in Means", "Log Fold Change"),
                          "P-value")
    
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
    rownames(result) <- c("Difference in Means", "P-value")
    
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

