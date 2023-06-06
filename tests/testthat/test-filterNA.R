test_that("NA Filter", {
  
  #Load data from previous step in work flow
  dataImput <- read.csv("../Unit_Test_Data/ImputedToy.csv")
  #execute current filter NA function on data file
  dataNAFilter <- filterNA(dataImput)
  #load stored correct data
  storedData <- read.csv("../Unit_Test_Data/NAFilteredToy.csv")
  #test if current function yields equal results to previous version
  expect_equal(dataNAFilter, storedData)
  
})