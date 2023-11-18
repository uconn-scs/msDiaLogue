
test_that("analyze_t-test", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(dataSet, testType = "t-test")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/analyze_t-test_Toy.csv", row.names = 1)
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("analyze_mod.t-test", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(dataSet, testType = "mod.t-test")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/analyze_mod.t-test_Toy.csv", row.names = 1)
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("analyze_volcano", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(dataSet[,colnames(dataSet) != c("TEBP_HUMAN", "T126B_HUMAN")], testType = "volcano")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/analyze_volcano_Toy.csv", row.names = 1)
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("analyze_MA", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(dataSet, testType = "MA")
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/analyze_MA_Toy.csv", row.names = 1)
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})