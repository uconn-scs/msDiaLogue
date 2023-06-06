
test_that("imputation", {
  
  #Load data from previous step in work flow
  dataTrans <- read.csv("../Unit_Test_Data/TransformedToy.csv")
  #execute current imputation function on data file
  dataImput <- impute(dataTrans)
  #load stored correct data
  storedData <- read.csv("../Unit_Test_Data/ImputedToy.csv")
  #test if current function yields equal results to previous version
  expect_equal(dataImput, storedData)
  
})