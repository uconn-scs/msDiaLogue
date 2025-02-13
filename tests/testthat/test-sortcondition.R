
test_that("sortcondition", {
  
  ## load data from previous step in work flow
  load("../storedData/preprocessing_Toy.RData")
  
  ## execute current function 'sortcondition' on data file
  invisible(capture.output(
    data <- sortcondition(preprocessing_Toy)
  ))
  
  ## load stored correct data
  load("../storedData/sortcondition_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, sortcondition_Toy)
  
})