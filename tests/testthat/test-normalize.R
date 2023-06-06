test_that("normalize", {
  
  #Load data from previous step in work flow
  dataNAFilter <- read.csv("../Unit_Test_Data/NAFilteredToy.csv")
  #execute current normalize function on data file
  dataNorm <- normalize(dataNAFilter, normalizeType = "Mean")
  #load stored correct data
  storedData <- read.csv("../Unit_Test_Data/MeanNormalizedToy.csv")
  #testing force integer rows, NOT SURE WHY NECESSARY
  row.names(dataNorm) <- as.integer(row.names(dataNorm))
  #test if current function yields equal results to previous version
  expect_equal(dataNorm, storedData)
  
})