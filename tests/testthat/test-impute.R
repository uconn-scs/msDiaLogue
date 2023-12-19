
test_that("impute_LocalMinVal", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute(dataSet, imputeType = "LocalMinVal",
                   reqPercentPresent = 0.51, reportImputing = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute_LocalMinVal_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute_GlobalMinVal", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute(dataSet, imputeType = "GlobalMinVal", reportImputing = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute_GlobalMinVal_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute_knn", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute(dataSet, imputeType = "knn",
                   k = 10, rowmax = 0.5, colmax = 0.8, maxp = 1500, rng.seed = 362436069,
                   reportImputing = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute_knn_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute_seq-knn", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute(dataSet, imputeType = "seq-knn", k = 10, reportImputing = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute_seq_knn_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})