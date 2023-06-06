
test_that("preprocessing", {
  
  #Start with name of raw data file
  name <- "../Unit_Test_Data/Toy_Spectronaut_Data.csv"
  #execute current preprocessing function on raw data file
  invisible(capture.output(data <- preprocessing(name, filterUnique = 2, filterNaN = TRUE)))
  #load stored correct data 
  storedData <- read.csv("../Unit_Test_Data/preprocessedToy.csv")
  #test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})
