
test_that("filterOutIn", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/transform_Toy.csv")
  
  ## execute current function 'filterOutIn' on data file
  invisible(capture.output(
    data <- filterOutIn(dataSet, listName = "ALBU_BOVIN", regexName = "HUMAN",
                        removeList = TRUE, saveRm = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/filterOutIn_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})