
test_that("transformation", {
  
  ## load data from previous step in work flow
  load("../storedData/preprocessing_Toy.RData")
  
  ## execute current function 'transform' on data file
  invisible(capture.output(
    data <- transform(preprocessing_Toy, method = "log", logFold = 2)
  ))
  
  ## load stored correct data
  load("../storedData/transform_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, transform_Toy)
  
})