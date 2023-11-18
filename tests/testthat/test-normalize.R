
test_that("normalize_quant", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/transform_Toy.csv")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(dataSet, normalizeType = "quant")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("normalize_median", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/transform_Toy.csv")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(dataSet, normalizeType = "median")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/normalize_median_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("normalize_mean", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/transform_Toy.csv")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(dataSet, normalizeType = "mean")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/normalize_mean_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})