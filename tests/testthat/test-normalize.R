
test_that("normalize", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(dataSet, normalizeType = "mean")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/normalize_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})