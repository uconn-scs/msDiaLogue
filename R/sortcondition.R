##################################
#### Code for data imputation ####
##################################
#' 
#' Creating a keyed list of conditions to the list of proteins that are present
#' 
#' @description
#' Create a keyed dictionary, where every unique experimental condition is the label for
#' a list of every protein that has a value for that condition.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @import dplyr
#' @import tidyr
#' 
#' @returns A list of lists.
#' 
#' @export

sortcondition <- function(dataSet) {
  
  ## create a list of the unique condition names
  conditionList <- unique(dataSet$R.Condition)
  
  ## calculate how many values are present from each condition by protein
  dtaCounts <- dataSet %>%
    ## do not include columns that are strings
    select(!c(R.FileName, R.Replicate)) %>%
    ## group by experimental condition
    group_by(R.Condition) %>%
    ## apply to every numeric function a summation of the non-NA values
    summarise(across(where(is.numeric), ~sum(!is.na(.x))))
  
  ## initialize a list to populate with the keyed dictionary entries
  conditionProteinDict <- list()
  
  ## go through each condition in the experiment
  for (condition in conditionList) {
    
    ## select only the data from this condition
    dtaTmp <- dtaCounts[dtaCounts$R.Condition == condition, -1]
    
    ## find the columns that have values greater than 0
    dtaTmp <- dtaTmp[which(dtaTmp > 0)]
    
    ## create a temporary list of the column names that are remained
    listTmp <- as.list(names(dtaTmp))
    
    ## assign the temporary list to the condition name in the output list
    conditionProteinDict [[toString(condition)]] <- listTmp
  }
  
  ## return the keyed dictionary
  return(conditionProteinDict)
}

