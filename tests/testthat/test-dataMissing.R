
test_that("dataMissing", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'dataMissing' on data file
  invisible(capture.output(
    data <- dataMissing(dataSet)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/dataMissing_Toy.csv", row.names = 1)
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})