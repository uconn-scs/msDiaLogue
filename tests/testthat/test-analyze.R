test_that("analyze (Volcano)", {
  
  #Load data from previous step in work flow
  dataNorm <- read.csv("../Unit_Test_Data/MeanNormalizedToy.csv")
  #set the condiions to compare
  compareValues <- c("100fmol","50fmol") 
  #execute current analyze function on data file
  testOutput <- analyze(dataNorm, compareValues, testType = "volcano")
  #load stored correct data, making sure to enter row names
  storedData <- read.csv("../Unit_Test_Data/VolcanoDataToy.csv")
  rownames(storedData) <- storedData$X
  storedData$X <- NULL
  #test if current function yields equal results to previous version
  expect_equal(testOutput, storedData)
  
})

test_that("analyze (T-Test)", {
  
  #Load data from previous step in work flow
  dataNorm <- read.csv("../Unit_Test_Data/MeanNormalizedToy.csv")
  #set the condiions to compare
  compareValues <- c("100fmol","50fmol") 
  #execute current analyze function on data file
  testOutput <- analyze(dataNorm, compareValues, testType = "t-test")
  #load stored correct data, making sure to enter row names
  storedData <- read.csv("../Unit_Test_Data/TTestDataToy.csv")
  rownames(storedData) <- storedData$X
  storedData$X <- NULL
  #test if current function yields equal results to previous version
  expect_equal(testOutput, storedData)
  
})


test_that("analyze (MA)", {
  
  #Load data from previous step in work flow
  dataNorm <- read.csv("../Unit_Test_Data/MeanNormalizedToy.csv")
  #set the condiions to compare
  compareValues <- c("100fmol","50fmol") 
  #execute current analyze function on data file
  testOutput <<- analyze(dataNorm, compareValues, testType = "MA")
  #load stored correct data, making sure to enter row names
  storedData <- read.csv("../Unit_Test_Data/MADataToy.csv")
  rownames(storedData) <- storedData$X
  storedData$X <- NULL
  #test if current function yields equal results to previous version
  expect_equal(testOutput, storedData)
  
})