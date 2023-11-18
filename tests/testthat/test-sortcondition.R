
test_that("sortcondition", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/preprocessing_Toy.csv")
  
  ## execute current function 'sortcondition' on data file
  invisible(capture.output(
    data <- sortcondition(dataSet)
  ))
  
  ## load stored correct data
  load("../storedData/sortcondition_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})