#' Creating a keyed list of conditions to the list of proteins that are present
#' 
#' @description
#' Create a keyed dictionary, where every unique experimental condition is the label for
#' a list of every protein that has a value for that condition.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @import dplyr
#' @importFrom stats setNames
#' @importFrom tibble column_to_rownames
#' 
#' @returns A list of lists.
#' 
#' @export

sortcondition <- function(dataSet) {
  
  ## calculate how many values are present from each condition by protein
  dataCounts <- dataSet %>%
    ## do not include columns that are strings
    select(!c(R.FileName, R.Replicate)) %>%
    ## group by experimental condition
    group_by(R.Condition) %>%
    ## apply to every numeric function a summation of the non-NA values
    summarise(across(where(is.numeric), ~sum(!is.na(.x)))) %>%
    column_to_rownames("R.Condition")
  
  ## create the keyed dictionary
  conditionProteinDict <- setNames(apply(dataCounts, 1, function(row) {
    names(row[row > 0])
  }, simplify = FALSE), rownames(dataCounts))
  
  ## return the keyed dictionary
  return(conditionProteinDict)
}

