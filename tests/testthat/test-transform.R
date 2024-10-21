
test_that("transformation", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/preprocessing_Toy.csv")
  
  ## execute current function 'transform' on data file
  invisible(capture.output(
    data <- transform(dataSet, logFold = 2)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/transform_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})