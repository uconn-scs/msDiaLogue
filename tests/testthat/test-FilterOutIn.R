
test_that("filter 1", {
  
  #Load data from previous step in work flow
  data <- read.csv("../Unit_Test_Data/preprocessedToy.csv")
  #execute current filter function on data file
  dataFilter<- filterOutIn(data, TRUE, c("MYG_HORSE"))
  #load stored correct data
  storedData <- read.csv("../Unit_Test_Data/HorseFilteredToy.csv")
  #test if current function yields equal results to previous version
  expect_equal(dataFilter, storedData)
  
})