
test_that("impute", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute(dataSet, imputeType = "LocalMinVal",
                   reqPercentPresent = 51, reportImputing = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})