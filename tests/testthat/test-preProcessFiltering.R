
test_that("preProcessFiltering", {
  
  ## start with name of raw data file
  fileName <- "../testData/Toy_Spectronaut_Data.csv"
  
  ## load the raw data file
  dataSet <- read.csv(fileName)
  
  ## execute current function 'preProcessFiltering' on raw data file
  invisible(capture.output(
    data <- preProcessFiltering(dataSet, filterNaN = TRUE, filterUnique = 2,
                                replaceBlank = TRUE, saveRm = FALSE)))
  ## load stored correct data 
  storedData <- read.csv("../storedData/preProcessFiltering_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})