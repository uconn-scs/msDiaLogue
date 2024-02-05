
test_that("filterNA", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/impute.min_local_Toy.csv")
  
  ## execute current function 'filterNA' on data file
  invisible(capture.output(
    data <- filterNA(dataSet, saveRm = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})