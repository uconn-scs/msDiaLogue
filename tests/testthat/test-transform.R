test_that("transformation", {
  
  #Load data from previous step in work flow
  dataFilterOutIn <- read.csv("../Unit_Test_Data/HorseFilteredToy.csv")
  #execute current tranformation function on data file
  dataTrans <- transform(dataFilterOutIn, logFold = 2)
  #load stored correct data
  storedData <- read.csv("../Unit_Test_Data/TransformedToy.csv")
  #test if current function yields equal results to previous version
  expect_equal(dataTrans, storedData)
  
})